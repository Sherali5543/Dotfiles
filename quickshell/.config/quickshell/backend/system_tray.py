#!/usr/bin/env python3

from __future__ import annotations

import asyncio
import time
import ctypes
import json
import os
import signal
import subprocess
from dataclasses import dataclass, field

from dbus_fast import Message, MessageType, Variant
from dbus_fast.aio import MessageBus

SOCKET_PATH = "/tmp/quickshell_tray.sock"

APP_NAME = "QuickshellShell"

NOTIFIER_DEST = "org.kde.StatusNotifierWatcher"
NOTIFIER_PATH = "/StatusNotifierWatcher"
NOTIF_INTERFACE = "com.canonical.dbusmenu"
NOTIF_PATH = "/com/canonical/dbusmenu"  # Actually changes

"""
~ Retrieves all registered stuff
❯ busctl --user get-property \
          org.kde.StatusNotifierWatcher \
          /StatusNotifierWatcher \
          org.kde.StatusNotifierWatcher \
          RegisteredStatusNotifierItems
"""
"""
~ Get all properties of application
❯ busctl --user call \
          :1.165 \
          /StatusNotifierItem \
          org.freedesktop.DBus.Properties \
          GetAll \
          s \
          org.kde.StatusNotifierItem
"""
"""
~ Get the menu
❯ busctl --user call \
          :1.165 \
          /com/canonical/dbusmenu \
          com.canonical.dbusmenu \
          GetLayout \
          iias \
          -- \
          0 -1 0
"""
"""
~ Respond an action
❯ busctl --user call \
      :1.165 \
      /com/canonical/dbusmenu \
      com.canonical.dbusmenu \
      Event \
      isvu \
      -- \
      1 \
      clicked \
      u 0 \
      0
"""


# GetLayout - Get the action menu array
# Event - Something happened to the menu
# # opened - opened menu
# # closed - closed menu
# # id, clicked - action menu item clicked
@dataclass
class MenuItem:
    id: int
    properties: dict = field(default_factory=dict)
    children: list[MenuItem] = field(default_factory=list)

    @property
    def label(self) -> str:
        """Helper to safely extract and clean the display label."""
        label_str = self.properties.get("label", "")
        # Strip DBus mnemonics (e.g. "_File" -> "File", "E_xit" -> "Exit")
        return label_str.replace("_", "")

    @property
    def is_submenu(self) -> bool:
        """Determines if this item drops down into more items."""
        return (
            self.properties.get("children-display") == "submenu"
            or len(self.children) > 0
        )

    @property
    def is_separator(self) -> bool:
        """Determines if this item is a visual divider line."""
        return self.properties.get("type") == "separator"

    @property 
    def toggle_type(self) -> str:
        """Toggle type of this entry [checkmark]"""
        return self.properties.get("toggle-type")

    @property 
    def toggle_state(self) -> bool:
        """If toggle is active"""
        return self.properties.get("toggle-state") == 1

    def to_dict(self) -> dict:
        """Recursively packs the menu layout into a clean dictionary for JSON serialization."""
        return {
            "id": self.id,
            "label": self.label,
            "is_submenu": self.is_submenu,
            "is_separator": self.is_separator,
            "toggle_type": self.toggle_type,
            "toggle_state": self.toggle_state,
            # Strip deep internal properties to save bandwidth if you want,
            # or pass along everything:
            "enabled": self.properties.get("enabled", True),
            "children": [child.to_dict() for child in self.children],
        }


@dataclass
class Application:
    id: str  # Unique DBus unique name sender (e.g. ':1.165')
    static_id: str  # Application id (e.g. vesktop)
    notifier_path: str  # e.g. '/StatusNotifierItem'
    menu_path: str  # e.g. '/com/canonical/dbusmenu'
    root_menu: MenuItem | None = None  # The recursively parsed tree root


class SystemTrayBackend:
    def __init__(self):
        self.bus = None
        self.clients = set()
        self.applications = dict()

    async def init_dbus(self):
        self.bus = await MessageBus().connect()
        await self.bus.call(
            Message(
                destination="org.freedesktop.DBus",
                path="/org/freedesktop/DBus",
                interface="org.freedesktop.DBus",
                member="AddMatch",
                signature="s",
                body=["type='signal'"],  # Broad rule: send me ALL signals
            )
        )
        self.bus.add_message_handler(self.handle_dbus_signal)
        print("Dbus initialized")

    def handle_dbus_signal(self, msg: Message):
        print("A signal")
        if msg.interface == "org.kde.StatusNotifierWatcher":
            if msg.member == "StatusNotifierItemRegistered":
                print("I AM NOTIFIER THING")
                print(msg.body)
                self.handle_registered(msg.body)

    async def send_getall(self, dest: str, path: str):
        reply = await self.bus.call(
            Message(
                destination=dest,
                path=path,
                interface="org.freedesktop.DBus.Properties",
                member="GetAll",
                signature="s",
                body=["org.kde.StatusNotifierItem"],
                message_type=MessageType.METHOD_CALL,
            )
        )
        if reply.message_type == MessageType.ERROR:
            print(f"Error fetching properties: {reply.body}")
            return

        if not ("Menu" in reply.body[0]):
            print(f"Error no menu exposed: {reply.body}")
            return

        menu_path = reply.body[0]["Menu"].value
        static_id = reply.body[0]["Id"].value

        # Create application with an empty root_menu for now
        app = Application(
            id=dest, static_id=static_id, notifier_path=path, menu_path=menu_path
        )

        self.applications[static_id] = app

    async def get_action_menu(self, static_id: str):
        if static_id not in self.applications:
            return

        reply = await self.bus.call(
            Message(
                destination=self.applications[static_id].id,
                path=self.applications[static_id].menu_path,
                interface=NOTIF_INTERFACE,
                member="GetLayout",
                signature="iias",
                body=[0, -1, []],
            )
        )

        if reply.message_type == MessageType.ERROR:
            print("Error getting action menu")
            return

        # Parse directly into our recursive dataclass tree
        menu_tree = self.parse_menu_layout(reply.body)
        # Assign it to the application object
        self.applications[static_id].root_menu = menu_tree
        print(
            f"Successfully loaded menu tree for {static_id}{self.applications[static_id].id}"
        )
        print(menu_tree)
        return menu_tree

    """
❯ busctl --user get-property \
          org.kde.StatusNotifierWatcher \
          /StatusNotifierWatcher \
          org.kde.StatusNotifierWatcher \
          RegisteredStatusNotifierItems

    """

    async def get_tray_applications(self):
        introspection = await self.bus.introspect(NOTIFIER_DEST, NOTIFIER_PATH)
        proxy = self.bus.get_proxy_object(NOTIFIER_DEST, NOTIFIER_PATH, introspection)
        interface = proxy.get_interface(NOTIFIER_DEST)
        reply = await interface.get_registered_status_notifier_items()

        # Error handle 
        
        for item in reply:
            dest, path = item.split("/", 1)
            path = "/" + path
            await self.send_getall(dest, path)


        print(self.applications)

    """
❯ busctl --user call \
      :1.165 \
      /com/canonical/dbusmenu \
      com.canonical.dbusmenu \
      Event \
      isvu \
      -- \
      1 \
      clicked \
      u 0 \
      0
    """
    async def item_clicked(self, static_id, index):
        if static_id not in self.applications:
            return

        reply = await self.bus.call(
            Message(
                destination=self.applications[static_id].id,
                path=self.applications[static_id].menu_path,
                interface=NOTIF_INTERFACE,
                member="Event",
                signature="isvu",
                body=[index, "clicked", Variant('u', 0), int(time.time())],
            )
        )

        if reply.message_type == MessageType.ERROR:
            print("Error relaying click event")
            return
        
        print("WE DID ITTTT")

    async def handle_client(self, reader, writer):
        self.clients.add(writer)

        try:
            while True:
                data = await reader.readline()
                if not data:
                    break
                request = json.loads(data.decode())
                print(request)

                if request["action"] == "GetLayout":
                    print("UHHHH: ", request["appId"])
                    menu = await self.get_action_menu(request["appId"])
                    print("menu: ", menu, "\n")
                    print("UHHHH: ", request["appId"], "\n")
                    response = json.dumps(menu.to_dict()) + "\n"
                    writer.write(response.encode("utf-8"))
                elif request["action"] == "Clicked":
                    print("ID: ", request["appId"])
                    if not request["appId"] in self.applications.keys():
                        print("ERROROROROROROR")

                    await self.item_clicked(request["appId"], request["id"])


                # Do something
        finally:
            self.clients.discard(writer)

            try:
                writer.close()
                await writer.wait_closed()
            except Exception:
                print(f"Exception while closing writer: {writer}")
                pass

    def handle_registered(self, body: list(str)):
        """
        Triggered on StatusNotifierItemRegistered

        Stores process id and notifier path
        Queries for menu path
        """
        # "dest/path"
        dest, path = body[0].split("/", 1)
        path = "/" + path
        print(dest, path)
        asyncio.create_task(self.send_getall(dest, path))

    def parse_menu_layout(self, layout_data) -> MenuItem | None:
        """Parses dbus-fast GetLayout response directly into MenuItem trees."""
        if not layout_data or len(layout_data) < 2:
            return None

        root_node = layout_data[1]
        return self._parse_node(root_node)

    def _parse_node(self, node) -> MenuItem:
        """Recursive helper returning strongly typed MenuItem objects."""
        node_id, raw_properties, raw_children = node

        # 1. Unpack properties out of DBus Variant objects
        properties = {}
        for key, variant in raw_properties.items():
            properties[key] = variant.value if isinstance(variant, Variant) else variant

        # 2. Recursively process child nodes
        children = []
        for child_variant in raw_children:
            if isinstance(child_variant, Variant):
                children.append(self._parse_node(child_variant.value))

        # 3. Return the concrete dataclass instance
        return MenuItem(id=node_id, properties=properties, children=children)


def setup_parent_death_signal():
    """
    Automatically receive SIGTERM if Quickshell dies.
    """

    try:
        libc = ctypes.CDLL("libc.so.6")
        PR_SET_PDEATHSIG = 1
        libc.prctl(PR_SET_PDEATHSIG, signal.SIGTERM)
    except Exception as e:
        print("Failed to set parent death signal:", e)


def cleanup(*_):
    try:
        os.unlink(SOCKET_PATH)
    except FileNotFoundError:
        pass

    raise SystemExit(0)


async def main():
    setup_parent_death_signal()

    signal.signal(signal.SIGTERM, cleanup)
    signal.signal(signal.SIGINT, cleanup)

    try:
        os.unlink(SOCKET_PATH)
    except FileNotFoundError:
        pass

    backend = SystemTrayBackend()

    await backend.init_dbus()

    await backend.get_tray_applications()

    server = await asyncio.start_unix_server(
        backend.handle_client,
        path=SOCKET_PATH,
    )

    print(f"Listening on {SOCKET_PATH}")

    async with server:
        await server.serve_forever()


if __name__ == "__main__":
    asyncio.run(main())

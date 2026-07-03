#!/usr/bin/env python3

import asyncio
import ctypes
import json
import os
import signal
import subprocess

from dbus_fast import Message, MessageType, Variant
from dbus_fast.aio import MessageBus

SOCKET_PATH = "/tmp/quickshell_tray.sock"

APP_NAME = "QuickshellShell"

NOTIF_INTERFACE = "com.canonical.dbusmenu"
NOTIF_PATH = "/com/canonical/dbusmenu"  # Actually changes

"""
~
❯ busctl --user get-property \
          org.kde.StatusNotifierWatcher \
          /StatusNotifierWatcher \
          org.kde.StatusNotifierWatcher \
          RegisteredStatusNotifierItems
"""

# GetLayout - Get the action menu array
# Event - Something happened to the menu
# # opened - opened menu
# # closed - closed menu
# # id, clicked - action menu item clicked


class SystemTrayBackend:
    def __init__(self):
        self.bus = None
        self.clients = set()

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

    async def get_tray_applications(self):
        pass

    async def get_action_menu(self):
        pass

    async def item_clicked(self):
        pass

    async def handle_client(self):
        pass

    def handle_registered(self, body: list(str)):
        # "dest/path"
        dest, path = body[0].split("/")
        path = "/" + path
        print(dest, path)


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

    server = await asyncio.start_unix_server(
        backend.handle_client,
        path=SOCKET_PATH,
    )

    print(f"Listening on {SOCKET_PATH}")

    async with server:
        await server.serve_forever()


if __name__ == "__main__":
    asyncio.run(main())

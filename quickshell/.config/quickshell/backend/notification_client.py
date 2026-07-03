#!/usr/bin/env python3

import asyncio
import ctypes
import json
import os
import signal
import subprocess

from dbus_fast import Message, MessageType, Variant
from dbus_fast.aio import MessageBus

SOCKET_PATH = "/tmp/quickshell_service.sock"

APP_NAME = "QuickshellShell"

NOTIF_INTERFACE = "org.freedesktop.Notifications"
NOTIF_PATH = "/org/freedesktop/Notifications"


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


class NotificationBackend:
    def __init__(self):
        self.bus = None
        self.clients = set()

    async def init_dbus(self):
        self.bus = await MessageBus().connect()

        rule = (
            "type='signal'," f"interface='{NOTIF_INTERFACE}'," "member='ActionInvoked'"
        )

        await self.bus.call(
            Message(
                destination="org.freedesktop.DBus",
                path="/org/freedesktop/DBus",
                interface="org.freedesktop.DBus",
                member="AddMatch",
                signature="s",
                body=[rule],
            )
        )

        self.bus.add_message_handler(self.handle_dbus_signal)

        print("DBus notification monitoring enabled")

    def handle_dbus_signal(self, msg: Message):
        if msg.message_type == MessageType.SIGNAL and msg.member == "ActionInvoked":
            notif_id, action_key = msg.body

            print(f"Notification {notif_id} action clicked: {action_key}")

            asyncio.create_task(self.broadcast(f"ACTION:{action_key}\n"))
            if action_key == "open_browser":
                os.system("xdg-open 'https://quickshell.org'")
            elif action_key == "action1":
                os.system("xdg-open 'https://www.youtube.com/watch?v=QDia3e12czc'")
            elif action_key == "powerSaver":
                try:
                    subprocess.run(
                        ["powerprofilesctl", "set", "power-saver"],
                        check=True
                        )
                except subprocess.CalledProcessError as e:
                    print(f"Error changing power mode, code: {e.returncode}")

    async def send_notification(self, notification):
        reply = await self.bus.call(
            Message(
                destination=NOTIF_INTERFACE,
                path=NOTIF_PATH,
                interface=NOTIF_INTERFACE,
                member="Notify",
                signature="susssasa{sv}i",
                body=[
                    APP_NAME,
                    0,
                    "",
                    f"{notification["summary"]}",
                    f"{notification["body"]}",
                    notification["actions"],
                    {
                        "image-path": Variant("s", f"{notification["image"]}"),
                        "sound-name": Variant("s", f"{notification["sound"]}"),
                    },
                    -1,
                ],
            )
        )

        notif_id = reply.body[0]
        print(f"Notification sent ({notif_id})")

    async def broadcast(self, message: str):
        dead_clients = []

        for writer in self.clients:
            try:
                writer.write(message.encode())
                await writer.drain()
            except Exception:
                dead_clients.append(writer)

        for writer in dead_clients:
            self.clients.discard(writer)

    async def handle_client(self, reader, writer):
        self.clients.add(writer)

        try:
            while True:
                data = await reader.readline()

                if not data:
                    break

                notification = json.loads(data.decode())
                print(notification)

                if notification:
                    await self.send_notification(notification)

        finally:
            self.clients.discard(writer)

            try:
                writer.close()
                await writer.wait_closed()
            except Exception:
                pass


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

    backend = NotificationBackend()

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

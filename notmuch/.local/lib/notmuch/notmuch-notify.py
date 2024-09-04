#!/usr/bin/env python3

import os

import notmuch
from jeepney import DBusAddress, new_method_call
from jeepney.io.blocking import open_dbus_connection


DBUS_ADDRESS = DBusAddress(
    "/org/freedesktop/Notifications",
    bus_name="org.freedesktop.Notifications",
    interface="org.freedesktop.Notifications",
)


def default_config() -> str:
    return os.path.join(
        os.environ.get(
            "XDG_CONFIG_HOME", os.path.join(os.path.expanduser("~"), ".config")
        ),
        "notmuch",
        os.environ.get("NOTMUCH_PROFILE", "default"),
        "config",
    )


def notify(summary: str, body: str) -> int | None:
    msg = new_method_call(
        DBUS_ADDRESS,
        "Notify",
        "susssasa{sv}i",
        (
            "notmuch-notify",
            0,
            "mail-unread",
            summary,
            body,
            [],
            {},
            -1,
        ),
    )

    id = open_dbus_connection(bus="SESSION").send_and_get_reply(msg)
    if isinstance(id, int):
        return id


def main():
    if os.environ.get("NOTMUCH_CONFIG") is None:
        os.environ["NOTMUCH_CONFIG"] = default_config()

    database = notmuch.Database(mode=notmuch.Database.MODE.READ_WRITE)

    for message in database.create_query("tag:notify").search_messages():
        notify(message.get_header("From"), message.get_header("Subject"))
        print(message)
        message.remove_tag("notify")
        del message


if __name__ == "__main__":
    main()

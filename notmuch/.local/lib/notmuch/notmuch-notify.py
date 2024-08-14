#!/usr/bin/env python3

import notmuch
import os
from jeepney.io.blocking import open_dbus_connection
from jeepney import DBusAddress, new_method_call


def default_config() -> str:
    return os.path.join(
        os.environ.get(
            "XDG_CONFIG_HOME", os.path.join(os.path.expanduser("~"), ".config")
        ),
        "notmuch",
        os.environ.get("NOTMUCH_PROFILE", "default"),
        "config",
    )


def notify(summary: str, body: str) -> int:
    notifications = DBusAddress(
        "/org/freedesktop/Notifications",
        bus_name="org.freedesktop.Notifications",
        interface="org.freedesktop.Notifications",
    )

    msg = new_method_call(
        notifications,
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

    return open_dbus_connection(bus="SESSION").send_and_get_reply(msg)


def main():
    if os.environ.get("NOTMUCH_CONFIG") is None:
        os.environ["NOTMUCH_CONFIG"] = default_config()

    database = notmuch.Database(mode=notmuch.Database.MODE.READ_WRITE)
    query = database.create_query("tag:notify")
    count = query.count_messages()
    messages = query.search_messages()

    if count == 1:
        message = next(messages)
        print(message)
        notify(message.get_header("From"), message.get_header("Subject"))
        message.remove_tag("notify")
        del message
    elif count > 1:
        notify("You have new mail", f"{count} new messages...")
        for message in query.search_messages():
            print(message)
            message.remove_tag("notify")
            del message


if __name__ == "__main__":
    main()

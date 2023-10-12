#!/bin/sh

if ! command -v "notmuch" >/dev/null; then
	printf "%s: notmuch not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Installing service\n" "$0"

systemctl --user enable --now --no-block notmuch.service

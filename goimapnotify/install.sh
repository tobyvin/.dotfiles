#!/bin/sh

if ! command -v "goimapnotify" >/dev/null; then
	printf "%s: goimapnotify not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Installing services\n" "$0"

systemctl --user enable --now --no-block goimapnotify@gmail.service
systemctl --user enable --now --no-block goimapnotify@porkbun.service

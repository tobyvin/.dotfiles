#!/bin/sh

if ! command -v "mbsync" >/dev/null; then
	printf "%s: mbsync not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Installing services\n" "$0"

systemctl --user enable --now --no-block mbsync@gmail.service
systemctl --user enable --now --no-block mbsync@porkbun.service
systemctl --user enable --now --no-block maildir-notify@gmail.service
systemctl --user enable --now --no-block maildir-notify@porkbun.service

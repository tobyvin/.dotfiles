#!/bin/sh

printf "%s: Installing services\n" "$0"

if command -v mbsync >/dev/null; then
	systemctl --user enable --now --no-block mbsync.service
	systemctl --user enable --now --no-block maildir-notify@gmail.service
	systemctl --user enable --now --no-block maildir-notify@porkbun.service
else
	printf "%s: command not found: mbsync\n" "$0"
	exit 1
fi

if command -v goimapnotify >/dev/null; then
	systemctl --user enable --now --no-block goimapnotify@gmail.service
	systemctl --user enable --now --no-block goimapnotify@porkbun.service
else
	printf "%s: command not found: goimapnotify\n" "$0"
	exit 1
fi

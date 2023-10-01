#!/bin/sh

if command -v mbsync >/dev/null; then
	systemctl --user enable --now mbsync.service
	systemctl --user enable --now maildir-notify@gmail.service
	systemctl --user enable --now maildir-notify@porkbun.service
else
	printf "%s: command not found: mbsync\n" "$0"
	exit 1
fi

if command -v goimapnotify >/dev/null; then
	systemctl --user enable --now goimapnotify@gmail.service
	systemctl --user enable --now goimapnotify@porkbun.service
else
	printf "%s: command not found: goimapnotify\n" "$0"
	exit 1
fi

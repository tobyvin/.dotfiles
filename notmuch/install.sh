#!/bin/sh

pkgname=notmuch

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

printf "%s: Installing service\n" "$0"

mkdir -p "$XDG_DATA_HOME"/mail/gmail.com/tobyv13 "$XDG_DATA_HOME"/mail/tobyvin.dev/tobyv
systemctl --user enable --now --no-block notmuch.service goimapnotify.service

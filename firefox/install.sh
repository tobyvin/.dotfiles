#!/bin/sh

pkgname=firefox

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

printf "%s: Installing user.js\n" "$0"

profile=$(grep -Po -m1 'Default=\K.*' <~/.mozilla/firefox/profiles.ini)
if [ -d "$HOME"/.mozilla/firefox/"$profile" ]; then
	ln -vst ~/.mozilla/firefox/"$profile" "$XDG_CONFIG_HOME"/firefox/user.js
fi

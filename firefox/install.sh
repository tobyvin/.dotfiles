#!/bin/sh

pkgname=firefox

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

if [ -e ~/.mozilla/firefox/profiles.ini ] && [ -d "$XDG_CONFIG_HOME"/firefox ]; then
	printf "%s: Installing user.js\n" "$0"

	profile=$(grep -Po -m1 'Default=\K.*' <~/.mozilla/firefox/profiles.ini)
	for item in "$XDG_CONFIG_HOME"/firefox/*; do
		if [ ! -L ~/.mozilla/firefox/"$profile"/"${item##*/}" ]; then
			ln -vst ~/.mozilla/firefox/"$profile" "$item"
		fi
	done
fi

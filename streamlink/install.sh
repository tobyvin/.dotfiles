#!/bin/sh

pkgname=streamlink

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

if [ -e "$XDG_DATA_HOME"/streamlink/plugins/twitch.py ] && ! find "$XDG_DATA_HOME"/streamlink/plugins/twitch.py -mtime +7 -print | grep -q .; then
	printf "%s: Installing plugins\n" "$0"

	curl -Lo "$XDG_DATA_HOME"/streamlink/plugins/twitch.py \
		'https://github.com/2bc4/streamlink-ttvlol/releases/latest/download/twitch.py'
fi

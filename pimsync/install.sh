#!/bin/sh

pkgname=pimsync

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

mkdir -pv "${XDG_DATA_HOME}/calendars" "${XDG_DATA_HOME}/contacts"

printf "%s: Installing services\n" "$0"

systemctl --user enable --now --no-block pimsync.service

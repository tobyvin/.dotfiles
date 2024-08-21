#!/bin/sh

pkgname=sway

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

printf "%s: Installing service\n" "$0"

systemctl --user enable --now --no-block swayidle.service inhibridge.service

#!/bin/sh

pkgname=spotifyd

if ! command -v "$pkgname" >/dev/null; then
	printf "%s: $pkgname not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Installing services\n" "$0"

systemctl --user enable --now --no-block $pkgname.service

#!/bin/sh

pkgname=cliphist

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

printf "%s: Installing services\n" "$0"

systemctl --user enable --now --no-block $pkgname.service

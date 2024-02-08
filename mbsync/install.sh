#!/bin/sh

pkgname=mbsync

if ! command -v "$pkgname" >/dev/null; then
	printf "%s: $pkgname not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Installing services\n" "$0"

for instance in gmail porkbun; do
	systemctl --user enable --now --no-block $pkgname@"$instance".service
done

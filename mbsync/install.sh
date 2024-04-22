#!/bin/sh

pkgname=mbsync

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

printf "%s: Installing services\n" "$0"

for instance in gmail porkbun; do
	systemctl --user enable --now --no-block mbsync@"$instance".service
	systemctl --user enable --now --no-block maildir-notify@"$instance".service
done

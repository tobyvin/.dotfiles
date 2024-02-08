#!/bin/sh

printf "%s: Installing services\n" "$0"

for pkgname in physlock wl-mpris-idle-inhibit; do
	if command -v "$pkgname" >/dev/null; then
		systemctl --user enable --no-block $pkgname.service
	else
		printf "%s: $pkgname not found, skipping...\n" "$0"
	fi
done

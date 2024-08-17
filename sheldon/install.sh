#!/bin/sh

pkgname=sheldon

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

printf "%s: Installing plugins\n" "$0"

sheldon lock --update 2>&1 |
	grep -Po 'CLONED\K.*' |
	xargs -L1 -r printf '%s: Installed: %s\n' "$0"

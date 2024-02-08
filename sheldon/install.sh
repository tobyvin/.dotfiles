#!/bin/sh

pkgname=sheldon

if ! command -v "$pkgname" >/dev/null; then
	printf "%s: $pkgname not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Installing plugins\n" "$0"

sheldon -q lock

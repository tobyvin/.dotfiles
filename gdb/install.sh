#!/bin/sh

pkgname=gdb

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

mkdir -pv "${XDG_STATE_HOME}/gdb"

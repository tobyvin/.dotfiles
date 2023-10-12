#!/bin/sh

if ! command -v "sheldon" >/dev/null; then
	printf "%s: sheldon not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Installing plugins\n" "$0"

sheldon -q lock

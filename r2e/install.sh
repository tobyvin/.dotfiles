#!/bin/sh

if ! command -v "r2e" >/dev/null; then
	printf "%s: r2e not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Installing services\n" "$0"

systemctl --user enable --now --no-block rss2email.timer
systemctl --user start --no-block rss2email.service

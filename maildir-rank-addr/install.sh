#!/bin/sh

if ! command -v "maildir-rank-addr" >/dev/null; then
	printf "%s: maildir-rank-addr not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Installing services\n" "$0"

systemctl --user enable --now --no-block maildir-rank-addr@gmail.service
systemctl --user enable --now --no-block maildir-rank-addr@porkbun.service

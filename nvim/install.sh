#!/bin/sh

if ! command -v "nvim" >/dev/null; then
	printf "%s: nvim not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Restoring plugins\n" "$0"

nvim --headless -c 'Lazy! restore' -c qa
nvim --headless -c 'Lazy! clean' -c qa

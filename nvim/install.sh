#!/bin/sh

if ! command -v "nvim" >/dev/null; then
	printf "%s: nvim not found, skipping...\n" "$0"
	exit 0
fi

printf "%s: Installing plugins\n" "$0"

nvim --headless -c 'Lazy! restore' -c qa
nvim --headless -c 'Lazy! clean' -c qa

printf "%s: Installing treesitter parsers\n" "$0"

nvim --headless -c 'TSUpdateSync' -c qa

printf "\n"

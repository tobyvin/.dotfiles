#!/bin/sh

pkgname=nvim

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

if test .installed -nt $pkgname; then
	exit 0
fi

printf "%s: Installing plugins\n" "$0"

nvim --headless -c 'Lazy! restore' -c qa
nvim --headless -c 'Lazy! clean' -c qa

printf "%s: Installing treesitter parsers\n" "$0"

nvim --headless -c 'TSUpdateSync' -c qa | sed 's/$/\n/'

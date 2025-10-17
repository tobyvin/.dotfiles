#!/bin/sh

pkgname=nvim

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

printf "%s: Installing plugins" "$0"

# TODO: fix newlines in vim.pack.add or output buffering
nvim --headless -c ':lua vim.pack.clean()' -c qa 2>&1 | sed -u 's/vim.pack:/\nvim.pack:/g'
printf "\n"

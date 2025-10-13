#!/bin/sh

pkgname=nvim

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

# TODO: migrate this to new vim.pack based config
# if ! git diff --quiet "$DOTFILES_INSTALLED" HEAD -- nvim/.config/nvim/lazy-lock.json; then
# 	printf "%s: Installing plugins\n" "$0"
#
# 	nvim --headless -c 'Lazy! restore' -c qa
# 	nvim --headless -c 'Lazy! clean' -c qa
#
# 	printf "%s: Installing treesitter parsers\n" "$0"
#
# 	nvim --headless -c 'TSUpdateSync' -c qa | sed 's/$/\n/'
# fi

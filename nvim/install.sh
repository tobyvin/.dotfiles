#!/bin/sh

pkgname=nvim

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

printf "%s: Installing plugins\n" "$0"
nvim --headless -c ':lua vim.pack.update(nil, { force = true, target = "lockfile" })' -c qa

printf "\n%s: Cleaning inactive plugins" "$0"
nvim --headless -c ':lua vim.pack.clean(nil, { inactive = true })' -c qa

printf "\n%s: Downloading spellfile" "$0"
nvim --headless -c ':lua require("nvim.spellfile").get("english")' -c qa
printf "\n"

if [ -d "$XDG_DATA_HOME"/nvim/lazy ] || [ -d "$XDG_STATE_HOME"/nvim/lazy ]; then
	printf "%s: Removing lazy directories" "$0"
	rm -rf "$XDG_DATA_HOME"/nvim/lazy "$XDG_STATE_HOME"/nvim/lazy
fi

#!/bin/sh

pkgname=nvim

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

printf "%s: Installing plugins" "$0"

# TODO: fix newlines in vim.pack.add or output buffering
nvim --headless -c ':lua vim.pack.update(nil, { target = "lockfile" }) vim.pack.clean()' -c qa 2>&1 | sed -u \
	-e 's/\([^\n]\)\(vim.pack:\)/\1\n\2/g' -e 's/^$//'
printf "\n"

if [ -d "$XDG_DATA_HOME"/nvim/lazy ] || [ -d "$XDG_STATE_HOME"/nvim/lazy ]; then
	printf "%s: Removing lazy directories" "$0"
	rm -rf "$XDG_DATA_HOME"/nvim/lazy "$XDG_STATE_HOME"/nvim/lazy
fi

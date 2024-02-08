#!/bin/sh

pkgname=bemenu

if ! command -v "$pkgname" >/dev/null; then
	printf "%s: $pkgname not found, skipping...\n" "$0"

	for bin in dmenu dmenu_run dmenu-wl dmenu-wl_run; do
		if [ -L "$HOME/.local/bin/$bin" ] && [ ! -e "$HOME/.local/bin/$bin" ]; then
			rm -v "$HOME/.local/bin/$bin"
		fi
	done

	exit 0
fi

printf "%s: Installing symlinks\n" "$0"

ln -svf "$(command -v bemenu)" ~/.local/bin/dmenu
ln -svf "$(command -v bemenu)" ~/.local/bin/dmenu-wl
ln -svf "$(command -v bemenu-run)" ~/.local/bin/dmenu_run
ln -svf "$(command -v bemenu-run)" ~/.local/bin/dmenu-wl_run

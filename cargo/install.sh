#!/bin/sh

pkgname=cargo

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

if [ ! -L "$XDG_DATA_HOME"/cargo/bin ]; then
	if [ -d "$XDG_DATA_HOME"/cargo/bin ]; then
		mv -vt "$HOME"/.local/bin "$XDG_DATA_HOME"/cargo/bin/*
		rm -d "$XDG_DATA_HOME"/cargo/bin
	fi

	ln -sT "$HOME/.local/bin" "$XDG_DATA_HOME/cargo/bin"
fi

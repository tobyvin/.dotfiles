#!/bin/sh

pkgname=zsh

if ! command -v "$pkgname" >/dev/null; then
	printf "%s: $pkgname not found, skipping...\n" "$0"
	exit 0
fi

mkdir -p "${XDG_CACHE_HOME}/zsh"

zsh -s <<EOF
	  autoload -U compinit
	  compinit -u -d "${XDG_CACHE_HOME}/zsh/zcompdump"
EOF

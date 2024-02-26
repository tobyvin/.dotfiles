#!/bin/sh

pkgname=zsh

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

mkdir -pv "${XDG_CACHE_HOME}/zsh"

printf '%s: Writing zcompdump\n' "$0"

zsh -s <<EOF
	  autoload -U compinit
	  compinit -u -d "${XDG_CACHE_HOME}/zsh/zcompdump"
EOF

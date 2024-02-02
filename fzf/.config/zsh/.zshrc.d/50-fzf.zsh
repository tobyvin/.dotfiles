#!/bin/zsh
# vim: ft=sh

_fzf_compgen_path() {
	fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
	fd --type d --hidden --follow --exclude ".git" . "$1"
}

if [ -r "/usr/share/fzf/completion.zsh" ]; then
	source /usr/share/fzf/completion.zsh
fi

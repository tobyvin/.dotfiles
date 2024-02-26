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

if [ -n "$BASE16_THEME" ] && [ -n "$BASE16_SHELL_ENABLE_VARS" ]; then
	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
--color=bg+:#$BASE16_COLOR_01_HEX,bg:#$BASE16_COLOR_00_HEX,spinner:#$BASE16_COLOR_0C_HEX,hl:#$BASE16_COLOR_0D_HEX
--color=fg:#$BASE16_COLOR_04_HEX,header:#$BASE16_COLOR_0D_HEX,info:#$BASE16_COLOR_0A_HEX,pointer:#$BASE16_COLOR_0C_HEX
--color=marker:#$BASE16_COLOR_0C_HEX,fg+:#$BASE16_COLOR_06_HEX,prompt:#$BASE16_COLOR_0A_HEX,hl+:#$BASE16_COLOR_0D_HEX"
fi

#!/usr/bin/env bash

export GPG_TTY=$(tty)
export BROWSER=wslview
export STARSHIP_LOG="error"
export BAT_CONFIG_PATH="${DOTFILES}/bat.conf"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_BASE="${HOME}/.fzf"
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}"
export FZF_CTRL_T_OPTS="--min-height 30 --preview-window down:60% --preview-window noborder --preview '($FZF_PREVIEW_COMMAND) 2> /dev/null'"

# Path
PATH=$PATH:$HOME/.local/bin:$HOME/.go/bin:$HOME/.dotnet/tools:$HOME/.cargo/bin:$DOTFILES/scripts:/usr/local/texlive/2021/bin/x86_64-linux

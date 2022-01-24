#!/usr/bin/env bash

export GPG_TTY=$(tty)
export STARSHIP_LOG="error"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}"
export FZF_CTRL_T_OPTS="--min-height 30 --preview-window down:60% --preview-window noborder --preview '($FZF_PREVIEW_COMMAND) 2> /dev/null'"

# Path
PATH=$PATH:$HOME/.local/bin:$HOME/.go/bin:$HOME/.dotnet/tools:$HOME/.cargo/bin:$HOME/dotfiles/scripts:/usr/local/texlive/2021/bin/x86_64-linux

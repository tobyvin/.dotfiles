#!/usr/bin/env bash
# Exports
export DOTFILES="$(cd $(dirname "$(readlink -fm "$0")"); git rev-parse --show-toplevel)"

# https://github.com/junegunn/fzf#respecting-gitignore
export FZF_BASE="${DOTFILES}/fzf"
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}"
export FZF_CTRL_T_OPTS="--min-height 30 --preview-window down:60% --preview-window noborder --preview '($FZF_PREVIEW_COMMAND) 2> /dev/null'"

export BAT_CONFIG_PATH="${DOTFILES}/bat.conf"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Path
PATH=$PATH:$HOME/.local/bin:$HOME/.dotnet/tools:$HOME/.cargo/bin:$DOTFILES/scripts
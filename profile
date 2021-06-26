#!/usr/bin/env bash

# Exports
export DOTFILES="$(cd $(dirname "$(readlink -fm "$0")"); git rev-parse --show-toplevel)"
export FZF_BASE="${DOTFILES}/fzf"
export BAT_CONFIG_PATH="${DOTFILES}/bat.conf"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Path
PATH=$PATH:$HOME/.local/bin:$HOME/.dotnet/tools:$HOME/.cargo/bin:$DOTFILES/scripts
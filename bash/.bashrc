#!/usr/bin/env bash

export BASHDOTDIR=${XDG_CONFIG_HOME:-$HOME/.config}/bash
export BASHCOMPDIR=${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions

if [ -d "$BASHDOTDIR" ]; then for f in $BASHDOTDIR/*; do source $f; done; fi
if [ -d "$BASHCOMPDIR" ]; then for f in $BASHCOMPDIR/*; do source $f; done; fi

command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

set_win_title() {
  local prefix

  if [ "$USER" != "tobyv" ]; then
    prefix="${USER} in "
  fi

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    prefix="${prefix/in/on}${HOST} in "
  fi

  echo -ne "\033]0;${prefix}${PWD/$HOME/~}\007"
}

starship_precmd_user_func="set_win_title"

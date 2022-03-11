#!/usr/bin/env bash

comp_dir=${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions

if [ -d "~/.bash" ]; then for f in ~/.bash/*; do source $f; done; fi
if [ -d "$comp_dir" ]; then for f in "$comp_dir"/*; do source $f; done; fi

command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

set_win_title() {
  local prefix

  if [ "$USER" != "tobyv" ]; then
    prefix="${USER} in "
  fi

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    prefix="${prefix/in/on}${HOSTNAME} in "
  fi

  echo -ne "\033]0;${prefix}${PWD/$HOME/~}\007"
}

starship_precmd_user_func="set_win_title"

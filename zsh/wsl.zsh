#!/usr/bin/env zsh

source "${DOTFILES:-"${HOME}/dotfiles"}/shell/wsl.sh"
source "${DOTFILES:-"${HOME}/dotfiles"}/shell/gpg.sh"

hash -d w=/mnt/c/Users/$USER

function r-copy() {
  if ((REGION_ACTIVE)) then
    zle copy-region-as-kill
    (( ${+aliases[cb]} )) && printf "$CUTBUFFER" | cb
  else
    zle kill-whole-line
  fi
}

function r-cut() {
  if ((REGION_ACTIVE)) then
    zle kill-region
  else
    zle kill-whole-line
  fi
  (( ${+aliases[cb]} )) && printf "$CUTBUFFER" | cb
}

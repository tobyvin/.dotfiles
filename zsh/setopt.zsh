#!/usr/bin/env zsh

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
setopt HIST_IGNORE_ALL_DUPS
setopt NO_BEEP
setopt MENU_COMPLETE

function set_title() {
  folder=$(sed "s/$USER/~/g" <<<$PWD:t)

  window_title="\033]0;$USER@$HOST: $folder\007"
  echo -ne "$window_title"
}

autoload -Uz add-zsh-hook && add-zsh-hook precmd set_title
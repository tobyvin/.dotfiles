#!/usr/bin/env zsh

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_TITLE="true"
setopt HIST_IGNORE_ALL_DUPS
setopt NO_BEEP
setopt MENU_COMPLETE

fpath=(~/.local/share/zsh/site-functions "${fpath[@]}")

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
if [ -d "${HOME}/.zsh" ]; then for f in ~/.zsh/*; do source $f; done; fi

eval "$(starship init zsh)"

function set_win_title() {
    folder=$(sed "s/$USER/~/g" <<<$PWD:t)

    window_title="\033]0;$USER@$HOST: $folder\007"
    echo -ne "$window_title"
}

precmd_functions+=(set_win_title)

autoload -U compinit
compinit -i

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

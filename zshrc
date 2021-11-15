#!/usr/bin/env zsh

fpath=(~/.local/share/zsh/site-functions "${fpath[@]}")

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

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#!/usr/bin/env bash

source ~/.profile

comp_dir=${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions

if [ -d "$comp_dir" ]; then for f in "$comp_dir"/*; do source $f; done; fi
if [ -d "~/.bash" ]; then for f in ~/.bash/*; do source $f; done; fi


eval "$(starship init bash)"

function set_win_title() {
    echo -ne "\033]0;$USER@$HOSTNAME: ${PWD/$HOME/'~'}\007"
}
starship_precmd_user_func="set_win_title"

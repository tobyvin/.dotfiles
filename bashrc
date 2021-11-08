#!/usr/bin/env bash

export DOTFILES="${HOME}/dotfiles"

for f in "${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion"; do
    source $f
done

source $DOTFILES/shell/env.sh
source $DOTFILES/shell/aliases.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/shell/wsl.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/shell/gpg.sh

eval "$(starship init bash)"

function set_win_title() {
    echo -ne "\033]0;$USER@$HOSTNAME: ${PWD/$HOME/'~'}\007"
}
starship_precmd_user_func="set_win_title"

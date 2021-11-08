#!/usr/bin/env zsh

export DOTFILES="${HOME}/dotfiles"

fpath=( "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions" "${fpath[@]}" )

source $DOTFILES/shell/env.sh
source $DOTFILES/zsh/plugins.zsh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/shell/wsl.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/shell/gpg.sh
source $DOTFILES/shell/aliases.sh
source $DOTFILES/zsh/setopt.zsh
source $DOTFILES/zsh/completions.zsh
source $DOTFILES/zsh/keybindings.zsh

eval "$(starship init zsh)"

function set_win_title() {
    folder=$(sed "s/$USER/~/g" <<<$PWD:t)

    window_title="\033]0;$USER@$HOST: $folder\007"
    echo -ne "$window_title"
}

precmd_functions+=(set_win_title)

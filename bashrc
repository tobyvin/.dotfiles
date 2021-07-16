#!/usr/bin/env bash

export DOTFILES="${HOME}/dotfiles"

source $DOTFILES/shell/env.sh
source $DOTFILES/shell/aliases.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/shell/wsl.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/shell/gpg.sh

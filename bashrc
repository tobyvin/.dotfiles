#!/usr/bin/env bash

export DOTFILES="${HOME}/dotfiles"

source $DOTFILES/sh/env.sh
source $DOTFILES/sh/aliases.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/sh/wsl.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/sh/gpg.sh

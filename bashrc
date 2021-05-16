#!/usr/bin/env bash

source "${DOTFILES:="${HOME}/dotfiles"}/sh/profile.sh"

source $DOTFILES/sh/aliases.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/sh/wsl.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/sh/gpg.sh

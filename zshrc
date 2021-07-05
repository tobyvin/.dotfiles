#!/usr/bin/env zsh

export DOTFILES="${HOME}/dotfiles"

# Directory hashtable
hash -d .=${HOME}/dotfiles
source $DOTFILES/sh/env.sh
source $DOTFILES/antigen/antigen.zsh
source $DOTFILES/zsh/setopt.zsh
source $DOTFILES/zsh/prompt.zsh
source $DOTFILES/zsh/aliases.zsh
source $DOTFILES/zsh/keybindings.zsh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/zsh/wsl.zsh

antigen init $DOTFILES/antigenrc

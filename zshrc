#!/usr/bin/env zsh

export DOTFILES="${HOME}/dotfiles"

# Directory hashtable
hash -d .=${HOME}/dotfiles
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/zsh/wsl.zsh
source $DOTFILES/shell/env.sh
source $DOTFILES/zsh/plugins.zsh
source $DOTFILES/zsh/setopt.zsh
source $DOTFILES/zsh/aliases.zsh
source $DOTFILES/zsh/completions.zsh
source $DOTFILES/zsh/keybindings.zsh

eval "$(starship init zsh)"
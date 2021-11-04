#!/usr/bin/env zsh

[ "$PWD" = '/mnt/c/Windows' ] && cd

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export DOTFILES="${HOME}/dotfiles"

# Directory hashtable
hash -d .=${HOME}/dotfiles
source $DOTFILES/shell/env.sh
source $DOTFILES/zsh/plugins.zsh
source $DOTFILES/zsh/setopt.zsh
source $DOTFILES/zsh/prompt.zsh
source $DOTFILES/zsh/aliases.zsh
source $DOTFILES/zsh/completions.zsh
source $DOTFILES/zsh/keybindings.zsh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/zsh/wsl.zsh

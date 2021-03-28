# Exports
export ZSH_BASE="${HOME}/dotfiles"
export FZF_BASE="${HOME}/dotfiles/fzf"

# Path
export PATH="$PATH:${HOME}/.local/bin"
export PATH="$PATH:${HOME}/.dotnet/tools"

# Directory hashtable
hash -d .=${HOME}/dotfiles
hash -d s=${HOME}/Sync
hash -d d=${HOME}/docker

[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

source $ZSH_BASE/zsh/setopt.zsh
source $ZSH_BASE/zsh/prompt.zsh
source $ZSH_BASE/zsh/aliases.zsh
source $ZSH_BASE/zsh/keybindings.zsh
source $ZSH_BASE/zsh/plugins.zsh


[ -n "${WSL_DISTRO_NAME+1}" ] && source $ZSH_BASE/zsh/wsl.zsh

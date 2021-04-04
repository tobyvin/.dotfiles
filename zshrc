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

source $ZSH_BASE/antigen/antigen.zsh 
source $ZSH_BASE/zsh/ssh.zsh 
source $ZSH_BASE/zsh/setopt.zsh
source $ZSH_BASE/zsh/prompt.zsh
source $ZSH_BASE/zsh/aliases.zsh
source $ZSH_BASE/zsh/keybindings.zsh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $ZSH_BASE/zsh/wsl.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle fzf
antigen bundle dotnet
antigen bundle docker
antigen bundle docker-compose
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle memark/zsh-dotnet-completion
antigen theme romkatv/powerlevel10k.git
antigen apply
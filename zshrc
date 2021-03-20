[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

ZSH_BASE=$HOME/dotfiles # Base directory for ZSH configuration

source $ZSH_BASE/zsh/setopt.zsh

source $ZSH_BASE/zsh/completion.zsh
[ -f $ZSH_BASE/fzf/shell/completion.zsh ] && source $ZSH_BASE/fzf/shell/completion.zsh

source $ZSH_BASE/zsh/prompt.zsh
source $ZSH_BASE/zsh/aliases.zsh
source $ZSH_BASE/zsh/functions.zsh

[ -n "${WSL_DISTRO_NAME+1}" ] && source $ZSH_BASE/zsh/wsl.zsh

source $ZSH_BASE/zsh/keybindings.zsh
[ -f $ZSH_BASE/fzf/shell/key-bindings.zsh ] && source $ZSH_BASE/fzf/shell/key-bindings.zsh

source $ZSH_BASE/antigen/antigen.zsh # Load Antigen


antigen use oh-my-zsh
antigen bundle git
antigen bundle fzf
antigen bundle dotnet
antigen bundle docker
antigen bundle docker-compose
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen theme romkatv/powerlevel10k.git
antigen apply

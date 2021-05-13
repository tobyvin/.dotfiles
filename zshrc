source "${DOTFILES:="${HOME}/dotfiles"}/sh/profile.sh"

# Directory hashtable
hash -d .=${HOME}/dotfiles

source $DOTFILES/antigen/antigen.zsh
source $DOTFILES/zsh/setopt.zsh
source $DOTFILES/zsh/prompt.zsh
source $DOTFILES/zsh/aliases.zsh
source $DOTFILES/zsh/keybindings.zsh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/zsh/wsl.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle fzf
antigen bundle dotnet
antigen bundle docker
antigen bundle docker-compose
antigen bundle command-not-found
antigen bundle wakeonlan
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle memark/zsh-dotnet-completion
antigen theme romkatv/powerlevel10k.git
antigen apply
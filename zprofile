# Exports
export ZSH="${HOME}/.oh-my-zsh"
export ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
export PATH="${HOME}/.local/bin:${HOME}/.dotnet/tools:$PATH"

# Directory hashtable
hash -d .=${HOME}/dotfiles
hash -d s=${HOME}/Sync
hash -d d=${HOME}/docker
hash -d w=/mnt/c/Users/$USER
# Exports
export PATH="$PATH:${HOME}/.local/bin"
export PATH="$PATH:${HOME}/.dotnet/tools"

export ZSH_BASE="${HOME}/dotfiles"
export FZF_BASE="${HOME}/dotfiles/fzf"

# Directory hashtable
hash -d .=${ZSH_BASE}
hash -d s=${HOME}/Sync
hash -d d=${HOME}/docker
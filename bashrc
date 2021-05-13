source "${DOTFILES:="${HOME}/dotfiles"}/sh/profile.sh"

# Directory hashtable
hash -d .=${HOME}/dotfiles


source $DOTFILES/sh/aliases.sh
source $DOTFILES/sh/wsl.sh
source $DOTFILES/sh/gpg.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/sh/wsl.sh

eval "$(starship init zsh)"
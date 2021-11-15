#!/usr/bin/env zsh

export DOTFILES="${HOME}/dotfiles"
export ZDOTDIR=~/.zsh.d

fpath=(~/.local/share/zsh/site-functions "${fpath[@]}")

if [ -d "$ZDOTDIR" ]; then for f in $ZDOTDIR/*; do source $f; done; fi

source $DOTFILES/shell/env.sh

[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/shell/wsl.sh
[ -n "${WSL_DISTRO_NAME+1}" ] && source $DOTFILES/shell/gpg.sh

source $DOTFILES/shell/aliases.sh
source $DOTFILES/zsh/setopt.zsh
source $DOTFILES/zsh/keybindings.zsh

eval "$(starship init zsh)"

function set_win_title() {
    folder=$(sed "s/$USER/~/g" <<<$PWD:t)

    window_title="\033]0;$USER@$HOST: $folder\007"
    echo -ne "$window_title"
}

precmd_functions+=(set_win_title)

autoload -U compinit
compinit -i

source $ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

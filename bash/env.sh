#!/usr/bin/env bash

export EDITOR="$(command -v vim 2>/dev/null || command -v vi)"
export VISUAL="code --wait"
export GPG_TTY=$(tty)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export STARSHIP_LOG="error"
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}"
export FZF_CTRL_T_OPTS="--min-height 30 --preview-window down:60% --preview-window noborder --preview '($FZF_PREVIEW_COMMAND) 2> /dev/null'"

export PATH=$PATH:$HOME/dotfiles/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.go/bin
export PATH=$PATH:$HOME/.dotnet/tools
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/dotfiles/scripts
export PATH=$PATH:/usr/local/texlive/2021/bin/x86_64-linux

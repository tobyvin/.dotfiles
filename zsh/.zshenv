# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_RUNTIME_DIR=$HOME/.xdg

# Shell
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export BASH_COMPLETION_USER_DIR=$XDG_DATA_HOME/bash-completion/completions

# Misc
export EDITOR="$(command -v vim 2>/dev/null || command -v vi)"
export VISUAL="code --wait"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export GOPATH=$HOME/.go
export GPG_TTY=$(tty)
export STARSHIP_LOG="error"
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}"
export FZF_DEFAULT_COMMAND="fd --type f || git ls-tree -r --name-only HEAD || rg --files || find ."
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--min-height 30 --preview-window down:60% --preview-window noborder --preview '($FZF_PREVIEW_COMMAND) 2> /dev/null'"

# Path
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.scripts
export PATH=$PATH:$HOME/.go/bin
export PATH=$PATH:$HOME/.dotnet/tools
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:/usr/local/texlive/2021/bin/x86_64-linux

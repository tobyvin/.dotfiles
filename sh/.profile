#!/bin/sh
# shellcheck disable=1091,2046

# environment.d
if [ -x /usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator ]; then
	export $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
fi

# xdg
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u "$USER")}"

# prog
EDITOR="$(command -v nvim 2>/dev/null || command -v vim 2>/dev/null || command -v vi)"
BROWSER="$(command -v chromium 2>/dev/null || command -v firefox)"
export EDITOR BROWSER
export TERMINAL="alacritty"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# opts
export MANROFFOPT="-c"
export LESSHISTFILE="$XDG_STATE_HOME/lesshst"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export STARSHIP_LOG="error"
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || exa --tree --icons --git-ignore {} || tree -C {}"
export FZF_DEFAULT_COMMAND="fd --type f || git ls-tree -r --name-only HEAD || rg --files || find ."
export FZF_DEFAULT_OPTS='--exit-0 --select-1 --bind "ctrl-q:abort,ctrl-y:preview-up,ctrl-e:preview-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,alt-up:half-page-up,alt-down:half-page-down"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--min-height 30 --preview-window down:60% --preview-window noborder --preview '($FZF_PREVIEW_COMMAND) 2> /dev/null'"

# path
export PATH="$PATH:$HOME/.local/bin"

# rust
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export PATH="$PATH:$CARGO_HOME/bin"

# go
export GOPATH="$XDG_DATA_HOME/go"
export PATH="$PATH:$GOPATH/bin"

# npm
export npm_config_userconfig="$XDG_CONFIG_HOME/npm/config"
export npm_config_cache="$XDG_CACHE_HOME/npm"
export npm_config_prefix="$XDG_DATA_HOME/npm"
export PATH="$PATH:$npm_config_prefix/bin"

# dotnet
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export PATH="$PATH:$DOTNET_CLI_HOME/tools"

# texlive
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"

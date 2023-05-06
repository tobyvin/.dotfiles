#!/bin/zsh
# vim: ft=sh

export HYPHEN_INSENSITIVE="true"
export DISABLE_UPDATE_PROMPT="true"
export DISABLE_AUTO_TITLE="true"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=10000
export SAVEHIST=10000
export DIRSTACKSIZE=20

setopt NO_BEEP
setopt MENU_COMPLETE
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt NONOMATCH
setopt CORRECT
setopt INTERACTIVE_COMMENTS

bindkey -v
bindkey -m 2>/dev/null

# TODO: improve this with terminfo validation
#
# See: https://wiki.archlinux.org/title/Zsh#Key_bindings
bindkey '^[q' push-line
bindkey '^[[Z' reverse-menu-complete
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

bindkey -M vicmd '^[q' push-line
bindkey -M vicmd '^[[Z' reverse-menu-complete
bindkey -M vicmd '^[[1~' beginning-of-line
bindkey -M vicmd '^[[4~' end-of-line
bindkey -M vicmd '^[[3~' delete-char
bindkey -M vicmd '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5D' backward-word

alias ls="ls --color=auto"
alias tree="tree --gitignore"
alias grep='grep --color=auto'
alias ipa="ip -s -c -h a"
alias untar="tar -zxvf"

# Adopt the behavior of the system wide configuration for application specific settings
#
# See: https://wiki.archlinux.org/title/Command-line_shell#/etc/profile
for script in "$XDG_CONFIG_HOME"/zsh/.zshrc.d/*.zsh; do
	if [ -r "$script" ]; then
		source "$script"
	fi
done

autoload -Uz compinit
compinit

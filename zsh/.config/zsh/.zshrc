#!/bin/zsh

HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

setopt no_beep
setopt menu_complete
setopt auto_pushd
setopt pushd_silent
setopt pushd_ignore_dups
setopt extended_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt nonomatch
setopt interactive_comments

bindkey -v
bindkey -m 2>/dev/null

autoload -U select-word-style
zle -N select-word-style
select-word-style normal
zstyle :zle:transpose-words word-style shell

zstyle :completion:* cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
zstyle :completion:* use-cache true

hash -d rfc=/usr/share/doc/rfc/txt

# See: https://wiki.archlinux.org/title/Zsh#Key_bindings
bindkey '^[q' push-line
bindkey '^[[Z' reverse-menu-complete
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[t' transpose-words
bindkey '^ ' forward-word

bindkey -M vicmd '^[q' push-line
bindkey -M vicmd '^[[Z' reverse-menu-complete
bindkey -M vicmd '^[[1~' beginning-of-line
bindkey -M vicmd '^[[4~' end-of-line
bindkey -M vicmd '^[[3~' delete-char
bindkey -M vicmd '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5D' backward-word

alias ls='ls --human-readable --color=auto'
alias ip='ip -color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias info='info --vi-keys'
alias untar='tar -zxvf'
alias userctl='systemctl --user'

# Adopt the behavior of the system wide configuration for application specific settings
#
# See: https://wiki.archlinux.org/title/Command-line_shell#/etc/profile
for script in "$XDG_CONFIG_HOME"/zsh/.zshrc.d/*.zsh; do
	if [ -r "$script" ]; then
		source "$script"
	fi
done

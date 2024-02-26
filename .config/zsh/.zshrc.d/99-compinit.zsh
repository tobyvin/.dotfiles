#!/bin/zsh

zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

autoload -U compinit
compinit -u -C -d "${XDG_CACHE_HOME}/zsh/zcompdump"

TRAPUSR1() {
	rehash
	compinit -u -d "${XDG_CACHE_HOME}/zsh/zcompdump"
}

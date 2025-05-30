#!/usr/bin/zsh

HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
FPATH="$XDG_DATA_HOME"/zsh/site-functions:$FPATH
KEYTIMEOUT=1

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

hash -d rfc=/usr/share/doc/rfc/txt
hash -d auto=$XDG_CONFIG_HOME/autostart
hash -d app=$XDG_DATA_HOME/applications

autoload -U select-word-style
zle -N select-word-style
select-word-style normal
zstyle :zle:transpose-words word-style shell

function zle-keymap-select() {
	case $KEYMAP in
	vicmd) echo -ne '\e[2 q';; # steady block
	viins|main) echo -ne '\e[6 q';; # steady line
	esac
	zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init() {
	zle -K viins
}
zle -N zle-line-init

function push-input-hold {
	buf="$BUFFER"
	cur="$CURSOR"
	zle push-input
	BUFFER="$buf"
	CURSOR="$cur"
}
zle -N push-input-hold

bindkey -v
bindkey -m 2>/dev/null

# See: https://wiki.archlinux.org/title/Zsh#Key_bindings
bindkey '^[q' push-input
bindkey '^[Q' push-input-hold
bindkey '^[[Z' reverse-menu-complete
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[t' transpose-words
bindkey '^ ' forward-word
bindkey '^?' backward-delete-char

bindkey -M vicmd '^[q' push-line
bindkey -M vicmd '^[Q' push-input-hold
bindkey -M vicmd '^[[Z' reverse-menu-complete
bindkey -M vicmd '^[[1~' beginning-of-line
bindkey -M vicmd '^[[4~' end-of-line
bindkey -M vicmd '^[[3~' delete-char
bindkey -M vicmd '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5D' backward-word

# History navigation
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search

# Edit current command in $EDITOR. From: https://unix.stackexchange.com/a/6622
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^v' edit-command-line

alias ls='ls --human-readable --color=auto --hyperlink=auto'
alias ip='ip -color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias info='info --vi-keys'
alias untar='tar -zxvf'
alias userctl='systemctl --user'

function title_precmd () {
	print -Pn -- '\e]2;%n@%m:%~\a'
}

function title_preexec () {
	print -Pn -- '\e]2;%n@%m:%~ %# ' 
	print -n -- "${(q)1}\a"
}

autoload -Uz add-zsh-hook
add-zsh-hook -Uz precmd title_precmd
add-zsh-hook -Uz preexec title_preexec

# Adopt the behavior of the system wide configuration for application specific settings
#
# See: https://wiki.archlinux.org/title/Command-line_shell#/etc/profile
for script in "$XDG_CONFIG_HOME"/zsh/.zshrc.d/*.zsh; do
	if [ -r "$script" ]; then
		source "$script"
	fi
done


zstyle :completion:* use-cache true
zstyle :completion:* cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

autoload -U compinit
compinit -u -C -d "${XDG_CACHE_HOME}/zsh/zcompdump"

TRAPUSR1() {
	rehash
	compinit -u -d "${XDG_CACHE_HOME}/zsh/zcompdump"
}

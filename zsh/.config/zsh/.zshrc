#!/bin/zsh
# vim: ft=sh

export HYPHEN_INSENSITIVE="true"
export DISABLE_UPDATE_PROMPT="true"
export DISABLE_AUTO_TITLE="true"
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export HISTSIZE=10000
export SAVEHIST=10000

setopt no_beep
setopt menu_complete
setopt auto_pushd             # auto push to the directory stack on cd
setopt auto_cd                # cd without args
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data
setopt nonomatch

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

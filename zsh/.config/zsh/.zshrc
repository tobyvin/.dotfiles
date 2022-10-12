#!/bin/zsh
# vim: ft=sh
# shellcheck shell=sh
# shellcheck disable=3000-4000,1090

export HYPHEN_INSENSITIVE="true"
export DISABLE_UPDATE_PROMPT="true"
export DISABLE_AUTO_TITLE="true"
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export HISTSIZE=10000
export SAVEHIST=10000
export GPG_TTY="$TTY"

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

zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

bindkey -v
bindkey '^ ' autosuggest-accept
bindkey '^[[Z' reverse-menu-complete
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[q' push-input

bindkey -M vicmd '^ ' autosuggest-accept
bindkey -M vicmd '^[[Z' reverse-menu-complete
bindkey -M vicmd '^[[1~' beginning-of-line
bindkey -M vicmd '^[[4~' end-of-line
bindkey -M vicmd '^[[3~' delete-char
bindkey -M vicmd '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5D' backward-word
bindkey -M vicmd '^[q' push-input

alias ls="ls --color=tty"
alias grep='grep --color'
alias ipa="ip -s -c -h a"
alias untar="tar -zxvf"
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias tlmgr='/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode'
alias unlock='echo "" | gpg --clearsign --verbose && ssh -T git@github.com'

SHELDON_PROFILE="$(uname -r | sed 's/^.*-//g' 2>/dev/null)"
export SHELDON_PROFILE
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line)
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#4f4738"

if command -v fd >/dev/null 2>&1; then
	_fzf_compgen_path() {
		fd --hidden --follow --exclude ".git" . "$1"
	}
fi

if command -v fd >/dev/null 2>&1; then
	_fzf_compgen_dir() {
		fd --type d --hidden --follow --exclude ".git" . "$1"
	}
fi

if command -v docker >/dev/null 2>&1; then
	alias dexec="docker exec -it"
	alias dps="docker ps"
	alias dc="docker compose"
	alias dce="docker compose exec"
	alias dcps="docker compose ps"
	alias dcls="docker compose ls"
	alias dcdn="docker compose down"
	alias dcup="docker compose up"
	alias dcupd="docker compose up -d"
	alias dcl="docker compose logs"
	alias dclf="docker compose logs -f"
	alias dct="docker context"
	alias dcu="docker context use"
fi

if command -v lsd >/dev/null 2>&1; then
	alias ls='lsd'
fi

if command -v rga >/dev/null 2>&1; then
	rgi() {
		RG_PREFIX="rga --files-with-matches"
		file="$(
			FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
				fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
		)" &&
			echo "opening $file" &&
			xdg-open "$file"
	}
fi

command -v starship >/dev/null 2>&1 && source <(starship init zsh)
command -v sheldon >/dev/null 2>&1 && source <(sheldon source)

#!/usr/bin/bash

export HISTFILE=$XDG_STATE_HOME/bash/history

# Aliases
alias ls='ls --color=tty'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lla='ls -lA'
alias lsa='ls -lah'
alias grep='grep --color'
alias ipa="ip -s -c -h a"
alias untar="tar -zxvf"
alias td=". td.sh"
alias vim=nvim
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

if [[ $- == *i* ]] && [ -d "$BASHCOMPDIR" ]; then
	for f in "$BASHCOMPDIR"/*; do
		source "$f"
	done
fi

command -v starship >/dev/null 2>&1 && source <(starship init bash)

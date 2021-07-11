#!/usr/bin/env bash

alias dbi="$DOTFILES/install"
alias dbu="$DOTFILES/update"
alias ls='ls --color=tty'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lla='ls -lA'
alias lsa='ls -lah'
alias grep='grep --color'
alias cat=bat
alias ipa="ip -s -c -h a"
alias untar="tar -zxvf "
alias update="sudo apt update && apt list --upgradable"
alias upgrade="sudo apt upgrade -y"
alias cht="cht.sh"
alias dc="docker-compose"
docker compose >&/dev/null && alias dc="docker compose"
alias dm="docker-machine"
alias dexec="docker exec -it"
alias dps="docker ps"
alias dce="dc exec"
alias dcps="dc ps"
alias dcls="dc ls"
alias dcdn="dc down"
alias dcup="dc up"
alias dcupd="dc up -d"
alias dcl="dc logs"
alias dclf="dc logs -f"

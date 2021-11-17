#!/usr/bin/env bash

alias ls='ls --color=tty'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lla='ls -lA'
alias lsa='ls -lah'
alias grep='grep --color'
alias ipa="ip -s -c -h a"
alias untar="tar -zxvf"
# scripts
alias dfi=~/dotfiles/install
alias dfu=~/dotfiles/update
alias pluto="ssh root@foundry.tobyvin.com /root/foundry/update-plutonium.sh"
# docker
alias dexec="docker exec -it"
alias dps="docker ps"
# docker compose
alias dc="docker compose"
alias dce="docker compose exec"
alias dcps="docker compose ps"
alias dcls="docker compose ls"
alias dcdn="docker compose down"
alias dcup="docker compose up"
alias dcupd="docker compose up -d"
alias dcl="docker compose logs"
alias dclf="docker compose logs -f"
# docker context
alias dct="docker context"
alias dcu="docker context use"
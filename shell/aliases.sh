#!/usr/bin/env bash

alias ls='ls --color=tty'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lla='ls -lA'
alias lsa='ls -lah'
alias grep='grep --color'
alias cat='bat --paging=never'
alias ipa="ip -s -c -h a"
alias untar="tar -zxvf"
# scripts
alias dfi="$DOTFILES/install"
alias dfu="$DOTFILES/update"
alias initgit="init-git.sh"
alias inittex="init-latex.sh"
alias initsrc="init-src.sh"
alias cht="cht.sh"
# docker
alias dexec="docker exec -it"
alias dps="docker ps"
# docker compose
alias dc="docker compose"
alias dce="dc exec"
alias dcps="dc ps"
alias dcls="dc ls"
alias dcdn="dc down"
alias dcup="dc up"
alias dcupd="dc up -d"
alias dcl="dc logs"
alias dclf="dc logs -f"
# docker machine
alias dm="docker-machine"
alias dma="docker-machine active"
alias dmi="docker-machine inspect"
alias dmu="docker-machine-use"
docker-machine-use() { eval $(docker-machine env ${1:=-u}); }

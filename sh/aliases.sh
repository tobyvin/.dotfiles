#!/usr/bin/env bash

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

if command -v docker &>/dev/null; then
    if [ -f ~/.docker/cli-plugins/docker-compose ]; then
        alias dc="docker compose"
    else
        alias dc="docker-compose"
    fi
    alias doe="docker exec -it"
    alias dops="docker ps"
    alias dce="dc exec"
    alias dcps="dc ps"
    alias dcls="dc ls"
    alias dcdn="dc ls"
    alias dcup="dc up"
    alias dcupd="dc up -d"
fi

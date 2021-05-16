#!/usr/bin/env bash

export EDITOR="code --wait"

alias cb=clip.exe
alias wsl=wsl.exe
alias ykman="/mnt/c/Program\ Files/Yubico/YubiKey\ Manager/ykman.exe"

function wt() { powershell.exe -NoProfile -c "wt $@" }

function winget() {
  cmd="winget.exe $1"
  shift # past cmd

  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
        -*) # key value pair
        cmd+=" $key '$2'"
        shift # past argument
        shift # past value
        ;;
        *)    # positional argument
        cmd+=" '$1'" # add it to the list
        shift # past argument
        ;;
    esac
  done
  
  powershell.exe -NoProfile -c "$cmd"
}
#!/usr/bin/env bash

WINHOME="$(wslpath "$(powershell.exe -NoProfile -c \$HOME)")"

# XDG Specs
export XDG_DESKTOP_DIR="$WINHOME/Desktop"
export XDG_DOCUMENTS_DIR="$WINHOME/Documents"
export XDG_DOWNLOAD_DIR="$WINHOME/Downloads"
export XDG_MUSIC_DIR="$WINHOME/Music"
export XDG_PICTURES_DIR="$WINHOME/Pictures"
export XDG_TEMPLATES_DIR="$WINHOME/Templates"
export XDG_VIDEOS_DIR="$WINHOME/Videos"

export EDITOR="code --wait"

alias cb=clip.exe
alias wsl=wsl.exe
alias ykman='/mnt/c/Program\ Files/Yubico/YubiKey\ Manager/ykman.exe'

function wt() {
  powershell.exe -NoProfile -c "wt $@"
}

function winget() {
  cmd="winget.exe $1"
  shift # past cmd

  while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -*) # key value pair
      cmd+=" $key '$2'"
      shift # past argument
      shift # past value
      ;;
    *)             # positional argument
      cmd+=" '$1'" # add it to the list
      shift        # past argument
      ;;
    esac
  done

  powershell.exe -NoProfile -c "$cmd"
}

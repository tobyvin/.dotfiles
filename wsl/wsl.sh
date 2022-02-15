#!/usr/bin/env bash

WINHOME="/mnt/c/Users/$USER"
[ "$PWD" = "$WINHOME" ] && cd

export BROWSER=wslview
export EDITOR="code --wait"
export PATH=$(echo "$PATH" | sed -e 's/:\/mnt\/c\/Users\/tobyv\/.cargo\/bin\(:\|$\)//')

alias cb=clip.exe
alias wsl=wsl.exe
alias ykman='/mnt/c/Program\ Files/Yubico/YubiKey\ Manager/ykman.exe'

wt() {
  powershell.exe -NoProfile -c "wt $@"
}

wsl_cmd_proxy() {
  exe="$1"
  shift # past exe

  cmd=" ${1}"
  shift # past cmd

  args=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -*)
      args+="${1} '${2}' "
      shift
      shift
      ;;
    *)
      args+="'${1}'"
      shift
      ;;
    esac
    args+=" "
  done

  powershell.exe -NoProfile -c 'cd $HOME;' "$exe" "$cmd" "$args"
}

function winget { wsl_cmd_proxy "winget.exe" "$@"; }
function scoop { wsl_cmd_proxy "scoop" "$@"; }

# https://github.com/validatedev/drop-cache-if-idle
[ -z "$(ps -ef | grep cron | grep -v grep)" ] && sudo /etc/init.d/cron start &>/dev/null

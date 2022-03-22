#!/usr/bin/env bash

WINHOME="/mnt/c/Users/$USER"
[ "$PWD" = "$WINHOME" ] && cd

mkdir -p /tmp/xdg

export BROWSER=wslview
export EDITOR="code --wait"
export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0
export XDG_RUNTIME_DIR=/tmp/xdg

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

winget() { wsl_cmd_proxy "winget.exe" "$@"; }
scoop() { wsl_cmd_proxy "scoop" "$@"; }
alacritty() { wsl_cmd_proxy "alacritty.exe" "$@"; }

# https://github.com/validatedev/drop-cache-if-idle
[ -z "$(ps -ef | grep cron | grep -v grep)" ] && sudo /etc/init.d/cron start &>/dev/null

#!/usr/bin/env bash

WINHOME="/mnt/c/Users/$USER"
[ "$PWD" = "$WINHOME" ] && cd

export EDITOR="code --wait"
export DOCKER_HOST=${DOCKER_HOST:-tcp://0.0.0.0:2375}
export DOCKER_MACHINE_NAME=${DOCKER_MACHINE_NAME:-$HOST}

# unalias cb 2>/dev/null
alias cb=clip.exe
alias wsl=wsl.exe
alias ykman='/mnt/c/Program\ Files/Yubico/YubiKey\ Manager/ykman.exe'
alias dmu="docker-machine-wsl"

docker-machine-wsl() {
  docker-machine-use $@
  export DOCKER_HOST=${DOCKER_HOST:-tcp://0.0.0.0:2375}
  export DOCKER_MACHINE_NAME=${DOCKER_MACHINE_NAME:-$HOST}
}

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
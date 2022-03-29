#!/usr/bin/env bash

[ -n "${WSL_DISTRO_NAME+1}" ] || return 0

WINHOME="/mnt/c/Users/$USER"
[ "$PWD" = "$WINHOME" ] && cd

mkdir -p /tmp/xdg

export BROWSER=wslview
export EDITOR="code --wait"
export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0
export XDG_RUNTIME_DIR=/tmp/xdg
export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
export GPG_TTY=$( tty )

alias wsl=wsl.exe
alias ykman='/mnt/c/Program\ Files/Yubico/YubiKey\ Manager/ykman.exe'
alias pip2="DISPLAY= pip2"
alias pip3="DISPLAY= pip3"
alias pip3.7="DISPLAY= pip3.7"
alias pip3.10="DISPLAY= pip3.10"
alias pip="DISPLAY= pip3"

wt() {
  powershell.exe -NoProfile -c "wt $*"
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

gpg-init() (
    if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
        rm -f "$SSH_AUTH_SOCK"
        wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
        if test -x "$wsl2_ssh_pageant_bin"; then
            (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
        else
            echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
        fi
        unset wsl2_ssh_pageant_bin
    fi

    if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
        rm -rf "$GPG_AGENT_SOCK"
        wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
        if test -x "$wsl2_ssh_pageant_bin"; then
            (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &)
        else
            echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
        fi
        unset wsl2_ssh_pageant_bin
    fi

    if ! ss -a | grep -q "${GPG_AGENT_SOCK}.extra"; then
        rm -rf "${GPG_AGENT_SOCK}.extra"
        wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
        if test -x "$wsl2_ssh_pageant_bin"; then
            (setsid nohup socat UNIX-LISTEN:"${GPG_AGENT_SOCK}.extra,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent.extra" >/dev/null 2>&1 &)
        else
            echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
        fi
        unset wsl2_ssh_pageant_bin
    fi
)

_start-pageant() {
    # TODO: WIP
    if ! ss -a | grep -q "${GPG_AGENT_SOCK}.extra"; then
        rm -rf "${GPG_AGENT_SOCK}.extra"
        wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
        if test -x "$wsl2_ssh_pageant_bin"; then
            (setsid nohup socat UNIX-LISTEN:"${GPG_AGENT_SOCK}.extra,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent.extra" >/dev/null 2>&1 &)
        else
            echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
        fi
        unset wsl2_ssh_pageant_bin
    fi
}

# Reload
gpg-reset() {
    gpg-connect-agent.exe KILLAGENT /bye &>/dev/null
    pkill -f 'socat.*wsl2-ssh-pageant.exe'
    gpg-connect-agent.exe /bye &>/dev/null
    gpg-init
}

# Relearn card serial number
gpg-learn() {
    gpg-connect-agent.exe "scd serialno" "learn --force" /bye
}

gpg-init

unset -f _start-pageant
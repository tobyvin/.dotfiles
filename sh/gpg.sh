#!/usr/bin/env bash

# https://github.com/benpye/wsl-ssh-pageant
# https://github.com/drduh/YubiKey-Guide#remote-host-configuration
# https://dev.to/dzerycz/series/11353

# GPG & SSH Socket
# Removing Linux Agent sockets and replace it with wsl2-ssh-pageant socket
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
export GPG_AGENT_SOCK=$HOME/.gnupg/S.gpg-agent
export SOCKETS=("${SSH_AUTH_SOCK}" "${GPG_AGENT_SOCK}" "${GPG_AGENT_SOCK}.extra")

function gpg-init() (
    wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"

    if ! test -x "$wsl2_ssh_pageant_bin"; then
        echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
        return
    fi

    for socket in "${SOCKETS[@]}"; do
        if ss -a | grep -q $socket; then
            rm -rf $socket
            (setsid nohup socat UNIX-LISTEN:"$socket,fork" EXEC:"$wsl2_ssh_pageant_bin $([ $socket != $SSH_AUTH_SOCK ] && echo "--gpg $(basename $socket)")" >/dev/null 2>&1 &)
        fi
    done
)

# Reload
function gpg-reset() {
    gpg-connect-agent.exe KILLAGENT /bye &>/dev/null
    pkill -f 'socat.*wsl2-ssh-pageant.exe'
    gpg-connect-agent.exe /bye &>/dev/null
    gpg-init
}

# Relearn card serial number
function gpg-learn {
    gpg-connect-agent.exe "scd serialno" "learn --force" /bye
}

gpg-init

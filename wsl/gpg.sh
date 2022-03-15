#!/usr/bin/env bash

# https://github.com/benpye/wsl-ssh-pageant
# https://github.com/drduh/YubiKey-Guide#remote-host-configuration
# https://dev.to/dzerycz/series/11353

# GPG & SSH Socket
# Removing Linux Agent sockets and replace it with wsl2-ssh-pageant socket

start-pageant() {
    local pageant="$HOME/.ssh/wsl2-ssh-pageant.exe"
    local sock=$1
    local cmd="${pageant}"

    if echo "$sock" | grep -q "gpg"; then
        cmd+=" --gpg ${sock}"
    fi

    if ! ss -a | grep -q "$sock"; then
        if test -x "$pageant"; then
            rm -rf "$sock"
            (setsid nohup socat UNIX-LISTEN:"${sock},fork" EXEC:"$cmd" >/dev/null 2>&1 &)
        else
            echo >&2 "WARNING: $pageant is not executable."
        fi
    fi
}

start-pageants() {
    sockets=("$SSH_AUTH_SOCK", "$GPG_AGENT_SOCK", "${GPG_AGENT_SOCK}.extra")
    for sock in ${sockets[@]}; do
        start-pageant $sock
    done
}

# Reload
gpg-reset() {
    gpg-connect-agent.exe KILLAGENT /bye &>/dev/null
    pkill -f 'socat.*wsl2-ssh-pageant.exe'
    gpg-connect-agent.exe /bye &>/dev/null
    start-pageants
}

# Relearn card serial number
gpg-learn() {
    gpg-connect-agent.exe "scd serialno" "learn --force" /bye
}

export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"

start-pageants

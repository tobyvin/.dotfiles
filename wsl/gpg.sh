#!/usr/bin/env bash

# https://github.com/benpye/wsl-ssh-pageant
# https://github.com/drduh/YubiKey-Guide#remote-host-configuration
# https://dev.to/dzerycz/series/11353

# GPG & SSH Socket
# Removing Linux Agent sockets and replace it with wsl2-ssh-pageant socket

# gpg-init() (
#     if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
#         rm -f "$SSH_AUTH_SOCK"
#         wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
#         if test -x "$wsl2_ssh_pageant_bin"; then
#             (setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin" >/dev/null 2>&1 &)
#         else
#             echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
#         fi
#         unset wsl2_ssh_pageant_bin
#     fi

#     if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
#         rm -rf "$GPG_AGENT_SOCK"
#         wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
#         if test -x "$wsl2_ssh_pageant_bin"; then
#             (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent" >/dev/null 2>&1 &)
#         else
#             echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
#         fi
#         unset wsl2_ssh_pageant_bin
#     fi

#     if ! ss -a | grep -q "${GPG_AGENT_SOCK}.extra"; then
#         rm -rf "${GPG_AGENT_SOCK}.extra"
#         wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
#         if test -x "$wsl2_ssh_pageant_bin"; then
#             (setsid nohup socat UNIX-LISTEN:"${GPG_AGENT_SOCK}.extra,fork" EXEC:"$wsl2_ssh_pageant_bin --gpg S.gpg-agent.extra" >/dev/null 2>&1 &)
#         else
#             echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
#         fi
#         unset wsl2_ssh_pageant_bin
#     fi
# )

start-pageant() {
    local pageant="$HOME/.ssh/wsl2-ssh-pageant.exe"
    local sock="$1"
    local cmd="$pageant"

    case "$sock" in
    *gpg*) cmd+=" --gpg $(basename $sock)" ;;
    *discord*)
        pageant="$(command -v npiperelay.exe)"
        cmd="$pageant -ep -s //./pipe/discord-ipc-0"
        ;;
    esac

    if ! ss -a | grep -q "$sock"; then
        if test -x "$pageant"; then
            rm -rf "$sock"
            # echo "(setsid nohup socat UNIX-LISTEN:\"${sock},fork\" EXEC:\"$cmd\" >/dev/null 2>&1 &)"
            (setsid nohup socat UNIX-LISTEN:"${sock},fork" EXEC:"$cmd" >/dev/null 2>&1 &)
        else
            echo >&2 "WARNING: $pageant is not executable."
        fi
    fi
}

# Reload
gpg-reset() {
    $socket_relay restart --ssh
    $socket_relay restart --gpg
    $socket_relay restart --gpg-extra
}

discord-reset() {
    sudo pkill -f 'socat.*/var/run/discord-ipc-0.*npiperelay.exe'
    sudo -b ${HOME}/dotfiles/scripts/discord-relay.sh
}

# Relearn card serial number
gpg-learn() {
    gpg-connect-agent.exe "scd serialno" "learn --force" /bye
}

export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"

socket_relay="${HOME}/dotfiles/scripts/socket-relay.sh"

$socket_relay start --ssh
$socket_relay start --gpg
$socket_relay start --gpg-extra

sudo -b ${HOME}/dotfiles/scripts/discord-relay.sh

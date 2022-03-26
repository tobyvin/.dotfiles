#!/usr/bin/env bash
set -euo pipefail

OPTS=$(getopt -o hds:x: --long help,debug,sock:,exec:,ssh,gpg,gpg-extra,discord -n 'javawrap' -- "$@")

eval set -- "$OPTS"

PAGEANT="$HOME/.ssh/wsl2-ssh-pageant.exe"
NPIPE="$(command -v npiperelay.exe)"
SCRIPT="$(basename "$0")"

help() {
    cat <<-EOF
$SCRIPT
Toby Vincent <tobyv13@gmail.com>

$SCRIPT description

USAGE:
    $SCRIPT [OPTIONS] <COMMAND>
    $SCRIPT [OPTIONS]

OPTIONS:
    -h, --help              Display this message
    -s, --sock <SOCKET>     Path to the linux socket
    -x, --exec <CMD>        Command to run for socat's EXEC: arg
    --ssh                   Relay the ssh agent's socket 
    --gpg                   Relay the gpg agent's socket
    --gpg-extra             Relay the gpg agent's extra socket

ARGS:
    start (default)
        Start the socat process

    stop
        Kill the socat process
EOF
}

say() {
    if ! $quiet; then
        echo "$SCRIPT: $1"
    fi
}

say_err() {
    say "$1" >&2
}

err() {
    say_err "ERROR: $1"
    exit 1
}

need() {
    for cmd in $@; do
        if ! command -v $cmd >/dev/null 2>&1; then
            err "need $cmd (command not found)"
        fi
    done
}

start() {
    if ! ss -a | grep -q "$sock"; then
        if test -x "$relay"; then
            rm -rf "$sock"
            (setsid nohup socat UNIX-LISTEN:"${sock},${listen_args}" EXEC:"$cmd" >/dev/null 2>&1 &)

        else
            echo >&2 "WARNING: $relay is not executable."
        fi
    fi

    if $gpg; then
        gpg-connect-agent.exe /bye &>/dev/null
    fi
}

stop() {
    if $gpg; then
        gpg-connect-agent.exe KILLAGENT /bye &>/dev/null
    fi

    if pgrep -f "socat.*$sock.*$relay" &>/dev/null; then
        pkill -f "socat.*$sock.*$relay"
    fi
}

check() {
    pgrep -fa "socat.*$sock.*$relay"
}

quiet=false
debug=false
sock=""
cmd=""
gpg=false
ssh=false
extra=false
discord=false
while test $# -gt 0; do
    case $1 in
    -h | --help)
        help
        return 0
        ;;
    -q | --quiet)
        quiet=true
        shift
        ;;
    -d | --debug)
        debug=true
        shift
        ;;
    -s | --sock)
        sock=$2
        shift
        shift
        ;;
    -x | --exec)
        cmd=$2
        shift
        shift
        ;;
    --ssh)
        ssh=true
        shift
        ;;
    --gpg)
        gpg=true
        shift
        ;;
    --gpg-extra)
        gpg=true
        extra=true
        shift
        ;;
    --discord)
        discord=true
        shift
        ;;
    --)
        shift
        break
        ;;
    *)
        help
        exit 1
        ;;
    esac
done

need ss
need socat

listen_args="fork"

case true in
$ssh)
    need $PAGEANT

    sock="${SSH_AUTH_SOCK:-$HOME/.ssh/agent.sock}"
    cmd="$PAGEANT"
    ;;
$gpg)
    need $PAGEANT
    need "gpg-connect-agent.exe"

    sock="${GPG_AGENT_SOCK:-$HOME/.gnupg/S.gpg-agent}"
    if $extra; then
        sock+=".extra"
    fi

    cmd="$PAGEANT --gpg $(basename $sock)"
    ;;
$discord)
    need $NPIPE

    sock="${DISCORD_IPC_SOCK:-/var/run/discord-ipc-0}"
    cmd="$NPIPE -ep -s //./pipe/$(basename $sock)"

    listen_args="fork,group=discord,umask=007"
    ;;
$(test -z "${cmd}"))
    err "No EXEC provided. Must supply either --ssh, --gpg, --gpg-extra, --pipe, or --exec"
    ;;
esac

if test -z "${sock}"; then
    err "No socket provided."
fi

relay="$(echo $cmd | head -n1 | awk '{print $1;}')"

case ${1:-'start'} in
check)
    shift
    check
    ;;
start)
    shift
    start
    ;;
stop)
    shift
    stop
    ;;
restart)
    shift
    stop
    start
    ;;
*)
    help
    exit 1
    ;;
esac

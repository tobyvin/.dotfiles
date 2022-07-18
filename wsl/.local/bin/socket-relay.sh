#!/usr/bin/env sh
set -euo pipefail

OPTS=$(getopt -o hvs:a:x: --long help,verbose,sock:,args:,exec:,ssh,gpg,gpg-extra,discord -n 'javawrap' -- "$@")

eval set -- "$OPTS"

SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$HOME/.ssh/agent.sock}"
GPG_AGENT_SOCK="${GPG_AGENT_SOCK:-$HOME/.gnupg/S.gpg-agent}"
DISCORD_IPC_SOCK="${DISCORD_IPC_SOCK:-/var/run/discord-ipc-0}"
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

say_verbose() {
	if $verbose; then
		say "$@"
	fi
}

say_err() {
	say "$1" >&2
}

err() {
	# shellcheck disable=2145
	say_err "ERROR: $@"
	exit 1
}

need() {
	for cmd in "$@"; do
		if ! command -v $cmd >/dev/null 2>&1; then
			err "need $cmd (command not found)"
		fi
	done
}

start() {
	say_verbose "SOCKET: $sock"
	say_verbose "ARGS: $args"
	say_verbose "EXEC: $cmd"

	if $gpg; then
		say_verbose "gpg-connect-agent KILLAGENT"
		gpg-connect-agent.exe KILLAGENT /bye >"$v_stdout" 2>"$v_stderr"
	fi

	if ! ss -a | grep -q "$sock"; then
		rm -rf "$sock"
		(setsid nohup socat UNIX-LISTEN:"${sock},${args}" EXEC:"$cmd" >/dev/null 2>&1 &)
	fi

	if $gpg; then
		gpg-connect-agent.exe /bye >"$v_stdout" 2>"$v_stderr"
	fi
}

stop() {
	if $gpg; then
		gpg-connect-agent.exe KILLAGENT /bye >"$v_stdout" 2>"$v_stderr"
	fi

	pkill -fe "socat.*$sock.*$relay" >"$v_stdout"
}

check() {
	pgrep -fa "socat.*$sock.*$relay"
}

quiet=false
verbose=false
sock=""
cmd=""
gpg=false
ssh=false
extra=false
discord=false
v_stdout=/dev/null
v_stderr=/dev/null
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
	-v | --verbose)
		verbose=true
		v_stdout=/dev/stdout
		v_stderr=/dev/stderr
		shift
		;;
	-s | --sock)
		sock=$2
		shift
		shift
		;;
	-l | --args)
		args=$2
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

if $ssh; then
	need "$PAGEANT"

	sock="${sock:-$SSH_AUTH_SOCK}"
	args="${args:-fork}"
	cmd="${cmd:-$PAGEANT}"
elif $gpg; then
	need "$PAGEANT"
	need "gpg-connect-agent.exe"

	sock="${sock:-$GPG_AGENT_SOCK}"
	args="${args:-fork}"
	cmd="${cmd:-$PAGEANT --gpg $(basename "$sock")}"
	if $extra; then
		sock=sock+".extra"
	fi
elif $discord; then
	need "$NPIPE"

	sock="${DISCORD_IPC_SOCK:-/var/run/discord-ipc-0}"
	cmd="$NPIPE -ep -s //./pipe/$(basename "$sock")"
	args="fork,group=discord,umask=007"
fi

relay="$(echo "$cmd" | head -n1 | awk '{print $1;}')"

if [ -z "$cmd" ]; then
	err "No EXEC provided. Must supply either one of the preset options, or provide an explicit value with --exec"
fi

if [ -z "$sock" ]; then
	err "No socket provided."
fi

if ! [ -x "$relay" ]; then
	err "WARNING: $relay is not executable."
fi

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

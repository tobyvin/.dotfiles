#!/usr/bin/env sh
set -e

OPTS=$(getopt -o hvs:a:x: --long help,verbose,sock:,args:,exec:,ssh,gpg,gpg-extra,gpg-ssh,gpg-browser,discord -n 'javawrap' -- "$@")

eval set -- "$OPTS"

GPG_AGENT_SOCK="${GPG_AGENT_SOCK:-$HOME/.gnupg/S.gpg-agent}"
# SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$HOME/.ssh/agent.sock}"
SSH_AUTH_SOCK="$GPG_AGENT_SOCK.ssh"
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
		            status
		                Check the status of the socat process
		    start (default)
		        Start the socat process
		    stop
		        Kill the socat process
		            restart
		                Same as $($SCRIPT stop && $SCRIPT start)
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
	for need_cmd in "$@"; do
		if ! command -v "$need_cmd" >/dev/null 2>&1; then
			err "need $need_cmd (command not found)"
		fi
	done
}

start() {
	say_verbose "SOCKET: $sock"
	say_verbose "ARGS: $args"
	say_verbose "EXEC: $exec"

	if [ -z "$exec" ]; then
		err "No EXEC provided. Must supply either one of the preset options, or provide an explicit value with --exec"
	fi

	if [ -z "$sock" ]; then
		err "No socket provided."
	fi

	if ! command -v "$relay" >/dev/null 2>&1; then
		err "$relay is not executable."
	fi

	if ! pgrep -fa "socat.*$sock.*$relay,"; then
		rm -rf "$sock"
		(setsid nohup socat UNIX-LISTEN:"${sock},${args}" EXEC:"$exec" >/dev/null 2>&1 &)
	fi

	if $gpg; then
		gpg-connect-agent.exe /bye >"$v_stdout" 2>"$v_stderr"
	fi
}

stop() {
	if [ -z "$sock" ]; then
		err "No socket provided."
	fi

	if [ -z "$relay" ]; then
		err "No exec provided"
	fi

	if $gpg; then
		gpg-connect-agent.exe KILLAGENT /bye >"$v_stdout" 2>"$v_stderr"
	fi

	pkill -fe "socat.*$sock.*$relay" >"$v_stdout"

	rm -rf "$sock"
}

status() {
	proc="socat.*${sock:-}.*${relay:-}"

	if ! pgrep -fa "$proc"; then
		say_err "No process found"
		return 1
	fi
}

quiet=false
verbose=false
sock=""
exec=""
gpg=false
gpg_extra=false
gpg_ssh=false
gpg_browser=false
ssh=false
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
		exec=$2
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
		gpg_extra=true
		shift
		;;
	--gpg-ssh)
		gpg=true
		gpg_ssh=true
		shift
		;;
	--gpg-browser)
		gpg=true
		gpg_browser=true
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

	sock="${ssh_sock:-$SSH_AUTH_SOCK}"
	args="${ssh_args:-fork}"
	exec="${ssh_exec:-$PAGEANT}"
elif $gpg; then
	need "$PAGEANT"
	need "gpg-connect-agent.exe"

	config_path="C\:/Users/$USER/AppData/Local/gnupg"
	case ${1:-'start'} in
	"$gpg_extra")
		sock="${gpg_sock:-$GPG_AGENT_SOCK}.extra"
		;;
	"$gpg_ssh")
		sock="${gpg_sock:-$GPG_AGENT_SOCK}.ssh"
		;;
	"$gpg_browser")
		sock="${gpg_sock:-$GPG_AGENT_SOCK}.browser"
		;;
	*)
		sock="${gpg_sock:-$GPG_AGENT_SOCK}"
		;;
	esac
	args="${gpg_args:-fork}"
	exec="${gpg_exec:-$PAGEANT --gpgConfigBasepath ${config_path} --gpg $(basename "$sock")}"
elif $discord; then
	need "$NPIPE"

	sock="${DISCORD_IPC_SOCK:-/var/run/discord-ipc-0}"
	exec="$NPIPE -ep -s //./pipe/$(basename "$sock")"
	args="fork,group=discord,umask=007"
fi

relay="$(echo "$exec" | head -n1 | awk '{print $1;}')"

case ${1:-'start'} in
status)
	status
	;;
start)
	start
	;;
stop)
	stop
	;;
restart)
	stop
	start
	;;
*)
	help
	exit 1
	;;
esac

#!/bin/sh
# shellcheck disable=2155

# [ -n "${WSL_DISTRO_NAME+1}" ] || return 0

WINHOME="/mnt/c/Users/$USER"
# shellcheck disable=2164
[ "$PWD" = "$WINHOME" ] && cd

mkdir -p /tmp/xdg

export DISPLAY="$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}')":0
export BROWSER=wslview
export XDG_RUNTIME_DIR=/tmp/xdg
export GPG_TTY="$(tty)"

alias wsl=wsl.exe
alias ykman='/mnt/c/Program\ Files/Yubico/YubiKey\ Manager/ykman.exe'
alias pip2="DISPLAY= pip2"
alias pip3="DISPLAY= pip3"
alias pip3.7="DISPLAY= pip3.7"
alias pip3.10="DISPLAY= pip3.10"
alias pip="DISPLAY= pip3"

wsl_path() {
    win_path="$(powershell.exe "(get-command $1 -ErrorAction SilentlyContinue).Source")"
    if [ ! -z "$win_path" ]; then
        echo "$(wslpath "$win_path" | sed 's/\s/\\\ /g' | sed 's/\\\s*$//')"
    fi
}

alias alacritty="$(wsl_path "alacritty")"
alias pwsh="$(wsl_path "pwsh")"

wsl_cmd_proxy() {
	exe="$1"
	shift # past exe

	cmd=" ${1}"
	shift # past cmd

	args=""
	while [ $# -gt 0 ]; do
		case "$1" in
		-*)
			args="$args${1} '${2}' "
			shift
			shift
			;;
		*)
			args="$args'${1}'"
			shift
			;;
		esac
		args="$args "
	done

	# shellcheck disable=2016
	powershell.exe -NoProfile -c 'cd $HOME;' "$exe" "$cmd" "$args"
}

winget() { wsl_cmd_proxy "winget.exe" "$@"; }
scoop() { wsl_cmd_proxy "scoop" "$@"; }

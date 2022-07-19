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
export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"
export SSH_AUTH_SOCK="$GPG_AGENT_SOCK.ssh"
export GPG_TTY="$(tty)"

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
alacritty() { wsl_cmd_proxy "alacritty.exe" "$@"; }
# pwsh() { alacritty --working-directory "c:\\Users\\${USER}" -e "pwsh.exe $@"; }

gpg_init() (
	wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
	config_path="C\:/Users/$USER/AppData/Local/gnupg"

	if ! test -x "$wsl2_ssh_pageant_bin"; then
		echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
	else
		gpg-connect-agent.exe /bye >/dev/null 2>&1

		if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
			rm -f "$SSH_AUTH_SOCK"
			(setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpgConfigBasepath ${config_path} -gpg S.gpg-agent.ssh" >/dev/null 2>&1 &)
		fi

		if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
			rm -rf "$GPG_AGENT_SOCK"
			(setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin -gpgConfigBasepath ${config_path} -gpg S.gpg-agent" >/dev/null 2>&1 &)
		fi

		if ! ss -a | grep -q "${GPG_AGENT_SOCK}.extra"; then
			rm -rf "${GPG_AGENT_SOCK}.extra"
			(setsid nohup socat UNIX-LISTEN:"${GPG_AGENT_SOCK}.extra,fork" EXEC:"$wsl2_ssh_pageant_bin -gpgConfigBasepath ${config_path} -gpg S.gpg-agent.extra" >/dev/null 2>&1 &)
		fi
	fi
	unset wsl2_ssh_pageant_bin
)

# Reload
gpg_reset() {
	gpg-connect-agent.exe KILLAGENT /bye >/dev/null 2>&1

	rm -rfv "$GPG_AGENT_SOCK"
	rm -rfv "$GPG_AGENT_SOCK.extra"
	pkill -f 'socat.*wsl2-ssh-pageant.exe'
	gpg-connect-agent.exe /bye >/dev/null 2>&1
	gpg_init
}

# Relearn card serial number
gpg_learn() {
	gpg-connect-agent.exe "scd serialno" "learn --force" /bye
}

gpg_init

unset -f _start-pageant

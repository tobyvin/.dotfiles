#!/bin/sh

# win_home="$(wslpath -u "$(wslvar HOMEDRIVE)$(wslvar HOMEPATH)")"
wsl2_ssh_pageant_bin="$HOME/.ssh/wsl2-ssh-pageant.exe"
config_path="C\:/Users/$USER/AppData/Local/gnupg"

if ! test -x "$wsl2_ssh_pageant_bin"; then
	echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
else
	gpg-connect-agent.exe /bye >/dev/null 2>&1

	if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
		rm -f "$SSH_AUTH_SOCK"
		(setsid nohup socat UNIX-LISTEN:"$SSH_AUTH_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpgConfigBasepath ${config_path}" >/dev/null 2>&1 &)
	fi

	if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
		rm -rf "$GPG_AGENT_SOCK"
		(setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin --gpgConfigBasepath ${config_path} -gpg S.gpg-agent" >/dev/null 2>&1 &)
	fi

	if ! ss -a | grep -q "${GPG_AGENT_SOCK}.extra"; then
		rm -rf "${GPG_AGENT_SOCK}.extra"
		(setsid nohup socat UNIX-LISTEN:"${GPG_AGENT_SOCK}.extra,fork" EXEC:"$wsl2_ssh_pageant_bin --gpgConfigBasepath ${config_path} -gpg S.gpg-agent.extra" >/dev/null 2>&1 &)
	fi
fi

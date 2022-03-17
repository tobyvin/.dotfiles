export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
export GPG_AGENT_SOCK="$HOME/.gnupg/S.gpg-agent"

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

start-pageant() {
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

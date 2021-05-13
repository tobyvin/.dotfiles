# https://github.com/benpye/wsl-ssh-pageant
# https://github.com/drduh/YubiKey-Guide#remote-host-configuration
# https://dev.to/dzerycz/series/11353

# SSH Socket
# Removing Linux SSH socket and replacing it by link to wsl2-ssh-pageant socket
# export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
# ss -a | grep -q $SSH_AUTH_SOCK
# if [ $? -ne 0 ]; then
#     rm -f $SSH_AUTH_SOCK
#     (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$DOTFILES/ssh/wsl2-ssh-pageant.exe" &>/dev/null &)
# fi

# GPG Socket
# Removing Linux GPG Agent socket and replacing it by link to wsl2-ssh-pageant GPG socket
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
export GPG_AGENT_SOCK=$HOME/.gnupg/S.gpg-agent
export SOCKETS=("${SSH_AUTH_SOCK}" "${GPG_AGENT_SOCK}" "${GPG_AGENT_SOCK}.extra")

function gpg-init() (
    for socket in "${SOCKETS[@]}"; do
        ss -a | grep -q $socket
        if [ $? -ne 0 ]; then
            rm -rf $socket
            (setsid nohup socat UNIX-LISTEN:$socket,fork EXEC:"$DOTFILES/ssh/wsl2-ssh-pageant.exe $([ $socket != $SSH_AUTH_SOCK ] && echo "--gpg $(basename $socket)")" &>/dev/null &)
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

alias gpgrst=gpg-reset
gpg-init

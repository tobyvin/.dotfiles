
# GPG/SSH
export GPG_AGENT_SOCK=$(gpgconf --list-dirs agent-socket)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

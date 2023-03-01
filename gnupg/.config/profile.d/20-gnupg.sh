#!/bin/sh

GPG_AGENT_SOCK="$(gpgconf --list-dirs agent-socket)"
export GPG_AGENT_SOCK

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	export SSH_AUTH_SOCK
fi

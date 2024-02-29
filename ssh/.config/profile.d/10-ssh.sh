#!/bin/sh

if [ -z "$SSH_CONNECTION" ]; then
	export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

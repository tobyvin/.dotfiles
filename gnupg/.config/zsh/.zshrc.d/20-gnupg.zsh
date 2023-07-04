#!/bin/zsh
# vim:ft=sh

if [ -t 0 ] && [ -z "$SSH_TTY" ]; then
	export GPG_TTY="$(tty)"
	export PINENTRY_USER_DATA=USE_TTY=1
fi

gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

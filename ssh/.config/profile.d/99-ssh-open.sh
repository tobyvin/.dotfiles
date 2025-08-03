#!/bin/sh

if [ -n "$SSH_CLIENT" ]; then
	export BROWSER="ssh-open"
fi

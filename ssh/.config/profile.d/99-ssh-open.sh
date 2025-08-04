#!/bin/sh

if [ -n "$SSH_CONNECTION" ]; then
	export BROWSER="ssh-open"
fi

#!/bin/sh

export LESS="-RF --mouse"
export LESSHISTFILE="$XDG_STATE_HOME/lesshst"

if [ -n "$LESSOPEN" ] && [ "$LESSOPEN" = "${LESSOPEN#'|-'}" ]; then
	export LESSOPEN=${LESSOPEN:+|-${LESSOPEN#\|}}
fi

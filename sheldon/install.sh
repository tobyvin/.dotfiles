#!/bin/sh

SCRIPT="$0"

say() {
	printf "%s: %s\n" "$SCRIPT" "$@"
}

say "Installing plugins"
sheldon lock

#!/bin/sh

SCRIPT="$0"

say() {
	printf "%s: %s\n" "$SCRIPT" "$@"
}

say "Installing plugins..."
nvim --headless -c 'Lazy! restore' -c qa
nvim --headless -c 'Lazy! clean' -c qa

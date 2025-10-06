#!/usr/bin/bash
# shellcheck disable=1090

if [[ $- == *i* ]] && [ -d "$BASHCOMPDIR" ]; then
	for f in "$BASHCOMPDIR"/*; do
		source "$f"
	done
fi

command -v starship >/dev/null 2>&1 && source <(starship init bash)

#!/bin/sh

if [ -d "$XDG_DATA_HOME/nvim/session" ]; then
	printf '%s: Moving nvim session directory from %s into %s\n' "$0" "$XDG_STATE_HOME" "$XDG_STATE_HOME"
	mv -Tnv "$XDG_DATA_HOME/nvim/session" "$XDG_STATE_HOME/nvim/session"
fi

for dir in src pkg; do
	if [ -d "$HOME"/$dir ]; then
		printf '%s: Moving ~/%s directory into ~/.local\n' "$0" $dir
		mv -Tnv "$HOME/src" "$HOME/.local/src"
	fi

	for state_dir in undo session; do
		for f in "$XDG_STATE_HOME/nvim/$state_dir/%home%tobyv%$dir%"*; do
			if [ -e "$f" ]; then
				printf '%s: Migrating nvim %s files to match new location\n' "$0" "$state_dir"
				sed -i 's|~/src/|~/.local/src|g' "$f"
				printf '%s\n' "$f" | sed "s|/%home%tobyv%$dir%|/%home%tobyv%.local%$dir%|" | xargs mv -Tnv "$f"
			fi
		done
	done
done

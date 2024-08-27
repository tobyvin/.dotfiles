#!/bin/sh

if [ -d "$XDG_DATA_HOME/nvim/session" ]; then
	printf '%s: Moving nvim session directory from %s into %s\n' "$0" "$XDG_STATE_HOME" "$XDG_STATE_HOME"
	mv -Tnv "$XDG_DATA_HOME/nvim/session" "$XDG_STATE_HOME/nvim/session"
fi

if [ -d "$HOME"/src ]; then
	printf '%s: Moving ~/src directory into ~/.local/src\n' "$0"
	mv -Tnv "$HOME/src" "$HOME/.local/src"

	for state_dir in undo session; do
		printf '%s: Migrating nvim %s files to match new location\n' "$0" "$state_dir"
		for f in "$XDG_STATE_HOME/nvim/$state_dir/%home%tobyv%src%"*; do
			if [ -e "$f" ]; then
				sed -i 's|~/src/|~/.local/src|g' "$f"
				printf '%s\n' "$f" | sed "s|/%home%tobyv%src%|/%home%tobyv%.local%src%|" | xargs mv -Tnv "$f"
			fi
		done
	done
fi

if [ -d "$XDG_DATA_HOME/mail/gmail" ]; then
	mkdir -vp "$XDG_DATA_HOME/mail/gmail.com"
	mv -Tnv "$XDG_DATA_HOME/mail/gmail" "$XDG_DATA_HOME/mail/gmail.com/tobyv13"
fi

if [ -d "$XDG_DATA_HOME/mail/porkbun" ]; then
	printf 'Found unused porkbun directory: /home/tobyv/.local/share/mail/tobyvin.dev/tobyv\n'
fi

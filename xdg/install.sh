#!/bin/sh

for dir in src pkg; do
	if [ -d "$HOME"/$dir ] && [ ! -L "$HOME"/$dir ]; then
		printf '%s: Moving ~/%s directory into ~/.local\n' "$0" $dir
		mv -Tnv "$HOME"/src "$HOME"/.local/src
		ln -s "$HOME"/.local/src "$HOME"/src
	fi
done

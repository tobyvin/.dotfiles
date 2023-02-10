#!/bin/sh

if command -v ruby >/dev/null && command -v gem >/dev/null; then
	GEM_USER_DIR="$(ruby -r rubygems -e 'puts Gem.user_dir')"
	export PATH="$PATH:$GEM_USER_DIR"
fi

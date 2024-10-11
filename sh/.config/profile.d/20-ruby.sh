#!/bin/sh

if command -v ruby >/dev/null && command -v gem >/dev/null; then
	GEM_USER_DIR="$(ruby -r rubygems -e 'puts Gem.user_dir')"
	[ -d "$GEM_USER_DIR"/bin ] && prepend_path "$GEM_USER_DIR"/bin
	export PATH
fi

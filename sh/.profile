#!/bin/sh
# shellcheck disable=2046

export $(run-parts /usr/lib/systemd/user-environment-generators | xargs)

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u "$USER")}"

export BROWSER="xdg-open"

export PATH="$PATH:$HOME/.local/bin"

for script in "$XDG_CONFIG_HOME"/profile.d/*.sh; do
	if [ -r "$script" ]; then
		# shellcheck disable=1090
		. "$script"
	fi
done

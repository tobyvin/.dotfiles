#!/bin/sh
# shellcheck disable=2046

export $(run-parts /usr/lib/systemd/user-environment-generators | xargs)

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u "$USER")}"

export PATH="$PATH:$HOME/.local/bin"

# Adopt the behavior of the system wide configuration for application specific settings
#
# See: https://wiki.archlinux.org/title/Command-line_shell#/etc/profile
for script in "$XDG_CONFIG_HOME"/profile.d/*.sh; do
	if [ -r "$script" ]; then
		# shellcheck disable=1090
		. "$script"
	fi
done

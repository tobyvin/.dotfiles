#!/bin/sh
# shellcheck disable=2046

# use systemd-environment-d-generator(8) to generate environment, and export those variables
#
# See: https://wiki.archlinux.org/title/Environment_variables#Per_Wayland_session
for gen in /usr/lib/systemd/user-environment-generators/*; do
	if [ -e "$gen" ]; then
		export $($gen | xargs)
	fi
done

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u "$USER")}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"

if [ -e "$HOME/.config/user-dirs.dirs" ]; then
	export $(xargs <"$HOME/.config/user-dirs.dirs")
fi

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

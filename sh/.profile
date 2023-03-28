#!/bin/sh
# shellcheck disable=2046

# Use systemd-environment-d-generator(8) to generate environment, and export those variables
#
# See: https://wiki.archlinux.org/title/Environment_variables#Per_Wayland_session
for gen in /usr/lib/systemd/user-environment-generators/*; do
	if [ -e "$gen" ]; then
		export $($gen | xargs)
	fi
done

# Manually parse and export XDG user directories. xdg-user-dirs-update is disabled in
# $XDG_CONFIG_HOME/user-dirs.conf due to how it handles non-existant directories
#
# See: https://wiki.archlinux.org/title/XDG_user_directories
if [ -e "$HOME/.config/user-dirs.dirs" ]; then
	export $(xargs <"$HOME/.config/user-dirs.dirs")
fi

# Adopt the behavior of the system wide configuration for application specific settings
#
# See: https://wiki.archlinux.org/title/Command-line_shell#/etc/profile
for script in "$XDG_CONFIG_HOME"/profile.d/*.sh; do
	if [ -r "$script" ]; then
		# shellcheck disable=1090
		. "$script"
	fi
done

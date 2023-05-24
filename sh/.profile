#!/bin/sh
# shellcheck disable=2046,1090

# Most of this script is a user scoped version of /etc/profile

# Append "$1" to $PATH when not already in.
# This function API is accessible to scripts in $XDG_CONFIG_HOME/profile.d
append_path() {
	case ":$PATH:" in
	*:"$1":*) ;;
	*)
		PATH="${PATH:+$PATH:}$1"
		;;
	esac
}

# Use systemd-environment-d-generator(8) to generate environment, and export those variables
# NOTE: To avoid overriding PATH, we rename it and append it separately
#
# See: https://wiki.archlinux.org/title/Environment_variables#Per_Wayland_session
for gen in /usr/lib/systemd/user-environment-generators/*; do
	if [ -e "$gen" ]; then
		export $($gen | sed 's/^PATH=/GEN_PATH=/' | xargs)
		append_path "$GEN_PATH"
		unset GEN_PATH
	fi
done

append_path "$HOME/.local/bin"

# Force PATH to be environment
export PATH

# Load profiles from $XDG_CONFIG_HOME/profile.d
if test -d "$XDG_CONFIG_HOME"/profile.d/; then
	for profile in "$XDG_CONFIG_HOME"/profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi

# Unload our profile API functions
unset -f append_path

# Manually parse and export XDG user directories. xdg-user-dirs-update is disabled in
# $XDG_CONFIG_HOME/user-dirs.conf due to how it handles non-existent directories
#
# See: https://wiki.archlinux.org/title/XDG_user_directories
if [ -e "$HOME/.config/user-dirs.dirs" ]; then
	export $(xargs <"$HOME/.config/user-dirs.dirs")
fi

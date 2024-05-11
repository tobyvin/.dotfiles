#!/bin/sh
# shellcheck disable=1090,2046

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

# Store original (system) paths to fix prioritization later
_path=$PATH

# Use systemd-environment-d-generator(8) to generate environment, and export those variables
#
# See: https://wiki.archlinux.org/title/Environment_variables#Per_Wayland_session
for generator in /usr/lib/systemd/user-environment-generators/*; do
	export $($generator | xargs)
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

# Fix PATH to prioritize user added paths
if [ -e "$_path" ]; then
	PATH="${PATH#"$_path"}:$_path"
	export PATH
fi

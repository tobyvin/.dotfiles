#!/bin/sh

SCRIPT="$(basename "$0")"
SCRIPT_DIR="$(dirname -- "$(readlink -f -- "$0")")"
INSTALL_DIR="$(dirname "$SCRIPT_DIR")"

long='clean-only,help'
short='ch'

if ! opts="$(getopt -o $short -l $long -n "$SCRIPT" -- "$@")"; then
	exit 1
fi

eval set -- "$opts"

help() {
	cat <<-EOF
		$SCRIPT
		Toby Vincent <tobyv@tobyvin.dev>

		$SCRIPT
		    Installer script that is a simple wrapper around GNU stow that removes broken symlinks
		    found in $INSTALL_DIR, stows all packages, and runs all ./*/install.sh scripts.

		USAGE:
		    $SCRIPT [OPTION ...]

		OPTIONS:
		    -h, --help            Show this help.
	EOF
}

clean_only=false
while true; do
	case "$1" in
	-h | --help)
		help
		exit 0
		;;
	-c | --clean-only)
		clean_only=true
		shift
		;;
	--)
		shift
		break
		;;
	*)
		exit 1
		;;
	esac
done

find . -type l -exec sh -c 'for x; do [ -e "$x" ] || rm -v "$x"; done' _ {} +

if $clean_only; then
	exit 0
fi

stow "$@" -- */

for f in "$SCRIPT_DIR"/*/install.sh; do
	$f
done

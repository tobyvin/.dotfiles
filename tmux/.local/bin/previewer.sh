#!/bin/sh
# shellcheck disable=2046

SCRIPT="$(basename "$0")"

long='remote,verbose,help'
short='rvh'

if ! opts="$(getopt -o $short -l $long -n "$SCRIPT" -- "$@")"; then
	exit 1
fi

eval set -- "$opts"

help() {
	cat <<-EOF
		$SCRIPT
		Toby Vincent <tobyv13@gmail.com>

		$SCRIPT
		    Shows preview of a directory. Designed to be used with fzf's '--preview'.

		USAGE:
		    $SCRIPT [OPTION ...] <PATH> [PATH ...]

		OPTIONS:
		    -r, --remote          Treat path as a remote repository
		    -v, --verbose         Increase verbosity
		    -h, --help            Show this help
	EOF
}

say() {
	printf "%s: %s\n" "$SCRIPT" "$@"
}

say_verbose() {
	if [ "$verbose" -gt "0" ]; then
		say "$@"
	fi
}

say_err() {
	say "$@" >&2
}

err() {
	err_dir="$1"
	shift
	say_err "cannot preview '$err_dir': $*"
	exit 1
}

err_help() {
	help
	err "$*"
}

verbose=0
remote=false
width=$(((($(tput cols) * 3) + (4 - 1)) / 4))
while true; do
	case "$1" in
	-h | --help)
		help
		exit 0
		;;
	-v | --verbose)
		verbose=$((verbose + 1))
		shift
		;;
	-r | --remote)
		remote=true
		shift
		;;
	-w | --width)
		width=$2
		shift 2
		;;
	--)
		shift
		break
		;;
	*)
		err_help "Invalid argument: $1"
		;;
	esac
done

show_logo="always"
if [ "$width" -lt 80 ]; then
	show_logo="never"
fi

if [ "$#" -eq 0 ]; then
	IFS='
'
	set -o noglob
	set -- $(cat)
fi

while [ $# -gt 0 ]; do
	if $remote; then
		hut git show --repo "$1" 2>/dev/null ||
			gh repo view "$1" 2>/dev/null ||
			err "$1" "Failed to find remote repository"
	else
		onefetch --hidden --show-logo="$show_logo" "$1" 2>/dev/null ||
			([ -e "$1"/README.md ] && glow --local --style=dark "$1"/README.md) 2>/dev/null ||
			exa --tree --git-ignore --level=3 --icons "$1" 2>/dev/null ||
			err "$1" "Failed to preview directory"
	fi
	shift
done

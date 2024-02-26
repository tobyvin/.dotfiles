#!/bin/sh
# shellcheck disable=2046

SCRIPT="$(basename "$0")"

long='type:,git,sessions::,format:,verbose,help'
short='t:gs::f:vh'

if ! opts="$(getopt -o $short -l $long -n "$SCRIPT" -- "$@")"; then
	exit 1
fi

eval set -- "$opts"

help() {
	cat <<-EOF
		$SCRIPT
		Toby Vincent <tobyv@tobyvin.dev>

		$SCRIPT
		    Get a timestamp for a given directory using multiple activity sources. By default, uses stat.

		USAGE:
		    $SCRIPT [OPTION ...] <PATH> [PATH ...]

		OPTIONS:
		    -t, --type=<file|ssh>   Specify type of input
		    -g, --git               Check last git commit for timestamp
		    -s, --sessions=[PATH]   Check nvim sessions directory for existing session files.
		                                (DEFAULT="$XDG_DATA_HOME/nvim/sessions")

		    -f, --format=<FORMAT>   Format string for output. '{}' will be replaced directory
		                                timestamp and '{1}' will be replaced directory path

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
	say_err "cannot timestamp '$err_dir': $*"
	exit 1
}
err_help() {
	help
	err "$*"
}

verbose=0
type=''
git=false
sessions=false
sessions_dir="$XDG_DATA_HOME/nvim/sessions"
histfile="${HISTFILE:-$XDG_STATE_HOME/zsh/history}"
format="{}"
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
	-t | --type)
		case "$2" in
		s*) type="ssh" ;;
		f*) type="file" ;;
		d*) type="directory" ;;
		*) type="$2" ;;
		esac
		shift 2
		;;
	-e | --git)
		git=true
		shift
		;;
	-s | --sessions)
		sessions=true
		if [ -n "$2" ]; then
			sessions_dir="$2"
		fi
		shift 2
		;;
	-f | --format)
		format="$2"
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

if [ "$#" -eq 0 ]; then
	IFS='
'
	set -o noglob
	set -- $(cat)
fi

while [ $# -gt 0 ]; do
	ts_max="0"
	case "$type" in
	ssh)
		if ts=$(grep -P "^: \d+:\d;ssh.* $1" "$histfile" | tail -1 | cut -d: -f2 | sed 's/^\s*//'); then
			say_verbose "ssh '$1': $ts"
			if [ -n "$ts" ] && [ "$ts" -gt "$ts_max" ]; then
				ts_max=$ts
			fi
		fi
		;;
	file | directory)
		if [ ! -d "$1" ]; then
			say_err "$1" "No such file or directory"
			shift
			continue
		fi

		if ts=$(stat -c "%Y" "$1"); then
			say_verbose "stat '$1': $ts"
			if [ "$ts" -gt "$ts_max" ]; then
				ts_max=$ts
			fi
		fi

		if $git && ts=$(git -C "$1" --no-pager log -1 --all --format="%at" 2>/dev/null); then
			say_verbose "git '$1': $ts"
			if [ "$ts" -gt "$ts_max" ]; then
				ts_max=$ts
			fi
		fi

		pattern=$(printf %s\\n "$1" | sed 's|/|.{1,2}|g')
		if $sessions && ts=$(fd "$pattern" "$sessions_dir" -1 --type=f --max-depth=1 -x stat -c "%Y" {} 2>/dev/null); then
			say_verbose "session '$1': $ts"
			if [ "$ts" -gt "$ts_max" ]; then
				ts_max=$ts
			fi
		fi
		;;
	esac

	printf %s\\n "$format" | sed "s|{}|$ts_max|g" | sed "s|{1}|$1|g"
	shift
done

#!/bin/sh

SCRIPT="$(basename "$0")"
SCRIPT_DIR="$(dirname -- "$(readlink -f -- "$0")")"
INSTALL_DIR="$(dirname "$SCRIPT_DIR")"

long='clean,no,simulate,verbose::,quiet,help'
short='cnqvh'

opts="$(getopt -o $short -l $long -n "$SCRIPT" -- "$@")"

# shellcheck disable=2181
if [ $? != 0 ]; then
	exit 1
fi

eval set -- "$opts"

help() {
	cat <<-EOF
		$SCRIPT
		Toby Vincent <tobyv13@gmail.com>

		$SCRIPT
		    Installer script

		USAGE:
		    $SCRIPT [OPTION ...] [PACKAGE ...]

		OPTIONS:
		    -c, --clean           Remove broken symlinks found in $INSTALL_DIR
		    -n, --no, --simulate  Do not actually make any filesystem changes
		    -q, --quiet           Suppress all output
		    -v, --verbose[=N]     Increase verbosity (levels are from 0 to 5;
		                              -v or --verbose adds 1; --verbose=N sets level)
		    -h, --help            Show this help
	EOF
}

say() {
	if ! $quiet; then
		printf "%s: %s\n" "$SCRIPT" "$@"
	fi
}

say_verbose() {
	if [ "$verbose" -gt 0 ]; then
		say "$@"
	fi
}

say_err() {
	say "$@" >&2
}

err() {
	say_err "ERROR: $*"
	exit 1
}

err_help() {
	help
	err "$*"
}

need() {
	for need_cmd in "$@"; do
		if ! command -v "$need_cmd" >/dev/null 2>&1; then
			err "need $need_cmd (command not found)"
		fi
	done
}

verbose=0
quiet=false
simulate=false
clean=false
stow_cmd="stow"
while true; do
	case "$1" in
	-h | --help)
		help
		exit 0
		;;
	-v)
		verbose=$((verbose + 1))
		stow_cmd="$stow_cmd $1"
		shift
		;;
	--verbose)
		if [ -n "$2" ]; then
			say "$1 = $2"
			verbose=$2
			stow_cmd="$stow_cmd $1=$2"
			shift 2
		else
			verbose=$((verbose + 1))
			stow_cmd="$stow_cmd $1"
			shift
		fi
		;;
	-q | --quiet)
		quiet=true
		shift
		;;
	-c | --clean)
		clean=true
		shift
		;;
	-n | --no | --simulate)
		simulate=true
		stow_cmd="$stow_cmd $1"
		shift
		;;
	--)
		shift
		stow_cmd="$stow_cmd --stow"
		break
		;;
	*)
		exit 1
		break
		;;
	esac
done

if "$clean"; then
	need fd

	if "$simulate"; then
		clean_cmd="[ -e '{}' ] || echo 'rm -v {}'"
	else
		clean_cmd="[ -e '{}' ] || rm -v {}"
	fi

	fd . "$HOME" --hidden --type l \
		--exclude "$(realpath --relative-base="$INSTALL_DIR" "$XDG_CACHE_HOME")" \
		--exclude "$(realpath --relative-base="$INSTALL_DIR" "$SCRIPT_DIR")" \
		--exec sh -c "$clean_cmd"
fi

if [ $# -eq 0 ]; then
	pkgs=""
	for pkg in "$SCRIPT_DIR"/*; do
		if [ -d "$pkg" ]; then
			pkg_name="$(basename "$pkg")"

			case "$pkg_name" in
			wsl)
				if [ -n "${WSL_DISTRO_NAME+1}" ]; then
					pkgs="$pkgs $pkg_name"
				else
					say_verbose "Skipping $pkg_name"
				fi
				;;
			*)
				pkgs="$pkgs $pkg_name"
				;;
			esac
		fi
	done

	set -- "${pkgs## }"
fi

say "$stow_cmd $*"

# shellcheck disable=2068
$stow_cmd $@

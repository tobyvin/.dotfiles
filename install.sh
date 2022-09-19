#!/bin/sh

SCRIPT="$(basename "$0")"
SCRIPT_DIR="$(dirname -- "$(readlink -f -- "$0")")"
INSTALL_DIR="$(dirname "$SCRIPT_DIR")"

long='clean,clean-only,no,simulate,verbose,help'
short='cCnvh'

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
		    -c, --clean           Remove broken symlinks found in $INSTALL_DIR for proceeding
		    -C, --clean-only      Like --clean, but will exit after cleaning
		    -n, --no, --simulate  Do not actually make any filesystem changes
		    -v, --verbose         Increase verbosity
		    -h, --help            Show this help
	EOF
}

say() {
	printf "%s: %s\n" "$SCRIPT" "$@"
}

say_verbose() {
	# shellcheck disable=2086
	if [ $verbose -gt 0 ]; then
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

clean=false
clean_only=false
verbose=0
simulate=""
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
	-c | --clean)
		clean=true
		shift
		;;
	-C | --clean-only)
		clean=true
		clean_only=true
		shift
		;;

	-n | --no | --simulate)
		simulate='-n'
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

verbose_args="$(head -c $verbose </dev/zero | tr '\0' 'v' | sed 's/^/-/')"

if $clean; then
	need fd
	fd_verbose=$(printf %s\\n "$verbose_args" | sed 's/-vv\?//' | sed 's/^v/-v/')

	# shellcheck disable=2086
	fd . "$HOME" --hidden --type l \
		--exclude "$(realpath --relative-base="$INSTALL_DIR" "$XDG_CACHE_HOME")" \
		--exclude "$(realpath --relative-base="$INSTALL_DIR" "$SCRIPT_DIR")" \
		--exec sh $simulate $fd_verbose -c "[ -e '{}' ] || rm -v {}"

	if $clean_only; then
		exit 0
	fi
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

say_verbose "Installing: $*"

# shellcheck disable=2068,2086
stow $verbose_args $simulate $@

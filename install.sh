#!/bin/sh
# shellcheck source-path=SCRIPTDIR

SCRIPT="$(basename "$0")"
SCRIPT_DIR="$(dirname -- "$(readlink -f -- "$0")")"
INSTALL_DIR="$(dirname "$SCRIPT_DIR")"

long='install,clean,clean-only,no,simulate,verbose,help'
short='icCnvh'

opts="$(getopt -o $short -l $long -n "$SCRIPT" -- "$@")"

# shellcheck disable=2181
if [ $? != 0 ]; then
	exit 1
fi

eval set -- "$opts"

help() {
	cat <<-EOF
		$SCRIPT
		Toby Vincent <tobyv@tobyvin.dev>

		$SCRIPT
		    Installer script. Basically just a wrapper around GNU stow with a few niceties. Running with
		        no arguments and no '--clean-only' flag with stow all packages, with the exception of
		        platform specific packages, e.g. 'wsl'.

		USAGE:
		    $SCRIPT [OPTION ...] [PACKAGE ...]

		OPTIONS:
		    -i, --install         After stowing, run any '<PKG>/install.sh' in packages.
		    -c, --clean           Remove broken symlinks found in $INSTALL_DIR for proceeding.
		    -C, --clean-only      Like --clean, but will exit after cleaning.
		    -n, --no, --simulate  Do not actually make any filesystem changes.
		    -v, --verbose         Increase verbosity.
		    -h, --help            Show this help.
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
install=false
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
	-i | --install)
		install=true
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

	# shellcheck disable=2086,2016
	fd . "$HOME" --hidden --type l --exclude \.dotfiles/** --exec sh $simulate $fd_verbose -c \
		'[ -e "{}" ] || (l=$(readlink -m "{}"); [ "${l#'"$SCRIPT_DIR"'}" == "$l" ] || rm -v "{}")'

	if $clean_only; then
		exit 0
	fi
fi

if [ $# -eq 0 ]; then
	for pkg_path in "$SCRIPT_DIR"/*; do
		if [ -d "$pkg_path" ]; then
			pkg="$(basename "$pkg_path")"

			case "$pkg" in
			wsl)
				if [ -n "${WSL_DISTRO_NAME+1}" ]; then
					set -- "$@" "$pkg"
				fi
				;;
			*)
				set -- "$@" "$pkg"
				;;
			esac
		fi
	done
fi

say_verbose "Installing: $*"

# shellcheck disable=2068,2086
stow $verbose_args $simulate "$@"

if $install; then
	for pkg; do
		if [ -e "$SCRIPT_DIR/$pkg/install.sh" ]; then
			if [ -z "$simulate" ]; then
				"$SCRIPT_DIR/$pkg/install.sh"
			else
				echo "simulated: $SCRIPT_DIR/$pkg/install.sh"
			fi
		fi
	done
fi

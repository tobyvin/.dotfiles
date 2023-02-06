#!/usr/bin/env bash

SCRIPT="$(basename "$0")"

long='help,verbose,quiet,force,dry-run'
short='hvqfn'

eval set -- "$(getopt -o $short -l $long -n "$SCRIPT" -- "$@")"

help() {
	cat <<-EOF
		$SCRIPT
		Toby Vincent <tobyv13@gmail.com>

		$SCRIPT
		    Creates symbolic links (for files) or junctions (for directories) from the
		    windows filesystem to the WSL2 instance using mklink.exe.

		USAGE:
		    $SCRIPT [OPTIONS] <SOURCE> [TARGET]

		OPTIONS:
		    -h, --help      Show this message
		    -v, --verbose   Show more output
		    -q, --quiet     Suppress all output
		    -f, --force     Overwrite items
		    -n, --dry-run   Write output of commands with running them.

		ARGS:
		    SOURCE (required)
		        Path to the source file or directory the link should point to.

		    TARGET (optional)
		        Path to the location to create the link. [Default: $PWD]
	EOF
}

say() {
	if ! $quiet; then
		printf "%s: %s\n" "$SCRIPT" "$@"
	fi
}

say_verbose() {
	if $verbose; then
		say "$@"
	fi
}

say_err() {
	say "$@" >&2
}

err() {
	# shellcheck disable=SC2145
	say_err "ERROR: $@"
	exit 1
}

err_help() {
	help
	err "$*"
}

need() {
	for cmd in "$@"; do
		if ! command -v "$cmd" >/dev/null 2>&1; then
			err "need $cmd (command not found)"
		fi
	done
}

trg=$PWD
verbose=false
quiet=false
force=false
while true; do
	case "$1" in
	-h | --help)
		help
		exit 0
		;;
	-v | --verbose)
		verbose=true
		shift
		;;
	-q | --quiet)
		quiet=true
		shift
		;;
	-f | --force)
		force=true
		shift
		;;
	--)
		shift
		break
		;;
	*)
		break
		;;
	esac
done

need powershell.exe
need realpath

case "$#" in
0) err_help "must provide at least 1 argument" ;;
1)
	src="$1"
	trg="$PWD"
	shift
	;;
2)
	src="$1"
	trg="$2"
	shift 2
	;;
*) err_help "too many arguments" ;;
esac

while test -L "$src"; do
	tmp="$src"
	src=$(realpath "$src")
	say_verbose "resolved symbolic link $tmp -> $src"
done

if ! test -e "$src"; then
	err "$src does not exist."
fi

if test -d "$src"; then
	say_verbose "$src is a directory. Switching to directory symbolic link."
	args='/D'
fi

trg_name=$(basename "$trg")
trg_dir=$(dirname "$trg")

say_verbose "linking $src -> $trg"

if ! test -d "$trg_dir"; then
	mkdir -p "$trg_dir"
	say_verbose "created directory $trg_dir"
fi

win_src=$(wslpath -w "$src")
win_trg=$(wslpath -w "$trg_dir")\\"$trg_name"

# UNC\wsl$\Arch\home\tobyv\.dotfiles\alacritty\.config\alacritty\alacritty.yml
# \\wsl.localhost\Arch\home\tobyv\.dotfiles\alacritty\.config\alacritty\alacritty.yml

existing="$(powershell.exe "(Get-Item $win_trg).FullName" 2>/dev/null)"

if test "$existing" != ''; then
	if $force; then
		say_verbose "$win_trg already exists. Overwriting."
		rm -rf "$trg"
	else
		err "$win_trg already exists."
	fi
fi

powershell.exe "cd ~; cmd /c mklink $args $win_trg $win_src"

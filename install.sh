#!/bin/sh

set -e

CDPATH='' cd -- "$(dirname -- "$0")" || exit
TARGET=${TARGET:-$HOME}

if [ -r .installed ]; then
	read -r DOTFILES_INSTALLED <.installed
	export DOTFILES_INSTALLED
fi

printf "%s: Stowing packages\n" "$0"
# shellcheck disable=SC2086
stow -R "$@" ${1:-*}/ 2>&1 | awk '
	/^UNLINK:/ { stdout[$0] = 1; next }
	/\(reverts previous action\)$/ { delete stdout["UNLINK: " $2]; next }
	/^LINK:/ { stdout[$0] = 1; next }
	{ stderr[NR] = $0 }
	END {
		for (out in stdout) { print out };
		for (err in stderr) { print stderr[err] > "/dev/stderr" }
		if ( length(stderr) > 0 ) { exit 1 }
	}
'

printf "%s: Installing packages\n" "$0"
for f in ${1:-*}/install.sh; do
	$f
done

git rev-parse ^@ >.installed

#!/bin/sh

set -e

CDPATH='' cd -- "$(dirname -- "$0")" || exit
TARGET=${TARGET:-$HOME}

if [ -r .installed ]; then
	read -r DOTFILES_INSTALLED <.installed
else
	DOTFILES_INSTALLED=$(git rev-list --abbrev --max-parents=0 HEAD)
fi

export DOTFILES_INSTALLED

printf "%s: Stowing packages\n" "$0"
# shellcheck disable=SC2086
stow -R "$@" ${1:-*}/ 2>&1 | awk '
	/^UNLINK:/ { stdout[NR] = $0; unlinked[$2] = NR; next }
	/\(reverts previous action\)$/ { delete stdout[unlinked[$2]]; next }
	/^LINK:/ { stdout[NR] = $0; next }
	{ stderr[NR] = $0 }
	END {
		for (out in stdout) { print stdout[out] };
		for (err in stderr) { print stderr[err] > "/dev/stderr" }
		if ( length(stderr) > 0 ) { exit 1 }
	}
'

printf "%s: Installing packages\n" "$0"
for f in ${1:-*}/install.sh; do
	if [ -e "$f" ]; then
		$f
	fi
done

git rev-parse ^@ >.installed

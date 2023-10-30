#!/bin/sh
# shellcheck disable=SC2035,SC2016

set -e

CDPATH='' cd -- "$(dirname -- "$0")" || exit

printf "%s: Removing bad links\n" "$0"
{
	git log --pretty=format: --name-only --no-renames --diff-filter=D
	git status --porcelain --no-renames | grep -oP '^\s*\w*[DR?]+\w*\s*\K(.*)'
} | sort -u | sed -n 's/^[^/]\+\//..\//p' | while read -r f; do
	if [ -L "$f" ] && [ ! -e "$f" ]; then
		rm -v "$f"
	fi
done

printf "%s: Stowing packages\n" "$0"
stow "$@" */

for f in */install.sh; do
	$f
done

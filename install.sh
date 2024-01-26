#!/bin/sh
# shellcheck disable=SC2035

set -e

CDPATH='' cd -- "$(dirname -- "$0")" || exit

printf "%s: Removing bad links\n" "$0"
{
	git log --name-only --no-renames --diff-filter=D --format=format:
	git diff --name-only --no-renames --diff-filter=D HEAD
	if [ -f .untracked ]; then
		cat .untracked
	fi
} | sort -u | sed -n 's/^[^/]\+\//..\//p' | while read -r f; do
	if [ -L "$f" ] && [ ! -e "$f" ]; then
		rm -v "$f"
	fi
done

git ls-files --exclude-standard --others >.untracked
if [ ! -s .untracked ]; then
	rm -f .untracked
fi

printf "%s: Stowing packages\n" "$0"
stow "$@" */

printf "%s: Installing packages\n" "$0"
for f in */install.sh; do
	$f
done

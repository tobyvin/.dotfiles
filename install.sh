#!/bin/sh

set -e

CDPATH='' cd -- "$(dirname -- "$0")" || exit
TARGET=${TARGET:-$HOME}

if [ -r .installed ]; then
	read -r DOTFILES_INSTALLED <.installed
	export DOTFILES_INSTALLED
fi

printf "%s: Removing bad links\n" "$0"
{
	git log --name-only --no-renames --diff-filter=D --format=format: "$DOTFILES_INSTALLED" HEAD
	git diff --name-only --no-renames --diff-filter=D HEAD
	cat .untracked 2>/dev/null
} | sort -u | while read -r f; do
	if [ -L "$TARGET/${f#*/}" ] && [ ! -e "$TARGET/${f#*/}" ]; then
		rm -v "$TARGET/${f#*/}"
	fi
done

git ls-files --exclude-standard --others >.untracked
if [ ! -s .untracked ]; then
	rm -f .untracked
fi

printf "%s: Stowing packages\n" "$0"
# shellcheck disable=SC2086
stow "$@" ${1:-*}/

printf "%s: Installing packages\n" "$0"
for f in ${1:-*}/install.sh; do
	$f
done

git rev-parse ^@ >.installed

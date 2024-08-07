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
stow -R "$@" ${1:-*}/ 2>&1 | tac | awk '
	/\(reverts previous action\)$/ { reverted[$2] = 1; next }
	/^LINK:/ { print $0 }
	/^UNLINK:/ { if (!reverted[$2]) { print $0 } }
' | tac

printf "%s: Installing packages\n" "$0"
for f in ${1:-*}/install.sh; do
	$f
done

git rev-parse ^@ >.installed

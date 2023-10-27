#!/bin/sh
# shellcheck disable=SC2035,SC2016

set -e

CDPATH='' cd -- "$(dirname -- "$0")" || exit

printf "%s: Removing bad links\n" "$0"
(
	git diff-tree --no-commit-id --name-status e6051a3..HEAD -r
	git diff --no-commit-id --name-status -r
	git diff --no-commit-id --name-status -r --staged
) |
	grep -oP 'D\t[^/]+/\K(.*)' |
	while read -r f; do
		if [ -L "../$f" ] && [ ! -e "../$f" ]; then
			rm -v "../$f"
		fi
	done

printf "%s: Stowing packages\n" "$0"
stow "$@" */

for f in */install.sh; do
	$f
done

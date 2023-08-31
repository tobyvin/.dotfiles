#!/bin/sh
# shellcheck disable=SC2035

CDPATH='' cd -- "$(dirname -- "$0")" || exit

printf "%s: Removing bad links\n" "$0"
chkstow -t .. -b | cut -c13- | xargs -r rm -v

printf "%s: Stowing packages\n" "$0"
stow "$@" */

for f in */install.sh; do
	$f
done

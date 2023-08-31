#!/bin/sh
# shellcheck disable=SC2035,SC2016

CDPATH='' cd -- "$(dirname -- "$0")" || exit

printf "%s: Removing bad links\n" "$0"
fd . .. -Htl -E ./**/ -x sh -c '[ -e "{}" ] || (readlink -m "{}" | grep '"$PWD"' -q && rm -v "{}")'

printf "%s: Stowing packages\n" "$0"
stow "$@" */

for f in */install.sh; do
	$f
done

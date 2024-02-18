#!/bin/sh

pkgname=pass

if ! command -v "$pkgname" >/dev/null; then
	printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
	exit 0
fi

store=${PASSWORD_STORE_DIR:-$XDG_DATA_HOME/pass}

if [ ! -d "$store" ]; then
	printf "%s: Cloning password-store\n" "$0"

	git clone git@git.sr.ht:~tobyvin/.password-store "$store"
else
	printf "%s: Syncing password-store\n" "$0"

	git -C "$store" remote update origin

	LOCAL=$(git -C "$store" rev-parse @)
	REMOTE=$(git -C "$store" rev-parse '@{u}')
	BASE=$(git -C "$store" merge-base @ '@{u}')

	if [ "$BASE" != "$REMOTE" ]; then
		git -C "$store" pull
	fi

	if [ "$BASE" != "$LOCAL" ]; then
		git -C "$store" push
	fi
fi

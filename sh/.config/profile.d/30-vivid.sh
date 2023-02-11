#!/bin/sh

if [ -n "$BASE16_DEFAULT_THEME" ] && command -v vivid 1>/dev/null; then
	LS_COLORS="$(vivid generate "$BASE16_DEFAULT_THEME" 2>/dev/null)"
	export LS_COLORS
fi

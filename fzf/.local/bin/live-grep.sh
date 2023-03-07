#!/bin/sh

need() {
	for need_cmd in "$@"; do
		if ! command -v "$need_cmd" >/dev/null 2>&1; then
			printf "live-grep: command not found: %s\n" "$need_cmd" >&2
			exit 1
		fi
	done
}

need "rg" "bat"

INITIAL_QUERY="${*:-}"
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
PREVIEW_CMD='bat --color=always {1} --highlight-line {2} 2>/dev/null || bat --color=always {}'
INITIAL_CMD="$RG_PREFIX --files"

if [ $# -gt 0 ]; then
	INITIAL_CMD="$RG_PREFIX '$INITIAL_QUERY'"
fi

# shellcheck disable=2046
set -- $(
	FZF_DEFAULT_COMMAND="$INITIAL_CMD" fzf \
		--ansi --color="hl:-1:underline,hl+:-1:underline:reverse" \
		--bind="change:reload:sleep 0.1; [ -n {q} ] && ($RG_PREFIX -- {q} || true) || $RG_PREFIX --files" \
		--disabled --query="$INITIAL_QUERY" --delimiter=":" \
		--preview="cat {1} | rg --passthru -i --color always -- {q}" --preview-window='up,60%,border-bottom,+{2}+3/3,~3'
)

if [ $# -gt 0 ]; then
	xdg-open "$1" "+$2"
fi

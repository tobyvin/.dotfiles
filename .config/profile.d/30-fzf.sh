#!/bin/sh

export FZF_TMUX="${TMUX:+1}"
export FZF_TMUX_OPTS='-p80%,80%'
export FZF_PREVIEW_COMMAND='less {} 2>/dev/null'
export FZF_DEFAULT_COMMAND="fd --type f || git ls-tree -r --name-only HEAD || rg --files || find ."
export FZF_DEFAULT_OPTS='--bind ctrl-q:abort
--bind ctrl-y:preview-up
--bind ctrl-e:preview-down
--bind ctrl-u:preview-half-page-up
--bind ctrl-d:preview-half-page-down
--bind ctrl-b:preview-page-up
--bind ctrl-f:preview-page-down
--bind alt-up:half-page-up
--bind alt-down:half-page-down'

#!/bin/sh

export FZF_PREVIEW_COMMAND='less {} 2>/dev/null'
export FZF_DEFAULT_COMMAND="fd --type f || git ls-tree -r --name-only HEAD || rg --files || find ."
export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME"/fzfrc

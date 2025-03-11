#!/bin/sh

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

prepend_path "$XDG_DATA_HOME"/npm/bin

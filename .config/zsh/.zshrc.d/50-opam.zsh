#!/bin/zsh

if [ -r $OPAMROOT/opam-init/complete.zsh ]; then
	source $OPAMROOT/opam-init/complete.zsh >/dev/null 2>/dev/null
fi

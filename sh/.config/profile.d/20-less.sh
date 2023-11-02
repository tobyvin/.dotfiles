#!/bin/sh

export LESS="-RF --mouse"
export LESSOPEN="|lesspipe.sh %s"
export LESSHISTFILE="$XDG_STATE_HOME/lesshst"

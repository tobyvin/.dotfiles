#!/bin/sh

export LESS="--RAW-CONTROL-CHARS --quit-if-one-screen --mouse"
export LESSOPEN="|lesspipe.sh %s"
export LESSHISTFILE="$XDG_STATE_HOME/lesshst"

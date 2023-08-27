#!/bin/sh

SHELDON_PROFILE="$(uname -r 2>/dev/null | rev | cut -d- -f1 | rev)"
export SHELDON_PROFILE

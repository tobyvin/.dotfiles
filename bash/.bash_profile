#!/bin/bash

# shellcheck disable=1090
. ~/.profile

# shellcheck disable=1090
if [[ $- == *i* ]]; then . ~/.bashrc; fi

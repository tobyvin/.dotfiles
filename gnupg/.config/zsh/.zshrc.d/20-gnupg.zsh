#!/bin/zsh
# vim:ft=sh

alias unlock='echo "" | gpg --clearsign 1>/dev/null && ssh localhost -- : 1>/dev/null'

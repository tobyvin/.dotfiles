#!/bin/zsh
# vim:ft=sh

GPG_TTY=$(tty)
export GPG_TTY

alias unlock='echo "" | gpg --clearsign 1>/dev/null && ssh localhost -- : 1>/dev/null'

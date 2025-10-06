#!/bin/zsh

# disable global zshrc, e.g. grml-zsh-config
# as we still want to source the other global startup files, global zprofile is
# sourced explicitly in the user zprofile and global_rcs is reenabled in zshrc.
#
# See: https://wiki.archlinux.org/title/Zsh#Startup/Shutdown_files
unsetopt global_rcs

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

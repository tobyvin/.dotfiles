#!/bin/zsh

# source system zprofile, as we disabled global_rc in zshenv
source /etc/zprofile

# Adopt the behavior of the system wide configuration
#
# See: https://wiki.archlinux.org/title/Zsh#Startup/Shutdown_files
emulate sh -c 'source ~/.profile'

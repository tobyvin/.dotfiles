. ~/.profile

if [[ $- == *i* ]]; then . ~/.bashrc; fi

# If running from tty1 start sway
[ "$(tty)" = "/dev/tty1" ] && exec sway
#!/bin/zsh
# vim:ft=sh

export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line)

# Make comments more visible
# See: https://github.com/zsh-users/zsh-syntax-highlighting/issues/510
typeset -A ZSH_HIGHLIGHT_STYLES
export ZSH_HIGHLIGHT_STYLES[comment]='fg=8'

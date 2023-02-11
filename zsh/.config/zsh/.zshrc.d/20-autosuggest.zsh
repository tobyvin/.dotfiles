#!/bin/zsh
# vim:ft=sh

bindkey '^ ' autosuggest-accept
bindkey -M vicmd '^ ' autosuggest-accept

export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#4f4738"

#!/bin/zsh

fzf-history-widget() {
  local selected
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases noglob nobash_rematch 2> /dev/null

	selected=$(printf '%s\t%s\000' "${(kv)history[@]}" |
		perl -0 -ne 'if (!$seen{(/^\s*[0-9]+\**\t(.*)/s, $1)}++) { s/\n/\n\t/g; print; }' |
		fzf -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort --wrap-sign '\t↳ ' --query=${(qqq)LBUFFER} +m --read0)

  local ret=$?
  if [ -n "$selected" ]; then
    if [[ $(awk '{print $1; exit}' <<< "$selected") =~ ^[1-9][0-9]* ]]; then
      zle vi-fetch-history -n $MATCH
    else
      LBUFFER="$selected"
    fi
  fi
  zle reset-prompt
  return $ret
}

zle     -N            fzf-history-widget
bindkey -M emacs '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget
bindkey -M viins '^R' fzf-history-widget

if [ -n "$BASE16_THEME" ] && [ -n "$BASE16_SHELL_ENABLE_VARS" ]; then
	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
		--color=bg+:#$BASE16_COLOR_01_HEX,bg:#$BASE16_COLOR_00_HEX
		--color=fg:#$BASE16_COLOR_04_HEX,fg+:#$BASE16_COLOR_06_HEX
		--color=hl:#$BASE16_COLOR_0D_HEX,hl+:#$BASE16_COLOR_0D_HEX
		--color=info:#$BASE16_COLOR_0A_HEX,header:#$BASE16_COLOR_0D_HEX
		--color=prompt:#$BASE16_COLOR_0A_HEX,marker:#$BASE16_COLOR_0C_HEX
		--color=pointer:#$BASE16_COLOR_0C_HEX,spinner:#$BASE16_COLOR_0C_HEX"
fi

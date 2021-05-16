#!/usr/bin/env zsh

function set_title() {
  folder=$(sed "s/$USER/~/g" <<<$PWD:t)

  window_title="\033]0;$USER@$HOST: $folder\007"
  echo -ne "$window_title"
}

# make sure we can register hooks
autoload -Uz add-zsh-hook && add-zsh-hook precmd set_title

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Aliases
alias ls='ls --color=tty'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lla='ls -lA'
alias lsa='ls -lah'
alias grep='grep --color'
alias ipa="ip -s -c -h a"
alias untar="tar -zxvf"
alias td=". td.sh"
alias vim=nvim
alias pip=pip3
alias python=python3
alias dexec="docker exec -it"
alias dps="docker ps"
alias dc="docker compose"
alias dce="docker compose exec"
alias dcps="docker compose ps"
alias dcls="docker compose ls"
alias dcdn="docker compose down"
alias dcup="docker compose up"
alias dcupd="docker compose up -d"
alias dcl="docker compose logs"
alias dclf="docker compose logs -f"
alias dct="docker context"
alias dcu="docker context use"

if [ $PS1 && -d "$BASHCOMPDIR" ]; then
  for f in $BASHCOMPDIR/*; do
    source $f
  done
fi

command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

set_win_title() {
  local prefix

  if [ "$USER" != "tobyv" ]; then
    prefix="${USER} in "
  fi

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    prefix="${prefix/in/on}${HOST} in "
  fi

  echo -ne "\033]0;${prefix}${PWD/$HOME/~}\007"
}

starship_precmd_user_func="set_win_title"

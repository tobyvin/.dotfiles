export PATH="${HOME}/.local/bin.win:$PATH"
hash -d w=/mnt/c/Users/$USER
alias cb=clip.exe

function winget() {
  cmd="winget.exe $1"
  shift # past cmd

  while [[ $# -gt 0 ]]
  do
    key="$1"
    case $key in
        -*) # key value pair
        cmd+=" $key '$2'"
        shift # past argument
        shift # past value
        ;;
        *)    # positional paramert
        cmd+=" '$1'" # add it to the list
        shift # past argument
        ;;
    esac
  done
  
  powershell.exe -NoProfile -c "$cmd"
}

function wt() {
  powershell.exe -NoProfile -c "wt.exe $@"
}

function r-copy() {
  if ((REGION_ACTIVE)) then
    zle copy-region-as-kill
    (( ${+aliases[cb]} )) && printf "$CUTBUFFER" | cb
  else
    zle kill-whole-line
  fi
}

function r-cut() {
  if ((REGION_ACTIVE)) then
    zle kill-region
  else
    zle kill-whole-line
  fi
  (( ${+aliases[cb]} )) && printf "$CUTBUFFER" | cb
}

# YubiKey - GPG: https://github.com/benpye/wsl-ssh-pageant
export GPG_AGENT_SOCK=$HOME/.gnupg/S.gpg-agent
ss -a | grep -q $GPG_AGENT_SOCK
if [ $? -ne 0 ]; then
  rm -rf $GPG_AGENT_SOCK
  (setsid nohup socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:"$HOME/.ssh/wsl2-ssh-pageant.exe --gpg S.gpg-agent" >/dev/null 2>&1 &)
fi

path=( $path $HOME/.local/bin $HOME/.dotnet/tools )
hash -d w=/mnt/c/Users/$USER

alias cb=clip.exe
alias wsl=wsl.exe
alias ykman="/mnt/c/Program\ Files/Yubico/YubiKey\ Manager/ykman.exe"

function wt() { powershell.exe -NoProfile -c "wt $@" }

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
        *)    # positional argument
        cmd+=" '$1'" # add it to the list
        shift # past argument
        ;;
    esac
  done
  
  powershell.exe -NoProfile -c "$cmd"
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

# https://github.com/benpye/wsl-ssh-pageant
# https://github.com/drduh/YubiKey-Guide#remote-host-configuration
# https://dev.to/dzerycz/series/11353
# SSH Socket
# Removing Linux SSH socket and replacing it by link to wsl2-ssh-pageant socket
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$ZSH_BASE/ssh/wsl2-ssh-pageant.exe" &>/dev/null &)
fi
# GPG Socket
# Removing Linux GPG Agent socket and replacing it by link to wsl2-ssh-pageant GPG socket
export GPG_AGENT_SOCK=$HOME/.gnupg/S.gpg-agent
ss -a | grep -q $GPG_AGENT_SOCK
if [ $? -ne 0 ]; then
    rm -rf $GPG_AGENT_SOCK
    (setsid nohup socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:"$ZSH_BASE/ssh/wsl2-ssh-pageant.exe --gpg S.gpg-agent" &>/dev/null &)
fi

alias gpgrst=gpg-reset
# Reload
function gpg-reset() {
  gpg-connect-agent.exe KILLAGENT /bye
  rm $HOME/.gnupg/S.gpg-agent*
  rm $HOME/.ssh/agent.sock
  pkill socat
  gpg-connect-agent.exe /bye
  (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"$ZSH_BASE/ssh/wsl2-ssh-pageant.exe" &>/dev/null &)
  (setsid nohup socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:"$ZSH_BASE/ssh/wsl2-ssh-pageant.exe --gpg S.gpg-agent" &>/dev/null &)
}
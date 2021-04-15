path=( $path $HOME/.local/bin $HOME/.dotnet/tools )
hash -d w=/mnt/c/Users/$USER
alias cb=clip.exe
alias wsl=wsl.exe
alias ykman="/mnt/c/Program\ Files/Yubico/YubiKey\ Manager/ykman.exe"
alias gpg-agent-relay=$ZSH_BASE/ssh/gpg-agent-relay.sh

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

# YubiKey - GPG: https://blog.nimamoh.net/yubi-key-gpg-wsl2/
gpg-agent-relay start
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

# export SSH_AUTH_SOCK=/tmp/wincrypt-hv.sock
# ss -lnx | grep -q $SSH_AUTH_SOCK
# if [ $? -ne 0 ]; then
# 	rm -f $SSH_AUTH_SOCK
#   (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork SOCKET-CONNECT:40:0:x0000x33332222x02000000x00000000 >/dev/null 2>&1)
# fi

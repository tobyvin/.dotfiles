#!/usr/bin/env bash
# Inspired by https://blog.nimamoh.net/yubi-key-gpg-wsl2/

# Guide:
# Install GPG on windows & Unix
# Add "enable-putty-support" to gpg-agent.conf
# Download wsl-ssh-pageant and npiperelay and place the executables in "C:\Users\[USER]\AppData\Roaming\" under wsl-ssh-pageant & npiperelay
# https://github.com/benpye/wsl-ssh-pageant/releases/tag/20190513.14
# https://github.com/NZSmartie/npiperelay/releases/tag/v0.1
# Adjust relay() below if you alter those paths
# Place this script in WSL at ~/.local/bin/gpg-agent-relay
# Start it on login by calling it from your .bashrc: "$HOME/.local/bin/gpg-agent-relay start"

GNUPGHOME="$HOME/.gnupg"
PIDFILE="$GNUPGHOME/gpg-agent-relay.pid"

die() {
  # shellcheck disable=SC2059
  printf "$1\n" >&2
  exit 1
}

main() {
  checkdeps socat start-stop-daemon lsof timeout
  case $1 in
  start)
    if ! start-stop-daemon --pidfile "$PIDFILE" --background --notify-await --notify-timeout 5 --make-pidfile --exec "$0" --start -- foreground; then
      # shellcheck disable=SC2016
      die 'Failed to start. Run `gpg-agent-relay foreground` to see output.'
    fi
    ;;
  stop)
    start-stop-daemon --pidfile "$PIDFILE" --remove-pidfile --stop ;;
  status)
    start-stop-daemon --pidfile "$PIDFILE" --status
    local result=$?
    case $result in
      0) printf "gpg-agent-relay is running\n" ;;
      1 | 3) printf "gpg-agent-relay is not running\n" ;;
      4) printf "unable to determine status\n" ;;
    esac
    return $result
    ;;
  foreground)
    relay ;;
  *)
    die "Usage:\n  gpg-agent-relay start\n  gpg-agent-relay stop\n  gpg-agent-relay status\n  gpg-agent-relay foreground" ;;
  esac
}

relay() {
  set -e
  local winhome
  local wslwinhome
  winhome=$(cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null || true)
  wslwinhome="$(wslpath -u "$winhome")"
  local npiperelay="$wslwinhome/AppData/Roaming/npiperelay/npiperelay.exe"
  local wslsshpageant="$wslwinhome/AppData/Roaming/wsl-ssh-pageant/wsl-ssh-pageant-amd64-gui.exe"
  local gpgconnectagent="/mnt/c/Program Files (x86)/GnuPG/bin/gpg-connect-agent.exe"
  local gpgagentsocket="$GNUPGHOME/S.gpg-agent"
  local sshagentsocket="$GNUPGHOME/S.gpg-agent.ssh"
  # backslash escaping in socat EXEC doesn't seem to work very well, use forward slashes instead
  # windows/npiperelay handle that just fine
  local wingpgagentpath="${winhome//\\/\/}/AppData/Roaming/gnupg/S.gpg-agent"

  killsocket "$gpgagentsocket"
  killsocket "$sshagentsocket"

  "$gpgconnectagent" /bye

  "$wslsshpageant" --winssh ssh-pageant 2>/dev/null &
  # shellcheck disable=SC2034
  WSPPID=$!

  socat UNIX-LISTEN:"$gpgagentsocket,unlink-close,fork,umask=177" EXEC:"$npiperelay -ep -ei -s -a '$wingpgagentpath'",nofork &
  GNUPID=$!
  # shellcheck disable=SC2064
  trap "kill -TERM $GNUPID" EXIT

  socat UNIX-LISTEN:"$sshagentsocket,unlink-close,fork,umask=177" EXEC:"$npiperelay /\/\./\pipe/\ssh-pageant" &
  SSHPID=$!

  set +e
  # shellcheck disable=SC2064
  trap "kill -TERM $GNUPID; kill -TERM $SSHPID" EXIT

  systemd-notify --ready 2>/dev/null
  wait $GNUPID $SSHPID
  trap - EXIT
}

killsocket() {
  local socketpath=$1
  if [[ -e $socketpath ]]; then
    local socketpid
    if socketpid=$(lsof +E -taU -- "$socketpath"); then
      timeout .5s tail --pid=$socketpid -f /dev/null &
      local timeoutpid=$!
      kill "$socketpid"
      if ! wait $timeoutpid; then
        die "Timed out waiting for pid $socketpid listening at $socketpath"
      fi
    else
      rm "$socketpath"
    fi
  fi
}

checkdeps() {
  local deps=("$@")
  local dep
  local out
  local ret=0
  for dep in "${deps[@]}"; do
    if ! out=$(type "$dep" 2>&1); then
      printf -- "Dependency %s not found:\n%s\n" "$dep" "$out"
      ret=1
    fi
  done
  return $ret
}

main "$@"
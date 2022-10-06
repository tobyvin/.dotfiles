#!/bin/sh

DOTFILES="${HOME}/.dotfiles"

WINHOME="$(wslpath c:\\Users\\"${USER}")"

echo "Setting up WSL"

# link WINHOME
ln -sfn "$WINHOME" ~/win

# link win binaries
ln -sf "$(wslpath 'C:\Windows\system32\wsl.exe')" ~/.local/bin/wsl.exe
ln -sf "$(wslpath 'C:\Windows\system32\clip.exe')" ~/.local/bin/clip.exe
ln -sf "$(wslpath 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe')" ~/.local/bin/powershell.exe
ln -sf "$(wslpath 'C:\Program Files\PowerShell\7\pwsh.exe')" ~/.local/bin/pwsh.exe

# ssh-config
sed -r 's|(RemoteForward\s+.+\s+)\/home\/tobyv\/\.gnupg\/S\.gpg-agent\.extra|\1127.0.0.1:4321|' "${DOTFILES}"/ssh/.ssh/config |
	sed '/Control/d' >"${WINHOME}/.ssh/config"

# Create windows symlinks to dotfiles
mkln.sh "$@" "$HOME"/.config/git/config "${WINHOME}"/.gitconfig
mkln.sh "$@" "$HOME"/.gnupg/gpg.conf "${WINHOME}"/AppData/Roaming/gnupg/gpg.conf
mkln.sh "$@" "$HOME"/.gnupg/gpg-agent.conf "${WINHOME}"/AppData/Roaming/gnupg/gpg-agent.conf
mkln.sh "$@" "$HOME"/.gnupg/scdaemon.conf "${WINHOME}"/AppData/Roaming/gnupg/scdaemon.conf
mkln.sh "$@" "$HOME"/.config/wezterm/wezterm.lua "${WINHOME}"/.config/wezterm/wezterm.lua
mkln.sh "$@" "$HOME"/.config/alacritty/alacritty.yml "${WINHOME}"/AppData/Roaming/alacritty/alacritty.yml
mkln.sh "$@" "$HOME"/.config/yt-dlp/config "${WINHOME}"/AppData/Roaming/yt-dlp/config
mkln.sh "$@" "$HOME"/.config/mpv/mpv.conf "${WINHOME}"/AppData/Roaming/mpv/mpv.conf
mkln.sh "$@" "$HOME"/.config/mpv/input.conf "${WINHOME}"/AppData/Roaming/mpv/input.conf
mkln.sh "$@" "$HOME"/.config/streamlink/config.twitch "${WINHOME}"/AppData/Roaming/streamlink/config.twitch

for f in "$HOME"/.config/alacritty/*; do
	case "$f" in
	*shell.yml) echo "Skipping $f" ;;
	*) mkln.sh "$@" "$f" "${WINHOME}"/.config/alacritty/"$(basename "$f")" ;;
	esac
done

# https://github.com/wslutilities/wslu
command -v wslview >/dev/null 2>&1 || cat <<-EOF
	    wslu is not installed.
	    wslu (wslview) is needed to open browser windows from linux commands.
	    install instructions: https://github.com/wslutilities/wslu#installation
EOF

echo "WSL has been set up"

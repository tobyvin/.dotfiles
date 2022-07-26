#!/usr/bin/env sh

DOTFILES="${HOME}/.dotfiles"

WINHOME="$(wslpath c:\\Users\\"${USER}")"

echo "Setting up WSL"

# link WINHOME
ln -sfn "$WINHOME" ~/win

# ssh-config
sed -r 's|(RemoteForward\s+.+\s+)\/home\/tobyv\/\.gnupg\/S\.gpg-agent\.extra|\1127.0.0.1:4321|' "${DOTFILES}"/ssh/.ssh/config |
	sed '/Control/d' >"${WINHOME}/.ssh/config"

# Create windows symlinks to dotfiles
mkln.sh "$@" "$HOME"/.gitconfig "${WINHOME}"/.gitconfig
mkln.sh "$@" "$HOME"/.gnupg/gpg.conf "${WINHOME}"/AppData/Roaming/gnupg/gpg.conf
mkln.sh "$@" "$HOME"/.gnupg/gpg-agent.conf "${WINHOME}"/AppData/Roaming/gnupg/gpg-agent.conf
mkln.sh "$@" "$HOME"/.gnupg/scdaemon.conf "${WINHOME}"/AppData/Roaming/gnupg/scdaemon.conf
mkln.sh "$@" "$HOME"/.config/wezterm/wezterm.lua "${WINHOME}"/.config/wezterm/wezterm.lua
mkln.sh "$@" "$HOME"/.config/alacritty/alacritty.yml "${WINHOME}"/AppData/Roaming/alacritty/alacritty.yml
mkln.sh "$@" "$HOME"/.config/yt-dlp/config "${WINHOME}"/AppData/Roaming/yt-dlp/config
mkln.sh "$@" "$HOME"/.config/mpv/mpv.conf "${WINHOME}"/AppData/Roaming/mpv/mpv.conf
mkln.sh "$@" "$HOME"/.config/streamlink/config.twitch "${WINHOME}"/AppData/Roaming/streamlink/config.twitch

for f in "$HOME"/.config/alacritty/*; do
	case "$f" in
	*shell.yml) echo "Skipping $f" ;;
	*) mkln.sh "$@" "$f" "${WINHOME}"/.config/alacritty/"$(basename "$f")" ;;
	esac
done

# install wsl2-ssh-pageant
rm -f "${HOME}"/.ssh/wsl2-ssh-pageant.exe
curl -sL "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe" >"${HOME}"/.ssh/wsl2-ssh-pageant.exe
chmod +x "${HOME}"/.ssh/wsl2-ssh-pageant.exe

# install xclip/xsel
curl -sL "https://raw.githubusercontent.com/Konfekt/win-bash-xclip-xsel/master/clip.sh" >"${HOME}"/.local/bin/xclip
curl -sL "https://raw.githubusercontent.com/Konfekt/win-bash-xclip-xsel/master/clip.sh" >"${HOME}"/.local/bin/xsel
chmod +x "${HOME}"/.local/bin/xclip
chmod +x "${HOME}"/.local/bin/xsel

# https://github.com/wslutilities/wslu
command -v wslview >/dev/null 2>&1 || cat <<-EOF
	    wslu is not installed.
	    wslu (wslview) is needed to open browser windows from linux commands.
	    install instructions: https://github.com/wslutilities/wslu#installation
EOF

echo "WSL has been set up"

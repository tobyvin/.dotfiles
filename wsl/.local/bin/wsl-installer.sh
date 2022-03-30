#!/usr/bin/env bash

DOTFILES="${HOME}/.dotfiles"

WINHOME="$(wslpath c:\\Users\\"${USER}")"

echo "Setting up WSL"

# link WINHOME
ln -sfn "$WINHOME" ~/win

# ssh-config
sed -r 's|(RemoteForward\s+.+\s+)\/home\/tobyv\/\.gnupg\/S\.gpg-agent\.extra|\1127.0.0.1:4321|' "${DOTFILES}"/ssh/.ssh/config |
sed '/Control/d' >"${WINHOME}/.ssh/config"

# Create windows symlinks to dotfiles
mkln.sh -f "$@" "${DOTFILES}"/git/.gitconfig "${WINHOME}"/.gitconfig
mkln.sh -f "$@" "${DOTFILES}"/gnupg/.gnupg/gpg.conf "${WINHOME}"/AppData/Roaming/gnupg/gpg.conf
mkln.sh -f "$@" "${DOTFILES}"/gnupg/.gnupg/gpg-agent.conf "${WINHOME}"/AppData/Roaming/gnupg/gpg-agent.conf
mkln.sh -f "$@" "${DOTFILES}"/gnupg/.gnupg/scdaemon.conf "${WINHOME}"/AppData/Roaming/gnupg/scdaemon.conf
mkln.sh -f "$@" "${DOTFILES}"/wsl/.config/wsl "${WINHOME}"/AppData/Roaming/alacritty
mkln.sh -f "$@" "${DOTFILES}"/alacritty/.config/alacritty "${WINHOME}"/.config/alacritty

# install xclip/xsel
curl -sL "https://raw.githubusercontent.com/Konfekt/win-bash-xclip-xsel/master/clip.sh" >"${HOME}/.local/bin/xclip"
curl -sL "https://raw.githubusercontent.com/Konfekt/win-bash-xclip-xsel/master/clip.sh" >"${HOME}/.local/bin/xsel"
chmod +x "${HOME}/.local/bin/xclip"
chmod +x "${HOME}/.local/bin/xsel"

# https://github.com/wslutilities/wslu
command -v wslview &>/dev/null || cat <<-EOF
    wslu is not installed.
    wslu (wslview) is needed to open browser windows from linux commands.
    install instructions: https://github.com/wslutilities/wslu#installation
EOF

echo "WSL has been set up"

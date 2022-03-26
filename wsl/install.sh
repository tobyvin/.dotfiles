#!/usr/bin/env bash

cd "${BASEDIR:-${HOME}/.dotfiles}"

WINHOME="$(wslpath c:\\Users\\${USER})"

RESET='\033[0m'
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
MAGENTA='\033[95m'

mkln="scripts/mkln.sh -f"

function show-warning() {
    gpgpath=$(wslpath -w "$(command -v gpg.exe)")
    gitgpg=$(git.exe config --system --get gpg.program)
    if [ "$gitgpg" = "$gpgpath" ]; then
        return
    fi
    echo
    echo -e "${BLUE}In order to use gpg with git for windows"
    echo -e "${BLUE}(and still share gitconfigs), you need to run"
    echo -e "${BLUE}the following command from an admin terminal:"
    echo
    echo "git.exe config --system gpg.program '$(wslpath -w "$(command -v gpg.exe)")'"
    echo
}

echo -e "${BLUE}Setting up WSL"

# link WINHOME
ln -sfn $WINHOME ~/win

# ssh-config
sed -r 's|(RemoteForward\s+.+\s+)\/home\/tobyv\/\.gnupg\/S\.gpg-agent\.extra|\1127.0.0.1:4321|' ssh/config |
    sed '/Control/d' >"${WINHOME}/.ssh/config"

# Create windows symlinks to dotfiles
$mkln $@ "gitconfig" "${WINHOME}/.gitconfig"
$mkln $@ "gnupg/gpg.conf" "${WINHOME}/AppData/Roaming/gnupg/gpg.conf"
$mkln $@ "alacritty" "${WINHOME}/AppData/Roaming/alacritty"
$mkln $@ "gnupg/gpg-agent.conf" "${WINHOME}/AppData/Roaming/gnupg/gpg-agent.conf"
$mkln $@ "gnupg/scdaemon.conf" "${WINHOME}/AppData/Roaming/gnupg/scdaemon.conf"
$mkln $@ "wt.json" "${WINHOME}/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"
$mkln $@ "winget.json" "${WINHOME}/AppData/Local/Packages/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe/LocalState/settings.json"

# install xclip/xsel
curl -sL "https://raw.githubusercontent.com/Konfekt/win-bash-xclip-xsel/master/clip.sh" >"${HOME}/.local/bin/xclip"
curl -sL "https://raw.githubusercontent.com/Konfekt/win-bash-xclip-xsel/master/clip.sh" >"${HOME}/.local/bin/xsel"
chmod +x "${HOME}/.local/bin/xclip"
chmod +x "${HOME}/.local/bin/xsel"

# install hotkeys.exe
install_dir="${WINHOME}/AppData/Local/Programs/hotkeys"
mkdir -p "${install_dir}"
rm -f "${install_dir}/hotkeys.exe"
curl -sL "https://github.com/tobyvin/hotkeys/releases/latest/download/hotkeys.exe" >"${install_dir}/hotkeys.exe"

# https://github.com/wslutilities/wslu
if ! command -v wslview &>/dev/null; then
    echo "wslu is not installed."
    echo "wslu (wslview) is needed to open browser windows from linux commands."
    echo "install instructions: https://github.com/wslutilities/wslu#installation"
fi

echo -e "${GREEN}WSL has been set up"

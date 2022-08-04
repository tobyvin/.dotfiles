# WSL2 YubiKey setup

## UPDATE

This is no longer necessary due to [usbipd-win](https://github.com/dorssel/usbipd-win)

I am now using [usbipd-win](https://github.com/dorssel/usbipd-win) to mount the yubikey directly into WSL2, and using [distod](https://github.com/nullpo-head/wsl-distrod) (adds bottled systemd to wsl) to start services as I normally would in linux

- [WSL2 YubiKey Setup](#wsl2-yubikey-setup)
  - [Intro](#Intro)
  - [SSH Agent](#ssh-agent)
    - [In Windows](#in-windows)
    - [VS Code](#vs-code)
    - [In WSL2](#in-wsl2)

## Intro

The following two sections are the result of a painstaking amount of google searches and GitHub issues followed by troubleshooting, tears, and tea breaks. Well, more accurately, the 20% came from the aforementioned alliteration. The 80% came from the following two guides.

- [drduh/YubiKey-Guide](https://github.com/drduh/YubiKey-Guide)
- [The ultimate guide to YubiKey on WSL2](https://dev.to/dzerycz/series/11353)
- [Forwarding gpg-agent to a remote system over SSH](https://wiki.gnupg.org/AgentForwarding)

The former is an incredibly detailed guide to setting up GPG keys using YubiKey as a smart card. The amount of information drduh has organized in that repository in immense, so I urge you to go star it if you find anything in this section helpful, as he deserves at least that much.

The second guide was used more as a reference/verification source for the first guide but none-the-less I found it to be helpful, so I figured I would include it here.

While I went down this rock filled rabbit hole for the purpose of getting my YubiKey working (seamlessly) in WSL2, the majority of this should be helpful even if you don't use a security key, as its specificity deals with getting the respective agents/sockets communicating between WSL2 and Windows.

<!-- TODO ssh/git config to use gpnupg -->
<!-- TODO setting up remote gpg/ssh forwarding  -->

## Windows

### SSH Agent

Install [gpg-bridge](https://github.com/BusyJay/gpg-bridge) using cargo

```powershell
# Powershell
cargo install -f --git https://github.com/busyjay/gpg-bridge
```

Set gpg-bridge to run on startup

```powershell
# Powershell
$cmdl = "$HOME\.cargo\bin\gpg-bridge.exe gpg-bridge-ssh --extra 127.0.0.1:4321 --ssh \\.\pipe\gpg-bridge-ssh --detach"
$key = New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Force
New-ItemProperty -Path $key.PSPath -Name "gpg-bridge" -Value "$cmdl"
```

Set SSH_AUTH_SOCK to have ssh use the translated pipe

```powershell
# Powershell
[System.Environment]::SetEnvironmentVariable('SSH_AUTH_SOCK',"\\.\pipe\gpg-bridge-ssh")
```

One-off to run gpg-bridge.exe without restarting

```powershell
# Powershell
Invoke-Expression "& $cmdl"
```

### GPG Agent

On the windows side the YubiKey is fully accessible, the GPG agent should just work.

## In WSL2

### SSH Agent

```sh
# Bash

# Install depends
sudo apt install socat iproute2

# Install wsl2-ssh-pageant
destination="$HOME/.ssh/wsl2-ssh-pageant.exe"
curl -sL "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe" -o "$destination"
# wget -O "$destination" "https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/latest/download/wsl2-ssh-pageant.exe"
# Set the executable bit.
chmod +x "$destination"
```

### GPG Agent

The only setup needed for getting the YubiKey working in WSL2 is to source/copy-paste [gpg.sh](wsl/gpg.sh) in your shell profile.

Along with the initialization code, I wrote a small function the resets all the related agents/sockets. If you do not attempt to access the YubiKey while it is not inserted, in my experience, GPG works great has no issues once reinserting the YubiKey. It is only (inconsistently) when you try to access a YubiKey that you have removed that puts it in a failed state.

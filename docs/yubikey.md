# WSL2 YubiKey Setup

- [WSL2 YubiKey Setup](#wsl2-yubikey-setup)
  - [Intro](#Intro)
  - [SSH Agent](#ssh-agent)
    - [In Windows](#in-windows)
    - [VS Code](#vs-code)
    - [In WSL2](#in-wsl2)

## Intro

The following two sections are the result of a painstaking amount of google searches and GitHub issues followed by troubleshooting, tears, and tea breaks. Well, more accurately, the 20% came from the aforementioned alliteration. The 80% came from the following two guides.  

 - [drduh/YubiKey-Guide](https://github.com/drduh/YubiKey-Guide)
 - [The ultimate guide to Yubikey on WSL2](https://dev.to/dzerycz/series/11353)

The former is an incredibly detailed guide to setting up GPG keys using YubiKey as a smart card. The amount of information drduh has organized in that repository in immense, so I urge you to go star it if you find anything in this section helpful, as he deserves at least that much.

The second guide was used more as a reference/verification source for the first guide but none-the-less I found it to be helpful, so I figured I would include it here.

While I went down this rock filled rabbit hole for the purpose of getting my YubiKey working (seamlessly) in WSL2, the majority of this should be helpful even if you don't use a security key, as its specificity deals with getting the respective agents/sockets communicating between WSL2 and Windows.

## SSH Agent 

### In WSL

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

### In Windows

Download [wsl-ssh-pageant](https://github.com/benpye/wsl-ssh-pageant)

```powershell
# Powershell

# Using scoop (https://scoop.sh/)
scoop bucket add extras
scoop install wsl-ssh-pageant
```

Set variables

**Note**  The version with '-gui', i.e. 'wsl-ssh-pageant-gui', ***has no*** gui/tray icon, while 'wsl-ssh-pageant' ***has*** a gui/tray icon. Use which ever you find most useful

```powershell
# Powershell

# Can be any name
$pipe = "ssh-pageant"

# Path to either wsl-ssh-pageant or wsl-ssh-pageant-gui executable
$pageant = "$env:SCOOP\apps\wsl-ssh-pageant\current\wsl-ssh-pageant-gui.exe"

[System.Environment]::SetEnvironmentVariable('SSH_AUTH_SOCK',"\\.\pipe\$pipe")
```

Set it to autostart on login

```powershell
# Powershell

$path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
$cmdl = "$pageant --winssh $pipe"
$key = try {
    Get-Item -Path $path -ErrorAction Stop
}
catch {
    New-Item -Path $path -Force
}

New-ItemProperty -Path $key.PSPath -Name "wsl-ssh-pageant" -Value "$cmdl"
``` 
<!-- Not sure if the following is needed or not. I thought it was but at the time of writing, I realize I did NOT have the .ssh/ssh.BAT file. So it may not be needed.

### VS Code

Due to how VS Code calls ssh, I found it necessary to create a shim for the WSL ssh bin. 

First create the following .bat file somewhere in your Windows fs.

```bat

```

Then, in VS Code, put the following in your settings.JSON,

```json
{
  "remote.SSH.path": "C:\\Users\\tobyv\\.ssh\\ssh.BAT",
}
``` -->

## GPG Agent 

### Windows

Download [gpg-bridge](https://github.com/BusyJay/gpg-bridge)

Set variables

```powershell
# Powershell

# Can be any free port
$port = 4444

$bridge = "$HOME\.cargo\bin\gpg-bridge.exe"
```

Set it to autostart on login

```powershell
# Powershell

$path = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
$cmdl = "$bridge 127.0.0.1:$port --detach"
$key = try {
    Get-Item -Path $path -ErrorAction Stop
}
catch {
    New-Item -Path $path -Force
}

New-ItemProperty -Path $key.PSPath -Name "gpg-bridge" -Value "$cmdl"
```

### In WSL2

The only setup needed for getting the YubiKey working in WSL2 is to source/copy-paste [gpg.sh](shell/gpg.sh) in your shell profile. 

Along with the initialization code, I wrote a small function the resets all the related agents/sockets. If you do not attempt to access the YubiKey while it is not inserted, in my experience, GPG works great has no issues once reinserting the YubiKey. It is only (inconsistently) when you try to access a YubiKey that you have removed that puts it in a failed state. 
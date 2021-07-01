My personal cheat sheet of commands for various tools and workflows

- [Git](#git)
  - [Split out subfolder into new repository](#split-out-subfolder-into-new-repository)
    - [(Optional) Migrate original subdir to submodule](#optional-migrate-original-subdir-to-submodule)
- [WSL2 Yubikey Setup](#wsl2-yubikey-setup)
  - [SSH Agent](#ssh-agent)
    - [In Windows](#in-windows)
  - [GPG Agent](#gpg-agent)
    - [Windows](#windows)
    - [In WSL2](#in-wsl2)

# Git

## Split out subfolder into new repository

*Be sure you are inside the original repo*

```sh
cd <orignal_repository>/<subdir-to-split>
```

Set local variables for use

```sh
username="$(git config user.username)"
subdir="$(git rev-parse --show-prefix)"
newrepo="$(basename $subdir)"
oldrepo="$(git rev-parse --show-toplevel)"
cd $oldrepo
```

Create a new branch containing only the sub-directory using `git subtree`

```sh
git subtree split -P $subdir -b $newrepo
```

Create a temp git repo and pull in the newly created branch

```sh
cd $(mktemp -d)

git init && git pull $oldrepo $newrepo
```

Copy over the git artifacts from original repo's root directory

```sh
cp -rt ./ $oldrepo/.gitignore $oldrepo/.gitattributes $oldrepo/.vscode
```

Commit changes

```sh
git add -A && git commit -m "split out $newrepo into submodule"
```

Create a new remote repository using something like [gh](https://github.com/cli/cli)

```sh
gh repo create $username/$newrepo
```

(Optional) You can also just create the new remote repository manually and set the new local repository's remote with

```sh
git remote add origin https://github.com/$username/$newrepo
```

Push newly created repository to remote

```sh
git push -u origin master
```

### (Optional) Migrate original subdir to submodule

Switch back into the original repository

```sh
cd $oldrepo
```

Remove the `subdir` from git and the filesystem

```sh
git rm -rf $subdir
rm -rf $subdir
```

Add the newly created remote repository as a submodule at the `subdir`'s path

```sh
git submodule add git@github.com:$username/$newrepo $subdir
git submodule update --init --recursive
```

Commit the changes to the original repository and push to remote

```sh
git commit -m "split out $newrepo into submodule"
git push -u origin master
```

# WSL2 Yubikey Setup

The following two sections are the result of a painstaking amount of google searches and github issues followed by troubleshooting, tears, and tea breaks. Well, more accurately, the 20% came from the aforementioned alliteration. The 80% came from the following two guides.  

 - [drduh/YubiKey-Guide](https://github.com/drduh/YubiKey-Guide)
 - [The ultimate guide to Yubikey on WSL2](https://dev.to/dzerycz/series/11353)

The former is a incredibly detailed guide to setting up GPG keys using YubiKey as a smartcard. The amount of information drduh has organized in that repository in immense, so I urge you to go star it if you find anything in this section helpful, as he deserves at least that much.

The second guide was used more as a reference/verification source for the first guide but none-the-less I found it to be helpful, so I figured I would include it here.

While I went down this rock filled rabbit hole for the purpose of getting my Yubikey working (seamlessly) in WSL2, the majority of this should be helpful even if you don't use a security key, as it specificity deals with getting the respective agents/sockets communicating between WSL2 and Windows.

## SSH Agent 

### In Windows

Download [wsl-ssh-pageant](https://github.com/benpye/wsl-ssh-pageant)

```powershell
# Using scoop (https://scoop.sh/)
scoop install wsl-ssh-pageant
```

Set variables

**Note**  The version with '-gui', i.e. 'wsl-ssh-pageant-gui', ***has no*** gui/tray icon, while 'wsl-ssh-pageant' ***has*** a gui/tray icon. Use which ever you find most useful

```powershell
# Can be any name
$pipe = "ssh-pageant"

# Path to either wsl-ssh-pageant or wsl-ssh-pageant-gui executable
$pageant = "$env:SCOOP\apps\wsl-ssh-pageant\current\wsl-ssh-pageant-gui.exe"

[System.Environment]::SetEnvironmentVariable('SSH_AUTH_SOCK',"\\.\pipe\$pipe")
```

Set it to autostart on login

```powershell
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

## GPG Agent 

### Windows

Download [gpg-bridge](https://github.com/BusyJay/gpg-bridge)

Set variables

```powershell
# Can be any free port
$port = 4444

$bridge = "$HOME\.cargo\bin\gpg-bridge.exe"
```

Set it to autostart on login

```powershell
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

The only setup needed for getting the YubiKey working in WSL2 is to source/copy-paste [gpg.sh](sh/gpg.sh) in your shell profile. 

Along with the initialization code, I wrote a small function the resets all the related agents/sockets. If you do not attempt to access the Yubikey while it is not inserted, in my experience, gpg works great has no issues once reinserting the Yubikey. It is only (inconsistently) when you try to access a Yubikey that you have removed that puts it in a failed state. 
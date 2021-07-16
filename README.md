tobyvin's dotfiles
==================


Install
-------

Clone the repo and its submodules, then install links.

```sh
git clone https://github.com/tobyvin/dotfiles.git ~/dotfiles && ~/dotfiles/install
```

The install **will override** the following configs by default:
- ~/.zshrc
- ~/.p10k.zsh
- ~/.gitconfig
- ~/.ssh/config
- ~/.gnupg/gpg.conf


To disable overwriting existing configs, set `defaults.link.force` in [install.conf.yaml](install.conf.yaml) to `false`:

```yaml
# file: install.conf.yaml
- defaults:
    link:
      create: true
      relink: true
      force: false <--
```

Configs
-------

#### Zsh Configuration

- [zshrc](zshrc) - Zsh profile (sources [profile.sh](shell/profile.sh) & [zsh/*](zsh))
- [starship.toml](starship.toml) - [starship](https://starship.rs/) cross-shell theme config 
- [shell/](sh) - Posix compliant cross-shell configs
  - [aliases.sh](shell/aliases.sh) - Alias definitions shared between shells
  - [gpg.sh](shell/gpg.sh) - Sets up the GPG agent bridges between wsl and windows
  - [profile.sh](shell/profile.sh) - Exports and Path additions shared between shells
  - [wsl.sh](shell/wsl.sh) - WSL2 specific config (sources [gpg.sh](shell/gpg.sh))
- [zsh/](zsh) - Zsh configs
  - [aliases.zsh](zsh/aliases.zsh) - Alias definitions (sources [aliases.sh](zsh/aliases.zsh))
  - [antigen.zsh](zsh/antigen.zsh) - Loads Antigen plugins and theme
  - [keybindings.zsh](zsh/keybindings.zsh) - Keybindings and related functions
  - [prompt.zsh](zsh/prompt.zsh) - Prompt configuration and prompt theme settings 
  - [setopt.zsh](zsh/setopt.zsh) - Zsh configuration settings
  - [wsl.zsh](zsh/wsl.zsh) - WSL2 specific config (sources [wsl.sh](shell/wsl.sh))

#### Misc

- [gitconfig](gitconfig) - Git configuration
- [ssh/](ssh) - SSH related files
  - [config](ssh/config) - SSH configuration
  - [wsl2-ssh-pageant](ssh/wsl2-ssh-pageant.exe) - connects SSH/GPG sockets between WSL2 and Windows
- [gnupg/](gnupg) - GnuPG (GPG) related files
  - [gpg.conf](gnupg/gpg.conf) - GPG configuration
  - [gpg-agent.conf](gnupg/gpg-agent.conf) - GPG-Agent configuration
  - [scdaemon.conf](gnupg/scdaemon.conf) - GPG smartcard daemon configuration

Submodules
----------

- ### [Dotbot](https://github.com/anishathalye/dotbot) - A tool that bootstraps your dotfiles ⚡️

#### Zsh

- [antigen](https://github.com/zsh-users/antigen) - The plugin manager for zsh.
- [fzf](https://github.com/junegunn/fzf) - 🌸 A command-line fuzzy finder
- [p10k](https://github.com/romkatv/powerlevel10k) - A Zsh theme
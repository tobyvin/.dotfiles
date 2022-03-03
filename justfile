#!/usr/bin/env just --justfile

dotfiles_path := justfile_directory()
comp_dir_zsh := "$HOME/.local/share/zsh/site-functions"
comp_dir_bash := "$HOME/.local/share/bash-completion/completions"

default:
    @just --choose

# install completion scripts for just
completion_just:
    just --completions zsh > {{comp_dir_zsh}}/_just
    just --completions bash > {{comp_dir_bash}}/just
    
install_rust:
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    
completion_rust:
    rustup completions bash > {{comp_dir_bash}}/rustup;
    rustup completions zsh > {{comp_dir_zsh}}/_rustup;
    rustup completions bash cargo > {{comp_dir_bash}}/cargo;
    rustup completions zsh cargo > {{comp_dir_zsh}}/_cargo
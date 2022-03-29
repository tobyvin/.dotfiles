VPATH = $(PATH)

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
ZSH_COMP_DIR := $(HOME)/.local/share/zsh/site-functions
BASH_COMP_DIR := $(HOME)/.local/share/bash-completion/completions

ARCH := $(shell uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/ | sed s/armv7l/armv6/)


.PHONY: interactive stow unstow clean gpg wsl

$(ZSH_COMP_DIR):
	mkdir -p $(ZSH_COMP_DIR)

$(BASH_COMP_DIR):
	mkdir -p $(BASH_COMP_DIR)

interactive: fzf rg # Interactive target runner
	@rg '^(\w+):(?:.*#\s*(.*)|.*)$$' 'makefile' --color always --line-number --no-heading -H --smart-case -r '$$1:$$2' \
	| fzf -0 -1 --ansi --tac --multi -d':' --with-nth 3 --header="Select target(s)" \
	--color "hl:-1:underline,hl+:-1:underline:reverse" \
	--preview 'echo; echo {3} "-" {4}; echo; bat --style=auto --color=always {..1} --highlight-line {2}' \
	--preview-window '80%,border-bottom,+{2}+3/3,~3'

stow: # Install configuration files
	stow */

unstow: # Uninstall configuration files
	stow --delete */

clean: # Remove all broken symbolic links from $HOME (recursivly)
	find $(HOME) -type l -exec sh -c 'for x; do [ -e "$$x" ] || rm -v "$$x"; done' _ {} +

gpg: # Install GPG keys
	gpg --auto-key-locate keyserver --locate-keys tobyv13@gmail.com
	gpg --import-ownertrust $(HOME)/.gnupg/trustfile.txt

wsl: # Run WSL install script
	stow wsl
	./wsl/.local/bin/wsl-installer.sh

cargo rust: $(ZSH_COMP_DIR) $(BASH_COMP_DIR) # Install rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	rustup completions bash >$(BASH_COMP_DIR)/rustup
	rustup completions zsh >$(ZSH_COMP_DIR)/_rustup
	rustup completions bash cargo >$(BASH_COMP_DIR)/cargo
	rustup completions zsh cargo >$(ZSH_COMP_DIR)/_cargo

cargo-quickinstall: cargo # Attempts to install prebuilt binaries, using cargo install as a fallback 
	cargo install cargo-quickinstall

starship: cargo-quickinstall $(ZSH_COMP_DIR) $(BASH_COMP_DIR) # Cross shell prompt, written in rust
	cargo quickinstall starship
	starship completions bash >$(BASH_COMP_DIR)/starship
	starship completions zsh >$(ZSH_COMP_DIR)/_starship

sheldon: cargo-quickinstall $(ZSH_COMP_DIR) $(BASH_COMP_DIR) # Cross shell prompt, written in rust
	cargo quickinstall sheldon
	sheldon completions --shell bash >$(BASH_COMP_DIR)/sheldon
	sheldon completions --shell zsh >$(ZSH_COMP_DIR)/_sheldon

bat: cargo-quickinstall $(ZSH_COMP_DIR) $(BASH_COMP_DIR) # Better cat, written in rust
	cargo quickinstall bat --target $(arch())-unknown-$(os())-mus
	curl -sL https://raw.githubusercontent.com/sharkdp/bat/master/assets/completions/bat.bash.in >$(BASH_COMP_DIR)/bat
	curl -sL https://raw.githubusercontent.com/sharkdp/bat/master/assets/completions/bat.zsh.in >$(ZSH_COMP_DIR)/_bat

fd: cargo-quickinstall $(ZSH_COMP_DIR) # Better cat, written in rust
	cargo quickinstall fd-find
	curl -sL https://raw.githubusercontent.com/sharkdp/fd/master/contrib/completion/_fd >$(ZSH_COMP_DIR)/_fd

rg: cargo-quickinstall $(ZSH_COMP_DIR) # Better grep, written in rust
	cargo quickinstall ripgrep
	curl -sL https://raw.githubusercontent.com/BurntSushi/ripgrep/master/complete/_rg >$(ZSH_COMP_DIR)/_rg

chtsh: $(ZSH_COMP_DIR) $(BASH_COMP_DIR) # CLI for https://cht.sh
	curl https://cht.sh/:cht.sh >$(HOME)/.local/bin/cht.sh
	chmod +x $(HOME)/.local/bin/cht.sh
	curl https://cht.sh/:bash_completion >$(BASH_COMP_DIR)/cht
	curl https://cheat.sh/:zsh >$(ZSH_COMP_DIR)/_cht

git-open: # Open git remotes in the browser
	curl -sL "https://raw.githubusercontent.com/paulirish/git-open/master/git-open" >$(HOME)/.local/bin/git-open &&
	chmod +x $(HOME)/.local/bin/git-open

gh: $(ZSH_COMP_DIR) $(BASH_COMP_DIR) # CLI for github API
	$(eval TEMP := $(shell mktemp -d))
	$(eval TAG := $(shell curl -sI https://github.com/cli/cli/releases/latest | grep -Po 'tag\/v?\K(\S+)'))
	curl -sL https://github.com/cli/cli/releases/latest/download/gh_$(TAG)_linux_$(ARCH).tar.gz | tar -C $(TEMP) -xz
	test -x $(TEMP)/gh_$(TAG)_linux_$(ARCH)/bin/gh
	install -Dm 755 $(TEMP)/gh_$(TAG)_linux_$(ARCH)/bin/gh $(HOME)/.local/bin/gh
	rm -rf $(TEMP)
	gh completion --shell bash >$(BASH_COMP_DIR)/gh
	gh completion --shell zsh >$(ZSH_COMP_DIR)/_gh

fzf: # Fuzzy finder, written in go
	$(eval TEMP := $(shell mktemp -d))
	$(eval TAG := $(shell curl -sI https://github.com/junegunn/fzf/releases/latest | grep -Po 'tag\/v?\K(\S+)'))
	curl -sL https://github.com/junegunn/fzf/releases/latest/download/fzf-${TAG}-linux_$(ARCH).tar.gz | tar -C $(TEMP) -xz
	test -x $(TEMP)/fzf
	rm -f $(HOME)/.local/bin/fzf
	install -Dm 755 $(TEMP)/fzf $(HOME)/.local/bin/fzf
	rm -rf $(TEMP)

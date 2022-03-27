VPATH = $(PATH)
ZSH_COMP_DIR := $(HOME)/.local/share/zsh/site-functions
BASH_COMP_DIR := $(HOME)/.local/share/bash-completion/completions
ARCH := $(shell uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/ | sed s/armv7l/armv6/)

gpg: EMAIL := tobyv13@gmail.com

stow:
	stow --target=$(HOME) */

unstow:
	stow --target=$(HOME) --delete */

cargo rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	rustup completions bash >$(BASH_COMP_DIR)/rustup;
	rustup completions zsh >$(ZSH_COMP_DIR)/_rustup;
	rustup completions bash cargo >$(BASH_COMP_DIR)/cargo;
	rustup completions zsh cargo >$(ZSH_COMP_DIR)/_cargo)

cargo-quickinstall: cargo
	cargo install cargo-quickinstall

starship: cargo-quickinstall
	cargo quickinstall starship
	starship completions bash >$(BASH_COMP_DIR)/starship;
	starship completions zsh >$(ZSH_COMP_DIR)/_starship

sheldon: cargo-quickinstall
	cargo quickinstall sheldon
	sheldon completions --shell bash >$(BASH_COMP_DIR)/sheldon;
	sheldon completions --shell zsh >$(ZSH_COMP_DIR)/_sheldon

bat: cargo-quickinstall
	cargo quickinstall bat --target $(arch())-unknown-$(os())-mus
	curl -sL https://raw.githubusercontent.com/sharkdp/bat/master/assets/completions/bat.bash.in >$(BASH_COMP_DIR)/bat
	curl -sL https://raw.githubusercontent.com/sharkdp/bat/master/assets/completions/bat.zsh.in >$(ZSH_COMP_DIR)/_bat

fd: cargo-quickinstall
	cargo quickinstall fd-find
	curl -sL https://raw.githubusercontent.com/sharkdp/fd/master/contrib/completion/_fd >$(ZSH_COMP_DIR)/_fd

rg: cargo-quickinstall
	cargo quickinstall ripgrep
	curl -sL https://raw.githubusercontent.com/BurntSushi/ripgrep/master/complete/_rg >$(ZSH_COMP_DIR)/_rg

chtsh:
	curl https://cht.sh/:cht.sh >$(HOME)/.local/bin/cht.sh
	chmod +x $(HOME)/.local/bin/cht.sh
	curl https://cht.sh/:bash_completion >$(BASH_COMP_DIR)/cht
	curl https://cheat.sh/:zsh >$(ZSH_COMP_DIR)/_cht

git-open:
	curl -sL "https://raw.githubusercontent.com/paulirish/git-open/master/git-open" >$(HOME)/.local/bin/git-open &&
	chmod +x $(HOME)/.local/bin/git-open;

gh:
	$(eval TEMP := $(shell mktemp -d))
	$(eval TAG := $(shell curl -sI https://github.com/cli/cli/releases/latest | grep -Po 'tag\/v?\K(\S+)'))
	curl -sL https://github.com/cli/cli/releases/latest/download/gh_$(TAG)_linux_$(ARCH).tar.gz | tar -C $(TEMP) -xz
	test -x $(TEMP)/gh_$(TAG)_linux_$(ARCH)/bin/gh
	install -Dm 755 $(TEMP)/gh_$(TAG)_linux_$(ARCH)/bin/gh $(HOME)/.local/bin/gh
	rm -rf $(TEMP)
	gh completion --shell bash >$(BASH_COMP_DIR)/gh
	gh completion --shell zsh >$(ZSH_COMP_DIR)/_gh

fzf:
	TEMP=$(mktemp -d)
	$(eval TAG := $(shell curl -sI https://github.com/junegunn/fzf/releases/latest | grep -Po 'tag\/v?\K(\S+)'))
	curl -sL https://github.com/junegunn/fzf/releases/latest/download/fzf-${TAG}-linux_$(ARCH).tar.gz | tar -C $(TEMP) -xz
	test -x $(TEMP)/fzf
	rm -f $(HOME)/.local/bin/fzf
	install -Dm 755 $(TEMP)/fzf $(HOME)/.local/bin/fzf
	rm -rf $(TEMP)

.PHONY: gpg wsl clean

gpg:
	gpg --auto-key-locate keyserver --locate-keys $(EMAIL)
	gpg --import-ownertrust $(HOME)/.gnupg/trustfile.txt

wsl: 
	./wsl/install.sh

clean:
	echo "TODO"
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: stow
stow:  # Install configs
	stow */

.PHONY: unstow
unstow: # Uninstall configuration files
	stow --delete */

.PHONY: clean
clean: # Remove all broken symbolic links from $HOME (recursivly)
	fd . $(HOME) --hidden --exclude $(shell realpath --relative-base="$(HOME)"  "$(ROOT_DIR)") --exclude $(shell realpath --relative-base="$(HOME)" "$(XDG_CACHE_HOME)") --type l --exec sh -c '[ -e "{}" ] || rm -v {}'

.PHONY: gpg
gpg: # Install GPG keys
	gpg --auto-key-locate keyserver --locate-keys tobyv13@gmail.com
	gpg --import-ownertrust $(HOME)/.gnupg/trustfile.txt

.PHONY: wsl
wsl:
	@if [ -n "$$WSL_DISTRO_NAME" ]; then stow wsl --override=/*; fi

.PHONY: wsl-script
wsl-script: wsl # Run WSL install script
	./wsl/.local/bin/wsl-installer.sh

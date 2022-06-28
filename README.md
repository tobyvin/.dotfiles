tobyvin's dotfiles
==================

Install
-------

```sh
git clone https://git.sr.ht/~tobyvin/.dotfiles ~/.dotfiles && cd ~/.dotfiles && make stow
```

Getting started
---------------

The configuration files are managed using gnu stow and make. The Makefile
includes targets for stowing, un-stowing, and cleaning the symlinks. It also
has targets for installing a selection of tools I use.

Run `make interactive` or simply `make` to view and interactively select targets
to install.

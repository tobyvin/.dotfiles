# tobyvin's [.dotfiles]

## Install

```sh
git clone https://git.tobyvin.dev/.dotfiles ~/.dotfiles && cd ~/.dotfiles && ./install.sh
```

## Getting started

The configuration files are managed using GNU [stow]. The included [install.sh]
script can be used to stow specified (or, if unspecified, all) packages using
`./install.sh [package ..]`, clean broken symlinks from `$HOME` using
`./install.sh -C`, or both with `./install.sh -c [package ..]`. Run
`./install.sh -h` to see all options.

[.dotfiles]: https://sr.ht/~tobyvin/.dotfiles/
[install.sh]: ./install.sh
[stow]: https://www.gnu.org/software/stow/

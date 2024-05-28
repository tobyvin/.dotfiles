# tobyvin's [.dotfiles]

## Install

```sh
git clone https://git.tobyvin.dev/.dotfiles ~/.dotfiles && cd ~/.dotfiles && ./install.sh
```

## Getting started

The configuration files are managed using GNU [stow]. The included [install.sh]
script will install specified (or, if unspecified, all) packages using
`./install.sh [package ..]`. The script will also do it's best to clean broken
symlinks from `$HOME` that belong to the repository, and is fairly strict about
what links it will remove, erroring on the side caution as to not remove any
symlinks that do (or did) not belong to the repository.

## Mirrors

I host this repository (and many others) on my local [cgit] instance, but it is
also mirrored to both [SourceHut] and [GitHub].

[cgit]: <https://git.tobyvin.dev>
[SourceHut]: <https://git.sr.ht/~tobyvin/.dotfiles>
[GitHub]: <https://github.com/tobyvin/.dotfiles>
[.dotfiles]: <https://git.tobyvin.dev/.dotfiles>
[install.sh]: ./install.sh
[stow]: <https://www.gnu.org/software/stow/>

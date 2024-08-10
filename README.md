# tobyvin's [.dotfiles]

## Install

```sh
git clone https://git.tobyvin.dev/.dotfiles && ./.dotfiles/install.sh
```

## Getting started

The configuration files are managed using GNU [stow] and the dotfiles can be
installed solely by running `stow */` from the repository's root.

### Install script

A [install.sh] helper script is provided that will stow packages and run package
specific install scripts. It can be run with `./install.sh [package ..]`,
defaulting to operating on all packages if none are specified.

It stows the packages using the `-R` (restow) option, which will remove any
broken or missing symlinks belonging to the repository. Normally this spams the
output with `UNLINK` and `LINK` for every file in every package, so it's piped
through a small awk script to filter the output to only non-reverted actions.

#### Package specific install scripts

The install script will run any package specific install scripts that exist in
the root of a package directory, e.g. `./<pkgname>/install.sh`.

Example usecases:

- Creating non-existent directories
- Enabling systemd user services
- Fixing file permissions
- Running one-time setup commands
- etc.

##### Example package install script

```sh
#!/bin/sh

pkgname=<pkgname>

if ! command -v "$pkgname" >/dev/null; then
 printf '%s: %s not found, skipping...\n' "$0" "$pkgname"
 exit 0
fi

mkdir -pv "${XDG_CACHE_HOME}/${pkgname}"

printf "%s: Installing service\n" "$0"
systemctl --user enable --now --no-block "${pkgname}.service"
```

More examples: [zsh], [pass], and [nvim]

## Mirrors

I host this repository (and many others) on my local [cgit] instance, but it is
also mirrored to both [SourceHut] and [GitHub].

[.dotfiles]: https://git.tobyvin.dev/.dotfiles
[cgit]: https://git.tobyvin.dev
[github]: https://github.com/tobyvin/.dotfiles
[install.sh]: ./install.sh
[nvim]: ./nvim/install.sh
[pass]: ./pass/install.sh
[sourcehut]: https://git.sr.ht/~tobyvin/.dotfiles
[stow]: https://www.gnu.org/software/stow/
[zsh]: ./zsh/install.sh

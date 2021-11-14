#!/bin/sh

# modified from https://github.com/japaric/trust/blob/gh-pages/install.sh.

set -e

help() {
    cat <<'EOF'
Install a binary release of a Rust crate hosted on GitHub

Usage:
    install-crate.sh [options]

Options:
    -h, --help      Display this message
    -q, --quiet     Silence all output
    --git SLUG      Get the crate from "https://github/$SLUG"
    -f, --force     Force overwriting an existing binary
    --crate NAME    Name of the crate to install (default <repository name>)
    --tag TAG       Tag (version) of the crate to install (default <latest release>)
    --no-tag        Do not tag between the crate and the target in the url
    --target TARGET Install the release compiled for $TARGET (default <`rustc` host>)
    --to LOCATION   Where to install the binary (default ~/.cargo/bin)
    --completion
                    Install all the completions
    
    --completion-bash DIR
                    Install the bash completion scripts in DIR (default ~/.local/share/bash_completion.d)

    --completion-zsh  DIR
                    Install the zsh completion scripts in DIR (default ~/.local/share/zsh/site-functions)
    
    --completion-fish DIR
                    Install the fish completion scripts in DIR (default ~/.config/fish/completions)
EOF
}

say() {
    if [ ! $quiet ]; then
        echo "install-crate.sh: $1"
    fi
}

say_err() {
    say "$1" >&2
}

err() {
    if [ ! -z $td ]; then
        rm -rf $td
    fi

    say_err "ERROR $1"
    exit 1
}

need() {
    if ! command -v $1 >/dev/null 2>&1; then
        err "need $1 (command not found)"
    fi
}

is_opt() { case $1 in "--"*) true ;; *) false ;; esac }
is_arg() { if [ "$1" ] && ! is_opt $1; then true; else false; fi; }

quiet=false
force=false
no_tag=false
completion_bash=false
completion_zsh=false
completion_fish=false
comp_dir_bash="${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions"
comp_dir_zsh="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
comp_dir_fish="${XDG_CONFIG_HOME:-$HOME/.config}/fish/completions"
while test $# -gt 0; do
    case $1 in
    --quiet | -q)
        quiet=true
        ;;
    --crate)
        crate=$2
        shift
        ;;
    --force | -f)
        force=true
        ;;
    --git)
        git=$2
        shift
        ;;
    --help | -h)
        help
        exit 0
        ;;
    --tag)
        tag=$2
        shift
        ;;
    --no-tag)
        no_tag=true
        ;;
    --target)
        target=$2
        shift
        ;;
    --to)
        dest=$2
        shift
        ;;
    --completion)
        completion_bash=true
        completion_zsh=true
        completion_fish=true
        ;;
    --completion-bash)
        completion_bash=true
        if is_arg $2; then
            comp_dir_bash=$2
            shift
        fi
        ;;
    --completion-zsh)
        completion_zsh=true
        if is_arg $2; then
            echo "$2"
            comp_dir_zsh=$2
            shift
        fi
        ;;
    --completion-fish)
        completion_fish=true
        if is_arg $2; then
            comp_dir_fish=$2
            shift
        fi
        ;;
    *) ;;

    esac
    shift
done

# Dependencies
need basename
need curl
need install
need mkdir
need mktemp
need tar

# Optional dependencies
if [ -z $crate ] || [ -z $tag ] || [ -z $target ]; then
    need cut
fi

if [ -z $tag ]; then
    need rev
fi

if [ -z $target ]; then
    need grep
    need rustc
fi

if [ -z $git ]; then
    err 'must specify a git repository using `--git`. Example: `install.sh --git japaric/cross`'
fi

url="https://github.com/$git"
say_err "GitHub repository: $url"

if [ -z $crate ]; then
    crate=$(echo $git | cut -d'/' -f2)
fi

say_err "Crate: $crate"

url="$url/releases"

if [ -z $tag ]; then
    tag=$(curl -s "$url/latest" | cut -d'"' -f2 | rev | cut -d'/' -f1 | rev)
    say_err "Tag: latest ($tag)"
else
    say_err "Tag: $tag"
fi

if [ -z $target ]; then
    target=$(rustc -Vv | grep host | cut -d' ' -f2)
fi

say_err "Target: $target"

if [ -z $dest ]; then
    dest="$HOME/.cargo/bin"
fi

if [ $no_tag = false ]; then
    crate_tag="-$tag"
fi

say_err "Installing to: $dest"
url="$url/download/$tag/$crate${crate_tag}-$target.tar.gz"

say_err "Downloading: $url"

td=$(mktemp -d || mktemp -d -t tmp)
curl -sL $url | tar -C $td -xz

for f in $(find "$td" -type f); do
    case $f in
    *".bash")
        [ $completion_bash ] && install -D $f "$comp_dir_bash/$crate"
        ;;
    *".zsh")
        [ $completion_zsh ] && install -D $f "$comp_dir_zsh/_$crate"
        ;;
    *".fish")
        [ $completion_fish ] && install -D $f "$comp_dir_fish/$crate.fish"
        ;;
    *) ;;
    esac

    test -x $f || continue
    if [ -e "$dest/$f" ] && [ $force = false ]; then
        err "$(dirname $f) already exists in $dest"
    else
        install -Dm 755 $f $dest
    fi
done

rm -rf $td

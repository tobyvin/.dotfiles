#!/usr/bin/env bash

TEMP=$(getopt -o hvqdf --long help,verbose,quiet,debug,force \
    -n 'javawrap' -- "$@")

if [ $? != 0 ]; then
    echo "Terminating..." >&2
    exit 1
fi

eval set -- "$TEMP"

SCRIPT="$(basename $0)"
VERBOSE=false
QUIET=false
DEBUG=false
FORCE=false

read -r -d '' USAGE <<-EOF
USAGE: $SCRIPT [OPTIONS] <SOURCE> <TARGET>

OPTIONS:
    -h, --help                          Show this message
    -v, --verbose                       Show more output
    -q, --quiet                         Suppress all output
    -d, --debug                         NOT IMPLEMENTED
    -f, --force                         Overwrite items

ARGS:
    <SOURCE> <TARGET>...  File to link.
EOF

while true; do
    case "$1" in
    -h | --help)
        echo "$USAGE"
        exit 0
        ;;
    -v | --verbose)
        VERBOSE=true
        shift
        ;;
    -q | --quiet)
        QUIET=true
        shift
        ;;
    -d | --debug)
        DEBUG=true
        shift
        ;;
    -f | --force)
        FORCE=true
        shift
        ;;
    --)
        shift
        break
        ;;
    *)
        break
        ;;
    esac
done

if ! command -v powershell.exe &>/dev/null; then
    [ "$QUIET" != true ] && echo "Powershell not found in path." >&2
    exit 1
fi

if [ -z "$2" ]; then
    2="$(pwd)"
fi

[ "$VERBOSE" == true ] && echo "linking $2 -> $1"

if [ -d "$1" ]; then
    [ "$VERBOSE" == true ] && echo "$1 is a directory. Creating junction."
    args='/J'
fi

source=$(wslpath -w $1)
target=$(wslpath -w $(dirname $2))\\$(basename $2)

if ls -la "$(dirname $2)/" 2>/dev/null | grep -q "$(basename $2)"; then

    current_path=$(powershell.exe -c "(Get-Item $target).Target")

    if [[ "${current_path/*wsl$/}" == *"${source/*wsl$/}"* ]]; then
        [ "$VERBOSE" == true ] && echo "$(basename $2) is set correctly. Skipping."
        exit 0
    fi

    if [ "$FORCE" == true ]; then
        [ "$VERBOSE" == true ] && echo "$(basename $2) exists. Overwriting."
        rm -rf "$2"
    else
        [ "$QUIET" != true ] && echo "$(basename $target) already exists. Use -f to overwrite." >&2
        exit 1
    fi
fi

mkdir -p "$(dirname $2)"

if [ "$DEBUG" == true ]; then
    [ "$QUIET" != true ] && printf '\nCommand: \n%s\n\n' "powershell.exe -c cd ~; cmd /c mklink ${args} ${target} ${source} &>/dev/null"
else
    powershell.exe -c "cd ~; cmd /c mklink ${args} ${target} ${source}" &>/dev/null
fi

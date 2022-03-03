#!/bin/sh
TEMP=$(getopt -o hf --long help,force \
    -n 'javawrap' -- "$@")

if [ $? != 0 ]; then
    echo "Terminating..." >&2
    exit 1
fi

eval set -- "$TEMP"

SCRIPT="$(basename $0)"
ENV_CACHE="${HOME}/.cache/td/.env"

help() {
    cat <<-EOF
$SCRIPT
Toby Vincent <tobyv13@gmail.com>

$SCRIPT is a script for managing and navigating a persistent temp directory. In
order to function properly, this script must be sourced in the currently shell.
Consider setting an alias such as

    alias td=". $SCRIPT"

USAGE:
    $SCRIPT [OPTIONS] <COMMAND>
    $SCRIPT [OPTIONS]

OPTIONS:
    -h, --help      Display this message
    -f, --force     Use the --force argument when removing TD

ARGS:
    toggle (default)
        Switch between TD_ORIGIN and TD. This will create TD if it does not
        exist. This is the default if no command is provided.

    new | create      
        Creates a new temp directory and cds into it it stores the path
        to the temp directory in TD, and the path to the previous directory in 
        TD_ORIGIN.

    rm | remove
        Removes the directory stored in TD unsets TD and TD_ORIGIN.

    ls | list | show
        Shows the current values for TD and TD_ORIGIN
EOF
}

echo_err() {
    echo >&2 "$SCRIPT: $@"
}

show() {
    if [ ! -n "$TD" ]; then
        echo_err "Not set"
        return 1
    fi
    echo "TD=$TD"
    echo "TD_ORIGIN=$TD_ORIGIN"
}

remove() {
    if [ ! -n "$TD" ]; then
        echo_err "Not set"
        return 1
    fi

    rm "$rm_args" "$TD"

    echo "removed $TD"

    if [ "$PWD" = "$TD" ]; then
        cd "$TD_ORIGIN"
    fi

    rm "$ENV_CACHE" -rf
    unset TD
    unset TD_ORIGIN
}

create() {
    remove 2>/dev/null

    td=$(mktemp -d)

    export TD="$td"
    update-origin

    echo "created $TD"
    cd "$TD"
}

update-origin() {
    export TD_ORIGIN="$PWD"
    cat >$ENV_CACHE <<-EOF
TD=$TD
TD_ORIGIN=$TD_ORIGIN
EOF
}

toggle() {
    if [ "$PWD" = "$TD" ]; then
        cd "$TD_ORIGIN"
    elif [ -n "$TD" ]; then
        update-origin
        cd "$TD"
    else
        create
    fi
}

if [ -f "$ENV_CACHE" ]; then
    export $(cat "$ENV_CACHE" | xargs)
fi

rm_args="-r"
while test $# -gt 0; do
    case $1 in
    --help | -h)
        help
        return 0
        ;;
    --force | -f)
        rm_args="-rf"
        shift
        ;;
    --)
        shift
        break
        ;;
    *) break ;;
    esac
done

case $1 in
ls | list | show)
    show
    ;;
rm | remove)
    remove
    ;;
new | create)
    create
    ;;
* | toggle)
    toggle
    ;;
esac

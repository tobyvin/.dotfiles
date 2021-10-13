#!/usr/bin/env bash

getopt --test 2>/dev/null
if [[ $? -ne 4 ]]; then
    echo "GNU's enhanced getopt is required to run this script"
    echo "You can usually find this in the util-linux package"
    echo "On MacOS/OS X see homebrew's package: http://brewformulas.org/Gnu-getopt"
    echo "For anyone else, build from source: http://frodo.looijaard.name/project/getopt"
    exit 1
fi

SCRIPT="$(basename $0)"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

SHORT=hvqil:t:
LONG=help,verbose,quiet,interactive,license:,template:

# Defaults
VERBOSE=0
QUIET=0
INTERACTIVE=0
TEMPLATE="visualstudiocode"
LICENSE="mit"

# Usage output
read -r -d '' USAGE <<-EOF
USAGE: $SCRIPT [OPTIONS] <IGNORE_TEMPLATE>

OPTIONS:
    -h, --help              Show this message
    -v, --verbose           Show more output
    -q, --quiet             Suppress all output
    -i, --interactive       Add ignore templates interactivly
    
    -l, --license [LICENSE_ID]
            Specify which license to generate. Defaults to 'mit'

    -t, --template [IGNORE_TEMPLATE,...]
            Project template(s) used when generating the .gitignore file. It 
            can also be a comma seperated list or templates. Use '-t list' to 
            see available templates.
EOF

TEMP=$(getopt \
    --options ${SHORT} \
    --longoptions ${LONG} \
    --name ${SCRIPT} \
    -- "$@")

if [ $? != 0 ]; then
    echo "Terminating..." >&2
    exit 1
fi

eval set -- "${TEMP}"
unset TEMP

while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
        echo "$USAGE"
        exit 0
        ;;
    -v | --verbose)
        VERBOSE=1
        shift
        ;;
    -q | --quiet)
        QUIET=1
        shift
        ;;
    -i | --interactive)
        INTERACTIVE=1
        shift
        ;;
    -l | --license)
        LICENSE="$2"
        shift 2
        ;;
    -t | --template)
        TEMPLATE="$2"
        shift 2
        ;;
    --)
        shift
        break
        ;;
    *) break ;;
    esac
done

VALID_TEMPLATES=$(curl -L -s "https://www.toptal.com/developers/gitignore/api/list")

function get-gitignore() {
    IFS=',' read -ra input <<<"$1"
    if [ -z "$2" ]; then
        templates=""
    else
        templates="$2,"
    fi

    for template in "${input[@]}"; do
        if [[ ",$templates," == *",$template,"* ]]; then
            [ "$QUIET" != 1 ] && echo "'${template}' is already added." >&2
        elif ! [[ $VALID_TEMPLATES =~ "$template" ]]; then
            [ "$QUIET" != 1 ] && echo "'${template}' is not a valid template." >&2
        else
            templates+="${template},"
            [ "$VERBOSE" == 1 ] && echo "Added template: ${template}" >&2
        fi
    done

    echo ${templates%?}
}

function get-license() {
    licenseJson="$(curl -sH 'Accept: application/vnd.github.v3+json' https://api.github.com/licenses/$1)"
    # not_found='"message": "Not Found"'
    if [[ $licenseJson =~ '"message": "Not Found"' ]]; then
        [ "$QUIET" != 1 ] && echo "'${LICENSE}' is not a valid license identifier." >&2
    else
        echo $licenseJson | grep -oP '.*"body":\s*"\K.*(?=\s*",)' |
            tr '\n' '\0' | xargs -0 printf '%b\n' |
            sed "s/\\[year\\]/$(date +'%Y')/" |
            sed "s/\\[fullname\\]/$(git config --get user.name)/"
    fi
}

function interactive() {
    local templates=''

    while true; do
        read -p 'Input gitignore template(s): ' -i "$1" input
        echo ""
        [ -z "$input" ] && break
        if [[ "$input" == "list" ]]; then
            echo "$VALID_TEMPLATES" >&2
        else
            for template in $input; do
                templates="$(get-gitignore $template $templates)"
            done
        fi
        echo "" >&2
        [ "$QUIET" != 1 ] && echo "Templates: ${templates}" >&2
    done

    echo "${templates%?}"
}

if [[ "$TEMPLATE" == "list" ]]; then
    echo "$VALID_TEMPLATES"
    exit 0
fi

if [ $INTERACTIVE -eq 0 ]; then
    cmdtype=get-gitignore
else
    cmdtype=interactive
fi

TEMPLATES=$($cmdtype $TEMPLATE)

# .gitignore
[ "$VERBOSE" == 1 ] && echo "Creating .gitignore using: ${TEMPLATES}" >&2
curl -L -s "https://www.toptal.com/developers/gitignore/api/${TEMPLATES}" >.gitignore

# .gitattributes
[ "$VERBOSE" == 1 ] && echo "Creating .gitattributes" >&2
curl -sL "https://gist.githubusercontent.com/tobyvin/70f3671c76016063594ea45edbb97094/raw" >.gitattributes

# LICENSE
[ "$VERBOSE" == 1 ] && echo "Creating LICENSE using: ${LICENSE}" >&2
get-license $LICENSE >LICENSE

echo "$SCRIPT_DIR"

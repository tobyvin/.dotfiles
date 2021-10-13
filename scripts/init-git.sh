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
GITATTRIBUTES_URL="https://gist.githubusercontent.com/tobyvin/70f3671c76016063594ea45edbb97094/raw"

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

validate-template() {
    local template="$1"
    local templates="$2"
    if [[ ",$2," == *",$template,"* ]]; then
        [ "$QUIET" != 1 ] && printf "'%s' is already added.\n" "$template" >&2
        return 1
    elif ! [[ $VALID_TEMPLATES =~ "$template" ]]; then
        [ "$QUIET" != 1 ] && printf "'%s' is not a valid template.\n" "$template" >&2
        return 1
    else
        [ "$VERBOSE" == 1 ] && printf "Added template: %s\n" "$template" >&2
        return 0
    fi
}

get-gitignore() {
    local templates=''
    IFS=',' read -ra input <<<"$1"

    for template in "${input[@]}"; do
        if validate-template "$template" "$templates"; then
            templates+="${template},"
        fi
    done

    echo ${templates%?}
}

get-gitignore-interactive() {
    local templates=''

    while true; do
        read -p 'Input gitignore template(s): ' -i "$1" readInput
        echo ""

        IFS=', ' input=$readInput
        [ -z "$input" ] && break
        if [[ "$input" == "list" ]]; then
            echo "$VALID_TEMPLATES" >&2
        else
            for template in $input; do
                if validate-template "$template" "$templates"; then
                    templates+="${template},"
                fi
            done
        fi
        [ "$QUIET" != 1 ] && printf "\nTemplates: %s\n" "${templates%?}" >&2
    done

    echo "${templates%?}"
}

get-license() {
    licenseJson="$(curl -sH 'Accept: application/vnd.github.v3+json' https://api.github.com/licenses/$1)"
    # not_found='"message": "Not Found"'
    if [[ $licenseJson =~ '"message": "Not Found"' ]]; then
        [ "$QUIET" != 1 ] && printf "'%s' is not a valid license identifier.\n" "$LICENSE" >&2
    else
        echo $licenseJson | grep -oP '.*"body":\s*"\K.*(?=\s*",)' |
            tr '\n' '\0' | xargs -0 printf '%b\n' |
            sed "s/\\[year\\]/$(date +'%Y')/" |
            sed "s/\\[fullname\\]/$(git config --get user.name)/"
    fi
}

if [[ "$TEMPLATE" == "list" ]]; then
    echo "$VALID_TEMPLATES"
    exit 0
fi

if [ $INTERACTIVE -eq 0 ]; then
    gitignore_cmd=get-gitignore
else
    gitignore_cmd=get-gitignore-interactive
fi

TEMPLATES=$($gitignore_cmd $TEMPLATE)

# .gitignore
[ "$VERBOSE" == 1 ] && printf "Creating .gitignore using: %s\n" "$TEMPLATES" >&1
curl -L -s "https://www.toptal.com/developers/gitignore/api/${TEMPLATES}" >.gitignore

# .gitattributes
[ "$VERBOSE" == 1 ] && printf "Creating .gitattributes\n" >&1
curl -sL "$GITATTRIBUTES_URL" >.gitattributes

# LICENSE
[ "$VERBOSE" == 1 ] && printf "Creating LICENSE using: %s\n" "$LICENSE" >&1
get-license $LICENSE >LICENSE

echo "$SCRIPT_DIR"

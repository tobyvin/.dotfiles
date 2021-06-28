# NOTE: This requires GNU getopt.  On Mac OS X and FreeBSD, you have to install this
# separately; see below.
TEMP=$(getopt -o hvdsea: --long help,verbose,debug,signature,encryption,authentication \
    -n 'javawrap' -- "$@")

if [ $? != 0 ]; then
    echo "Terminating..." >&2
    exit 1
fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

help() {
    cat <<EOF
usage: $0 [OPTIONS]

    -h,--help               Show this message
    -v,--verbose            Show test output
    -d,--debug              NOT IMPLEMENTED
    -s,--signature          Test signature key
    -e,--encryption         Test encryption key
    -a,--authentication     Test authentication key
EOF
}

VERBOSE=false
DEBUG=false
SIGNATURE=false
ENCRYPTION=false
AUTHENTICATION=false
ALL=true

while true; do
    case "$1" in
    -h | --help)
        help
        exit 0
        ;;
    -v | --verbose)
        VERBOSE=true
        shift
        ;;
    -d | --debug)
        DEBUG=true
        shift
        ;;
    -s | --signature)
        ALL=false
        SIGNATURE=true
        shift
        ;;
    -e | --encryption)
        ALL=false
        ENCRYPTION=true
        shift
        ;;
    -a | --authentication)
        ALL=false
        AUTHENTICATION=true
        shift
        ;;
    --)
        shift
        break
        ;;
    *) break ;;
    esac
done

function print_result() {
    if [ $? -ne 0 ]; then
        echo "Failed: $?"
    else
        echo "Succeeded"
    fi

    if [ $VERBOSE -eq "true" ]; then
        echo "\nOutput:\n$result"
    fi
}

if [[ $ALL -eq "true" || $SIGNITURE -eq "true" ]]; then
    echo "Testing signiture key..."
    result="$(echo '' | gpg --clearsign &>/dev/null 2>&1)"
    print_result result
fi

if [[ $ALL -eq "true" || $ENCRYPTION -eq "true" ]]; then
    echo "Testing encryption key..."
    temp="$(mktemp -d)"
    echo "secret file contents: 42" >$temp/test.txt

    result="$(gpg --output $temp/test.gpg -e $temp/test.txt 2>&1 && gpg --output $temp/test.out -d $temp/test.txt.gpg 2>&1)"
    grep '42' $temp/test.out 2>&1
    print_result result
fi

if [[ $ALL -eq "true" || $AUTHENTICATION -eq "true" ]]; then
    echo "Testing authentication key..."
    result="$(ssh-add -l)"
    print_result result
fi

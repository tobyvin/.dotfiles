# Aliases
alias zshrc="${=EDITOR} ~/.zshrc"
alias update="sudo apt update && apt list --upgradable"
alias upgrade="sudo apt upgrade -y"
alias ipa="ip -s -c -h a"
alias untar="tar -zxvf "
alias py=python3
alias python=python3
alias pip=pip3
alias dsh="dce sh"
alias clone=github-clone 


function github-clone() {
    if [[ "$1" != *"/"* ]]; then
        1="$(git config user.username)/$1"
    fi

    git clone git@github.com:$1.git
}
#!/bin/sh

# See: https://drewdevault.com/2022/05/25/Google-has-been-DDoSing-sourcehut.html
export GOPRIVATE=git.sr.ht
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$HOME/.local/bin"

prepend_path "$GOPATH/bin"

export PATH

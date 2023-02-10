#!/bin/sh

export GOPATH="$XDG_DATA_HOME/go"
export PATH="$PATH:$GOPATH/bin"

# See: https://drewdevault.com/2022/05/25/Google-has-been-DDoSing-sourcehut.html
export GOPRIVATE=git.sr.ht

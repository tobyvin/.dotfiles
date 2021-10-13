#!/usr/bin/env bash

USER="tobyvin"
GIST_ID="c94716d1106256e4ab0e27aed398a0a2"

curl -Ls "https://gist.github.com/${USER}/${GIST_ID}/download" -o tempFile
unzip -q tempFile
rm -rf tempFile
mv "${GIST_ID}-master" styles
mv styles/template.tex "$(basename "$(pwd)").tex"
mv styles/table.tex .

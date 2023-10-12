#!/bin/sh

printf "%s: Restoring plugins\n" "$0"

nvim --headless -c 'Lazy! restore' -c qa
nvim --headless -c 'Lazy! clean' -c qa

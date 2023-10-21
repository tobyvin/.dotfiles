#!/bin/sh

DFT_DISPLAY='side-by-side-show-both'
GIT_EXTERNAL_DIFF=$(command -v "difft")

export GIT_EXTERNAL_DIFF DFT_DISPLAY

#!/bin/sh

export OPAMROOT="$XDG_DATA_HOME/opam"
export OPAM_SWITCH_PREFIX="$OPAMROOT/default"
export CAML_LD_LIBRARY_PATH="$OPAM_SWITCH_PREFIX/lib/stublibs:/usr/lib/ocaml/stublibs:/usr/lib/ocaml"
export OCAML_TOPLEVEL_PATH="$OPAM_SWITCH_PREFIX/lib/toplevel"
export MANPATH="$MANPATH:$OPAM_SWITCH_PREFIX/man"

prepend_path "$OPAM_SWITCH_PREFIX/bin"

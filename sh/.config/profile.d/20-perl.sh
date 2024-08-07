#!/bin/sh

export PERL_CPANM_HOME="$XDG_CACHE_HOME/perl"
export PERL_LOCAL_LIB_ROOT="$XDG_DATA_HOME/perl"
export PERL5LIB="$PERL_LOCAL_LIB_ROOT/lib/perl5"
export PERL_MB_OPT="--install_base '$PERL_LOCAL_LIB_ROOT'"
export PERL_MM_OPT="INSTALL_BASE=$PERL_LOCAL_LIB_ROOT"

prepend_path "$PERL_LOCAL_LIB_ROOT/bin"

export PATH

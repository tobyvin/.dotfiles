#!/bin/sh

export OMNISHARPHOME="$XDG_CONFIG_HOME/omnisharp"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export PATH="$PATH:$DOTNET_CLI_HOME/tools"

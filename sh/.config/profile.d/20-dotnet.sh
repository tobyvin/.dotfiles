#!/bin/sh

export OMNISHARPHOME="$XDG_CONFIG_HOME/omnisharp"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"

prepend_path "$DOTNET_CLI_HOME/tools"

export PATH

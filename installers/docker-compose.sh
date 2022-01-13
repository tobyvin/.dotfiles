#!/usr/bin/env bash

set -euo pipefail

arch="$(uname -m | sed s/armv7l/armv7/)"
url="https://github.com/docker/compose/releases/latest/download/docker-compose-linux-${arch}"
td=$(mktemp -d)
curl -sL $url -o $td/docker-compose
install -Dm 755 $td/docker-compose ~/.docker/cli-plugins/docker-compose
rm -rf $td

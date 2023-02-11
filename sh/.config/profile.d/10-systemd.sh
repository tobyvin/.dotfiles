#!/bin/sh
# shellcheck disable=2046

export $(run-parts /usr/lib/systemd/user-environment-generators | xargs)

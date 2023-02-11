#!/bin/sh

export $(run-parts /usr/lib/systemd/user-environment-generators | xargs)

#!/bin/sh

GPG_AGENT_SOCK="$(gpgconf --list-dirs agent-socket)"
SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

export GPG_AGENT_SOCK SSH_AUTH_SOCK

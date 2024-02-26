#!/bin/sh

GPG_AGENT_SOCK="$(gpgconf --list-dirs agent-socket)"
export GPG_AGENT_SOCK

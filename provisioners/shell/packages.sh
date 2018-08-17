#!/bin/bash

set -e

sudo apt-get update

# Common packages across all versions
DEPS="
    apt-show-versions
    unzip
    unrar
    htop
    ifstat
    coreutils
    tree
    jq
    aria2
    gdb
    ruby2.5
    "

# Install basic packages
for dep in $DEPS; do
    if ! dpkg -s $dep > /dev/null 2>&1; then
    echo "Attempting installation of missing package: $dep"
    set -x
    sudo apt-get install -y $dep
    set +x
    fi
done

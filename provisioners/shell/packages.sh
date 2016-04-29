#!/bin/bash

set -e

# Do software and security update
sudo apt-get update && sudo apt-get upgrade -y

DEPS="
    apt-show-versions
    ntp
    unzip
    unrar
    htop
    ifstat
    realpath
    tree
    jq
    aria2
    ruby2.0
    "

# Install basic packages
for DEP in $DEPS; do
    if ! dpkg -s $DEP > /dev/null 2>&1; then
    echo "Attempting installation of missing package: $DEP"
    set -x
    sudo apt-get install -y $DEP
    set +x
    fi
done

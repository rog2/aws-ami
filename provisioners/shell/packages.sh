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
    python3-pip
    python3-boto
    python3-boto3
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

# Upgrade packages on demand
echo "Upgrading package: pip"
sudo python3 -m pip install --upgrade pip

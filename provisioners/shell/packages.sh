#!/bin/bash

set -e

# Do software and security update
sudo apt-get update && sudo apt-get upgrade -y

# Common packages across all versions
DEPS="
    apt-show-versions
    unzip
    unrar
    htop
    ifstat
    realpath
    tree
    jq
    aria2
    gdb
    "

# Version specific packages
DEPS_TRUSTY="
    ruby2.0
    "
DEPS_XENIAL="
    ruby2.3
    "
DEPS_BIONIC="
    ruby2.5
    "

CODENAME=$(lsb_release -s -c)

if [ "$CODENAME" = "xenial" ]; then
    DEPS="$DEPS $DEPS_XENIAL"
elif [ "$CODENAME" = "bionic" ]; then
    DEPS="$DEPS $DEPS_BIONIC"
else
    DEPS="$DEPS $DEPS_TRUSTY"
fi

# Install basic packages
for dep in $DEPS; do
    if ! dpkg -s $dep > /dev/null 2>&1; then
    echo "Attempting installation of missing package: $dep"
    set -x
    sudo apt-get install -y $dep
    set +x
    fi
done

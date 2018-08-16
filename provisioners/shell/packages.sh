#!/bin/bash

set -e

sudo apt-get update
# https://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt?answertab=active#tab-top
# the default answer is “keep the existing file”
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# remove realpath, and coreutils instead in ubuntu 18.04

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
    "

# Version specific packages
DEPS_TRUSTY="
    ruby2.0
    "
DEPS_XENIAL="
    ruby2.3
    "
# https://packages.ubuntu.com/bionic/ruby
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

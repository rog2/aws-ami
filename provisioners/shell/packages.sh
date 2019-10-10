#!/bin/bash

set -e

sudo apt-get update

# Common packages across all versions
DEPS="
  linux-tools-aws
  apt-show-versions
  nvme-cli
  unzip
  unrar
  htop
  ifstat
  sysstat
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
  if [[ "! dpkg -s $dep > /dev/null 2>&1" ]]; then
    echo "Attempting installation of missing package: $dep"
    set -x
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q $dep
    set +x
  fi
done

# Uninstall amazon-ssm-agent, which comes with Ubuntu 18.04 AMI via snap.
sudo snap remove amazon-ssm-agent

# Uninstall snapd, which is not used by us.
sudo apt-get purge -y snapd

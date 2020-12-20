#!/bin/bash

set -e

# Installs Nginx package with instructions in:
# https://nginx.org/en/linux_packages.html
#
# NOTE: Run this script as ROOT

# Not using /etc/apt/sources.list because it's written by cloud-init on first boot of an instance,
# so modifications made there will not survive a re-bundle.
readonly APT_SOURCE_FILE='/etc/apt/sources.list.d/nginx.list'
readonly CODENAME=$(lsb_release -cs)

if [[ "$EUID" -ne 0 ]]
  then echo "Please run as root."
  exit 1
fi

echo "Ubuntu Codename is $CODENAME"

echo 'Adding nginx signing key ...'
wget -q -O - https://nginx.org/keys/nginx_signing.key | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -

echo 'Adding nginx repository to apt source list ...'
echo '# Stable version' >> $APT_SOURCE_FILE
echo "deb https://nginx.org/packages/ubuntu/ $CODENAME nginx" >> "$APT_SOURCE_FILE"
echo "deb-src https://nginx.org/packages/ubuntu/ $CODENAME nginx" >> "$APT_SOURCE_FILE"

echo 'Installing nginx by apt-get ...'
apt-get -y update
apt-get -y install nginx

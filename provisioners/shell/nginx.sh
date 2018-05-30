#!/bin/bash -ex

# Installs Nginx package with instructions in:
# https://nginx.org/en/linux_packages.html
#
# NOTE: Run this script as ROOT

# Not using /etc/apt/sources.list because it's written by cloud-init on first boot of an instance,
# so modifications made there will not survive a re-bundle.
APT_SOURCE_FILE='/etc/apt/sources.list.d/nginx.list'

CODENAME=$(lsb_release -cs)
echo "Ubuntu Codename is $CODENAME"

echo 'Adding nginx signing key ...'
wget -q -O - https://nginx.org/keys/nginx_signing.key | apt-key add -

echo 'Adding nginx repository to apt source list ...'
echo '# Stable version' >> $APT_SOURCE_FILE
echo "deb https://nginx.org/packages/ubuntu/ $CODENAME nginx" >> "$APT_SOURCE_FILE"
echo "deb-src https://nginx.org/packages/ubuntu/ $CODENAME nginx" >> "$APT_SOURCE_FILE"

echo 'Installing nginx by apt-get ...'
apt-get -y update
apt-get -y install nginx

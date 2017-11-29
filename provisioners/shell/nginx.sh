#!/bin/bash -ex

# Installs Nginx package with instructions in:
# http://nginx.org/en/linux_packages.html
#
# NOTE: Run this script as ROOT

TMP_DIR='/tmp/nginx-install'
CODENAME='trusty'
# Not using /etc/apt/sources.list because it's written by cloud-init on first boot of an instance,
# so modifications made there will not survive a re-bundle.
APT_SOURCE_FILE='/etc/apt/sources.list.d/nginx.list'

if [ -d $TMP_DIR ]; then
    rm -rf $TMP_DIR
fi

mkdir -p $TMP_DIR && cd $TMP_DIR

echo 'Adding nginx signing key ...'
wget -q -O - http://nginx.org/keys/nginx_signing.key | apt-key add -

echo 'Adding nginx repository to apt source list ...'
echo '# nginx repository' >> $APT_SOURCE_FILE
echo "deb http://nginx.org/packages/ubuntu/ $CODENAME nginx" >> "$APT_SOURCE_FILE"
echo "deb-src http://nginx.org/packages/ubuntu/ $CODENAME nginx" >> "$APT_SOURCE_FILE"

echo 'Installing nginx by apt-get ...'
apt-get -y update
apt-get -y install nginx

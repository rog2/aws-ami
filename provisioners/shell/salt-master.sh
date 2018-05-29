#!/bin/bash -e

CONFIG_DIR=/etc/salt/master.d

# https://docs.saltstack.com/en/latest/topics/tutorials/salt_bootstrap.html

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "No salt version specified, using latest stable release version."
else
    echo "Installing salt-master and salt-api at version $VERSION..."
fi

curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
sudo sh bootstrap-salt.sh -N -M stable $VERSION

sudo apt-get install salt-api -y

echo 'Create user saltapi to access salt-api...'
sudo useradd -M -s /sbin/nologin saltapi
echo "saltapi:saltapi" |sudo chpasswd

echo 'Configurate salt-master...'
sudo mkdir -p $CONFIG_DIR && cd "$CONFIG_DIR"

sudo cat <<EOM > api.conf
rest_cherrypy:
  port: 8686
  disable_ssl: True
EOM

sudo cat <<EOM > eauth.conf
external_auth:
  pam:
    saltapi:
      - .*
      - '@runner'
      - '@wheel'
EOM

sudo cat <<EOM > worker_threads.conf
worker_threads: 16
EOM

echo 'Disable salt-master & salt-api...'
sudo systemctl disable salt-master.service
sudo systemctl disable salt-api.service

echo 'Salt installed.'
salt-master --version
salt-api --version

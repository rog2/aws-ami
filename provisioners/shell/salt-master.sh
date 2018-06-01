#!/bin/bash -e

# https://docs.saltstack.com/en/latest/topics/tutorials/salt_bootstrap.html

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "No salt version specified, using latest stable release version."
else
    echo "Installing salt-master and salt-api at version $VERSION..."
fi

curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
sudo sh bootstrap-salt.sh -N -M -L stable $VERSION

sudo apt-get install salt-api -y

echo 'Disable salt-master & salt-api...'
sudo systemctl disable salt-master.service
sudo systemctl disable salt-api.service

echo 'Salt installed.'
salt --versions-report

#!/bin/bash -e

VERSION=$1
if [ -z "$VERSION" ]; then
    echo "No salt-minion version specified, using latest stable release version."
else
    echo "Installing salt minion at version $VERSION"
fi

curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
sudo sh bootstrap-salt.sh -P stable $VERSION

# disable salt-minion by default
sudo systemctl disable salt-minion.service

sudo rm -f /etc/salt/minion_id

echo 'Salt installed.'
salt-minion --version

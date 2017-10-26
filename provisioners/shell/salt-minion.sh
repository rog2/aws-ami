#!/bin/bash -ex

MASTER=$1
MASTER_CONFIG_FILE=/etc/salt/minion.d/master.conf

# echo 'Installing salt ...'

# curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
# sudo sh bootstrap-salt.sh git develop
sudo apt-get install salt-minion -y
sudo touch "$MASTER_CONFIG_FILE"
echo "master: $MASTER" | sudo tee "$MASTER_CONFIG_FILE"

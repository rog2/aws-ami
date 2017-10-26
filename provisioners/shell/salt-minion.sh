#!/bin/bash -ex

MASTER_ADDR=$1
MASTER_CONFIG_FILE=/etc/salt/minion.d/master.conf

SALT_REPO_CONFIG_FILE=/etc/apt/sources.list.d/saltstack.list

# echo 'Installing salt ...'

wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
sudo touch "$SALT_REPO_CONFIG_FILE"
echo 'deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main' | sudo tee "$SALT_REPO_CONFIG_FILE"
sudo apt-get update

# curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
# sudo sh bootstrap-salt.sh git develop
sudo apt-get install salt-minion -y
sudo touch "$MASTER_CONFIG_FILE"
echo "master: $MASTER_ADDR" | sudo tee "$MASTER_CONFIG_FILE"

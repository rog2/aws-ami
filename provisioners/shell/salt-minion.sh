#!/bin/bash -ex

SALT_REPO_CONFIG_FILE=/etc/apt/sources.list.d/saltstack.list

# echo 'Installing salt ...'

OS_VERSION=$(lsb_release -r -s)

if [ "$OS_VERSION" == "16.04" ]; then
    REPO_KEY='https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub'
    REPO_SOURCE='deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main'
elif [ "$OS_VERSION" == "14.04" ]; then
    REPO_KEY='https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest/SALTSTACK-GPG-KEY.pub'
    REPO_SOURCE='deb http://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest trusty main'
else
    echo "OS version not supported. Currently only support 14.04 and 16.04. Version: $OS_VERSION"
    exit 1
fi

wget -O - "$REPO_KEY" | sudo apt-key add -
sudo touch "$SALT_REPO_CONFIG_FILE"
echo "$REPO_SOURCE" | sudo tee "$SALT_REPO_CONFIG_FILE"
sudo apt-get update

# curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
# sudo sh bootstrap-salt.sh git develop
sudo apt-get install salt-minion -y

# disable salt-minion by default
sudo systemctl disable salt-minion.service

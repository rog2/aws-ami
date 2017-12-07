#!/bin/bash -e

# https://repo.saltstack.com/#ubuntu
echo 'Installing salt-cloud...'

wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
echo 'deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main' | sudo tee /etc/apt/sources.list.d/saltstack.list
sudo apt-get update
sudo apt-get install salt-cloud -y
salt-cloud --version

echo 'Install complete. Please upload salt-cloud configurations and ssh key.'

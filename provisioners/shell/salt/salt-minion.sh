#!/bin/bash -e

# https://repo.saltstack.com/#ubuntu

# Depends on salt-repo has been configurated.

sudo apt-get update && sudo apt-get install salt-minion -y

# disable salt-minion by default
sudo systemctl disable salt-minion.service

sudo rm -f /etc/salt/minion_id

echo 'Salt installed.'
salt-minion --version

#!/bin/bash -e

# https://repo.saltstack.com/#ubuntu

# Depends on salt-repo has been configurated.

sudo apt-get update && sudo apt-get install salt-master salt-api salt-cloud -y

echo 'Disable salt-master & salt-api...'
sudo systemctl disable salt-master.service
sudo systemctl disable salt-api.service

echo 'Salt installed.'
salt --versions-report

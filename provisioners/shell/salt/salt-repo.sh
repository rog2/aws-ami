#!/bin/bash

set -e

# https://repo.saltstack.com/#ubuntu

wget -O - https://repo.saltstack.com/py3/ubuntu/18.04/amd64/2018.3/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
sudo tee "/etc/apt/sources.list.d/saltstack.list" << EOF
# Ubuntu 18 (bionic) PY3
deb https://repo.saltstack.com/py3/ubuntu/18.04/amd64/2018.3 bionic main
EOF

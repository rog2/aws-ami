#!/bin/bash -e

# https://repo.saltstack.com/#ubuntu

wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
echo 'deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main' | sudo tee /etc/apt/sources.list.d/saltstack.list

echo 'Installing salt-master & salt-api...'
sudo apt-get update
sudo apt-get install salt-master -y
sudo apt-get install salt-api -y

salt-master --version
salt-api --version

echo 'Installing REST_CHERRYPY 3.2.3'
# https://docs.saltstack.com/en/develop/ref/netapi/all/salt.netapi.rest_cherrypy.html

echo 'CherryPy current version:'
pip show cherrypy 2>/dev/null |grep ^Version

echo 'Uninstall current CherryPy...'
sudo apt-get remove python-cherrypy3 -y

echo 'Installing CherryPy v3.2.3 ...'
sudo pip install cherrypy==3.2.3

echo 'CherryPy version after update...'
pip show cherrypy 2>/dev/null |grep ^Version

echo 'Restarting salt-master & salt-api...'
sudo systemctl restart salt-master.service
sudo systemctl restart salt-api.service

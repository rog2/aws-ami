#!/bin/bash -ex

#
# Install salt master on Ubuntu Server, and configure it to be a daemon service.
#
SALTPAD_LOCATION=/data/www

SALT_KEY=https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest/SALTSTACK-GPG-KEY.pub
SALT_SOURCES='http://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest trusty main'
SALTPAD_SOURCES=https://github.com/Lothiraldan/saltpad/releases/download/v0.3.1/dist.zip
SALTPAD_ZIP=dist.zip
SALTPAD_ZIP_NAME=dist
SALTPAD_NAME=saltpad


echo 'Install salt-master...'


wget -O - $SALT_KEY | sudo apt-key add -

echo deb $SALT_SOURCES | sudo tee /etc/apt/sources.list.d/saltstack.list

sudo apt-get -y update

sudo apt-get -y install salt-api salt-master salt-cloud  salt-ssh salt-syndic


echo 'Install saltpad...'

wget $SALTPAD_SOURCES

unzip $SALTPAD_ZIP

mv $SALTPAD_ZIP_NAME $SALTPAD_NAME

if [ ! -d $SALTPAD_LOCATION ]; then
    sudo  mkdir -p $SALTPAD_LOCATION
fi

sudo cp -R $SALTPAD_NAME $SALTPAD_LOCATION

#!/bin/bash -ex

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update

# Automated installation (auto accept license)
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | \
    sudo /usr/bin/debconf-set-selections

sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install oracle-java8-set-default

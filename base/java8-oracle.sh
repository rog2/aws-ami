#!/bin/bash -ex

# Add the PPA repository
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update

# The installer requires you to accept the Oracle license before the installation begins.
# This is for automated installation (auto accept license)
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | \
    sudo /usr/bin/debconf-set-selections

# Install the Oracle JDK
sudo apt-get -y install oracle-java8-installer

# Set up Java environment variables
sudo apt-get -y install oracle-java8-set-default

#!/bin/bash -ex

# Do software and security update
sudo apt-get update && sudo apt-get upgrade -y

# Install basic packages
sudo apt-get -y install ntp unzip apt-show-versions ruby2.0

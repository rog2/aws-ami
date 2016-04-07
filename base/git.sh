#!/bin/bash -ex

# Install latest stable Git

sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get -y install git

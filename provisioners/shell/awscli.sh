#!/bin/bash

set -ex

sudo apt-get -y install python3-pip

# Install AWS CLI using pip3
# To upgrade an existing AWS CLI installation, use the --upgrade option: sudo pip3 install --upgrade awscli
sudo pip3 install awscli

# Enable Command Completion for AWS CLI
echo 'complete -C $(which aws_completer) aws' >> ~/.bash_completion

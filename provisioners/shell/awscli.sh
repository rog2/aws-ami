#!/bin/bash -ex

# sudo apt-get -y install python-pip
# sudo apt-get -y install python3-pip
# Install AWS CLI using pip
# To upgrade an existing AWS CLI installation, use the --upgrade option:
#   sudo pip install --upgrade awscli
# sudo -H pip3 install awscli

sudo apt-get update
sudo apt-get install -y awscli

# Enable Command Completion for AWS CLI
echo 'complete -C $(which aws_completer) aws' >> ~/.bash_completion

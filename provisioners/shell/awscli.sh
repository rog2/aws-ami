#!/bin/bash -ex

# Install AWS CLI using pip
# To upgrade an existing AWS CLI installation, use the --upgrade option:
# sudo pip install --upgrade awscli
sudo apt update
sudo apt install -y python-pip

sudo pip install --timeout=300 awscli
# sudo apt-get update
# sudo apt-get install -y awscli

# Enable Command Completion for AWS CLI
echo 'complete -C $(which aws_completer) aws' >> ~/.bash_completion

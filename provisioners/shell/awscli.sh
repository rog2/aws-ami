#!/bin/bash -ex


sudo mkdir ~/.pip
sudo chmod -R a+w ~/.pip
echo -e '[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple\n[install]\ntrusted-host=mirrors.aliyun.com' >> ~/.pip/pip.conf

sudo apt-get -y install python3-pip

# Install AWS CLI using pip
# To upgrade an existing AWS CLI installation, use the --upgrade option:
# sudo pip install --upgrade awscli
sudo pip3 install awscli

# sudo apt-get update
# sudo apt-get install -y awscli

# Enable Command Completion for AWS CLI
echo 'complete -C $(which aws_completer) aws' >> ~/.bash_completion

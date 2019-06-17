#!/bin/bash

set -e

sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q install python-setuptools

az=$(ec2metadata --availability-zone)

if [[ $az == cn-* ]]; then
    #https://docs.amazonaws.cn/en_us/AWSCloudFormation/latest/UserGuide/cfn-helper-scripts-reference.html 
    sudo python -m easy_install "https://s3.cn-north-1.amazonaws.com.cn/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz"
else
    sudo python -m easy_install "https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz"
fi

sudo ln /usr/local/bin/cfn-hup /etc/init.d/
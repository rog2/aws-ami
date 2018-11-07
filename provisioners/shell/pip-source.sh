#!/bin/bash -e

az=$(ec2metadata --availability-zone)
if [[ $az != cn-* ]]; then 
    exit 0
fi

mkdir ~/.pip

# Config cn pip source
tee ~/.pip/pip.conf << EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
EOF

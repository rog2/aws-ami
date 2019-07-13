#!/bin/bash

set -e

# Use pip mirror from tsinghua university if we are in China region,
# This works around network connectivity issue caused by the GFW.
readonly az=$(ec2metadata --availability-zone)

if [[ $az == cn-* ]]; then
  mkdir -p ~/.pip
  tee ~/.pip/pip.conf << EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
EOF
fi

echo "Upgrading pip:"
sudo python3 -m pip install --upgrade pip

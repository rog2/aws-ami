#!/bin/bash -x

sudo service td-agent status

if [ $? -eq 0 ]; then
    echo "td-agent is already installed. Skip reinstalling it."
    exit 0
fi

echo "Installing td-agent..."

curl -L https://td-toolbelt.herokuapp.com/sh/install-ubuntu-trusty-td-agent2.sh | sh

echo "Installing plugins..."

sudo td-agent-gem install fluent-plugin-s3
sudo td-agent-gem install fluent-plugin-elasticsearch

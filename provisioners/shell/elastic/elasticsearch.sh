#!/bin/bash

set -x

sudo systemctl status elasticsearch
if [[ $? -eq 0 ]]; then
  echo "elasticsearch is already installed. Skip reinstalling it."
  exit 0
fi

echo "Installing elasticsearch"
sudo apt-get install -y elasticsearch

#sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install x-pack

sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

sudo systemctl status elasticsearch

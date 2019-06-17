#!/bin/bash

set -x

sudo systemctl status kibana
if [[ $? -eq 0 ]]; then
  echo "kibana is already installed. Skip reinstalling it."
  exit 0
fi

echo "Installing kibana"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q kibana

#sudo /usr/share/kibana/bin/kibana-plugin install x-pack

sudo systemctl start kibana
sudo systemctl enable kibana

sudo systemctl status kibana

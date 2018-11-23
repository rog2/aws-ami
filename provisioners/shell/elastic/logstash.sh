#!/bin/bash

set -x

sudo systemctl status logstash
if [[ $? -eq 0 ]]; then
  echo "logstash is already installed. Skip reinstalling it."
  exit 0
fi

echo "Installing logstash"
sudo apt-get install -y logstash

echo "add logstash-output-amazon_es plugin"
sudo /usr/share/logstash/bin/logstash-plugin install logstash-output-amazon_es

echo "add logstash-filter-ruby plugin"
sudo /usr/share/logstash/bin/logstash-plugin install logstash-filter-ruby

sudo systemctl start logstash

# we shouldn't enable logstash until its config is updated
sudo systemctl disable logstash
#sudo systemctl enable logstash

sudo systemctl status logstash

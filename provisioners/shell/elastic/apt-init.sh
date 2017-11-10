#!/bin/bash

#Download and install the Public Signing Key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get update
sudo apt-get install apt-transport-https

#Save the repository definition to /etc/apt/sources.list.d/elastic-5.x.list
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list

sudo apt-get update

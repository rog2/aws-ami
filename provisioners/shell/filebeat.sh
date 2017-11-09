#!/bin/bash -x

sudo systemctl status filebeat
if [ $? -eq 0 ]; then
    echo "filebeat is already installed. Skip reinstalling it."
    exit 0
fi

echo "Installing filebeat"

#Download and install the Public Signing Key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get update
sudo apt-get install apt-transport-https

#Save the repository definition to /etc/apt/sources.list.d/elastic-5.x.list
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list

sudo apt-get install -y filebeat

sudo systemctl start filebeat
sudo systemctl enable filebeat

sudo systemctl status filebeat
if [ $? -eq 0 ]; then
    echo "filebeat is installed successfully"
    exit 0
else
    echo "Error found"
    exit 1
fi
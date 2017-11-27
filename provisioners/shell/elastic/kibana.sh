#!/bin/bash -x

sudo systemctl status kibana
if [ $? -eq 0 ]; then
    echo "kibana is already installed. Skip reinstalling it."
    exit 0
fi

echo "Installing kibana"
sudo apt-get install -y kibana

#sudo /usr/share/kibana/bin/kibana-plugin install x-pack

sudo systemctl start kibana
sudo systemctl enable kibana

sudo systemctl status kibana
exit $?
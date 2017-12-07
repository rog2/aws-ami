#!/bin/bash -x

sudo systemctl status filebeat
if [ $? -eq 0 ]; then
    echo "filebeat is already installed. Skip reinstalling it."
    exit 0
fi

echo "Installing filebeat"
sudo apt-get install -y filebeat

sudo systemctl start filebeat
sudo systemctl enable filebeat

sudo systemctl status filebeat
exit $?

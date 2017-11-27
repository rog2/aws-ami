#!/bin/bash -x

sudo systemctl status logstash
if [ $? -eq 0 ]; then
    echo "logstash is already installed. Skip reinstalling it."
    exit 0
fi

echo "Installing logstash"
sudo apt-get install -y logstash

#sudo /usr/share/logstash/bin/logstash-plugin install x-pack
sudo /usr/share/logstash/bin/logstash-plugin install logstash-filter-ruby

sudo systemctl start logstash
sudo systemctl enable logstash

sudo systemctl status logstash
exit $?
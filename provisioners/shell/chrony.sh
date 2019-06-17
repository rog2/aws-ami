#!/bin/bash

set -e

readonly AMAZON_NTP_IP=169.254.169.123
readonly CONF_FILE=/etc/chrony/chrony.conf

echo "Install Amazon Time Sync Service..."
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q chrony

echo "Configuring Amazon Time Sync Service..."

sudo sed -i '0,/^\(server\|pool\).*/s/^\(server\|pool\).*/server '"$AMAZON_NTP_IP"' prefer iburst\n&/' $CONF_FILE

echo "initstepslew 5 $AMAZON_NTP_IP" | sudo tee -a $CONF_FILE

echo "Restarting Amazon Time Sync Service..."
sudo systemctl restart chrony

echo "'Wait 30 seconds for chrony to restart..."
sleep 30

echo "Verifying Amazon Time Sync Service"
chronyc tracking | grep $AMAZON_NTP_IP &> /dev/null
echo "ok"

#!/bin/bash -e

# needs run as root.

AMAZON_NTP_IP=169.254.169.123
CONF_FILE=/etc/chrony/chrony.conf

if [ "$EUID" -ne 0 ]
    then echo "Please run as root."
    exit 1
fi

echo "Install Amazon Time Sync Service..."
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html
apt install chrony -y

echo "Configuring Amazon Time Sync Service..."

sed -i '0,/^\(server\|pool\).*/s/^\(server\|pool\).*/server '"$AMAZON_NTP_IP"' prefer iburst\n&/' $CONF_FILE

echo "initstepslew 5 $AMAZON_NTP_IP" >> $CONF_FILE

echo "Restarting Amazon Time Sync Service..."
systemctl restart chrony

echo "Verifying Amazon Time Sync Service..."
# waiting until source being determined
sleep 30
chronyc tracking |grep $AMAZON_NTP_IP &> /dev/null
echo "ok"

#!/bin/bash -e

# needs run as root.

echo "Install Amazon Time Sync Service..."
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html
apt install chrony -y

echo "Configuring Amazon Time Sync Service..."
CONF_FILE=/etc/chrony/chrony.conf

sed -i '0,/^\(server\|pool\).*/s/^\(server\|pool\).*/server 169.254.169.123 prefer iburst\n&/' $CONF_FILE

echo "Restarting Amazon Time Sync Service..."
/etc/init.d/chrony restart

echo "Verifying Amazon Time Sync Service..."
# waiting until source being determined
sleep 10
chronyc tracking |grep 169.254.169.123 &> /dev/null
echo "ok"

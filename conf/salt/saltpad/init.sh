#!/bin/bash
set -x

PUBLIC_IPV4=$(ec2metadata --public-ipv4)
API_URL="\"API_URL\""
SALTPAD_CONF=/data/www/saltpad/static/settings.json
API_URL_OLD=$(grep $API_URL $SALTPAD_CONF)
API_URL_NEW="  $API_URL:\"$PUBLIC_IPV4:8686\","

if [ -n "$API_URL_OLD=" ]; then
    sed -i "s/$API_URL_OLD/$API_URL_NEW/" $SALTPAD_CONF
fi

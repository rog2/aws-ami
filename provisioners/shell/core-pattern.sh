#!/bin/bash -e

# needs run as root.
CORE_PATTERN_CONF=/etc/sysctl.d/98-seasungames-core-pattern.conf

if [ "$EUID" -ne 0 ]
    then echo "Please run as root."
    exit 1
fi

echo 'Stopping and diabling apport service..'
systemctl stop apport.service
systemctl disable apport.service

echo 'Configuring core pattern...'
echo 'kernel.core_pattern=core.%p' > $CORE_PATTERN_CONF

sysctl -p $CORE_PATTERN_CONF

echo 'Validating core pattern...'
sysctl kernel.core_pattern
echo 'ok'

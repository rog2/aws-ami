#!/bin/bash -e

# needs run as root.
CORE_PATTERN_CONF=/etc/sysctl.d/98-seasungames-core-pattern.conf

echo 'Stopping and diabling apport service..'
sudo systemctl stop apport.service
sudo systemctl disable apport.service

echo 'Configuring core pattern...'
echo 'kernel.core_pattern=core.%p' | sudo tee $CORE_PATTERN_CONF

sudo sysctl -p $CORE_PATTERN_CONF

echo 'Validating core pattern...'
sudo sysctl kernel.core_pattern
echo 'ok'

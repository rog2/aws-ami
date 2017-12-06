#!/bin/bash -e

# needs run as root.
CORE_PATTERN_CONF=/etc/sysctl.d/98-core-pattern.conf

echo 'Stopping and diabling apport service..'
systemctl stop apport.service
/lib/systemd/systemd-sysv-install disable apport

echo 'Configuring core pattern...'
echo 'kernel.core_pattern=core.%p' > $CORE_PATTERN_CONF

sysctl -p $CORE_PATTERN_CONF

echo 'Validating core pattern...'
cat /proc/sys/kernel/core_pattern |grep 'core.%p'
echo 'ok'

#!/bin/bash

set -e

# echo 'Configuring journal storage...'
# Create /var/log/journal folder to make journal data can saved in. Please refer to journald.conf(5)
sudo mkdir -p /var/log/journal/

sudo systemd-tmpfiles --create --prefix /var/log/journal

# Tell journal daemon should not forward log messages to the syslog daemon, which will lower disk usage
sudo mkdir -p /etc/systemd/journald.conf.d/
sudo tee /etc/systemd/journald.conf.d/10-no-forward-to-syslog.conf << EOF
[Journal]
ForwardToSyslog=no
EOF

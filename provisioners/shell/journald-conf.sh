#!/bin/bash

set -ex

# echo 'Configuring journal storage...'
# Create /var/log/journal folder to make journal data can saved in. Please refer to journald.conf(5)
sudo mkdir -p /var/log/journal/

sudo systemd-tmpfiles --create --prefix /var/log/journal

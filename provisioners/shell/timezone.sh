#!/bin/bash -e

# needs run as root.

echo "Set timezone..."
sudo timedatectl set-timezone $TIMEZONE

sudo timedatectl status

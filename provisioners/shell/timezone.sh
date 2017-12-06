#!/bin/bash -e

# needs run as root.

timezone=$1

echo "Set timezone..."
timedatectl set-timezone $timezone

timedatectl status

#!/bin/bash -e

# needs run as root.

if [ "$EUID" -ne 0 ]
    then echo "Please run as root."
    exit 1
fi

timezone=$1

echo "Set timezone..."
timedatectl set-timezone $timezone

timedatectl status

#!/bin/bash -ex

# echo 'Creating user pirates...'

sudo useradd -d /home/pirates -s /bin/bash -m pirates

# echo 'Adding user to group systemd-journal...'

sudo usermod -a -G systemd-journal pirates

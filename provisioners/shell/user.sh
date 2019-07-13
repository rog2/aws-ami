#!/bin/bash

set -ex

# echo 'Creating user pirates...'

sudo adduser --system --group     \
  --disabled-login                \
  --no-create-home                \
  --home /nonexistent             \
  --shell /usr/sbin/nologin       \
  pirates

# echo 'Adding user to group systemd-journal...'

sudo usermod -a -G systemd-journal pirates

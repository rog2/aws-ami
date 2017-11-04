#!/bin/bash -ex

sudo mkdir -p /etc/systemd/system/apt-daily.timer.d
echo "[Timer]"$'\n'"Persistent=false" | sudo tee /etc/systemd/system/apt-daily.timer.d/persistent.conf
echo "[Timer]"$'\n'"OnBootSec=1h" | sudo tee /etc/systemd/system/apt-daily.timer.d/delay.conf
#!/bin/bash -ex

conf_path=/etc/systemd/system/apt-daily.timer.d
conf_file=$conf_path/boot.conf

sudo mkdir -p "$conf_path"
echo "[Timer]" | sudo tee "$conf_file"
echo "Persistent=false" | sudo tee "$conf_file" -a
echo "OnBootSec=1h" | sudo tee "$conf_file" -a
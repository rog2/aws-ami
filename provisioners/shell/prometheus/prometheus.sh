#!/bin/bash

set -e

function get_latest_release {
  local readonly arch=$(dpkg --print-architecture)
  curl -s https://api.github.com/repos/$1/releases/latest |
    grep browser_download_url |
    grep "linux-${arch}" |
    sed -E 's/.*"([^"]+)".*/\1/'
}

# Creates user prometheus if not exist
if [[ "! id -u prometheus > /dev/null 2>&1" ]]; then
  sudo adduser --system --group     \
    --disabled-login                \
    --no-create-home                \
    --home /nonexistent             \
    --shell /usr/sbin/nologin       \
    --gecos "Prometheus Monitoring" \
    prometheus
fi

download_url=$(get_latest_release prometheus/prometheus)
file_name=$(basename "$download_url")
folder_name=$(basename "$file_name" .tar.gz)

pushd /tmp
  wget "$download_url"
  tar zxfv "$file_name"

  # Binaries
  sudo cp -vf "$folder_name/prometheus" /usr/local/bin/
  sudo cp -vf "$folder_name/promtool" /usr/local/bin/

  # Configurations
  if [[ ! -d "/etc/prometheus" ]]; then
    sudo mkdir /etc/prometheus
    sudo cp "$folder_name/prometheus.yml" /etc/prometheus/
    sudo cp -r "$folder_name/consoles" /etc/prometheus/
    sudo cp -r "$folder_name/console_libraries" /etc/prometheus/
  fi

  # Data
  if [[ ! -d "/var/lib/prometheus" ]]; then
    sudo mkdir /var/lib/prometheus
    sudo chown prometheus:prometheus /var/lib/prometheus
  fi

  # Cleanup
  rm -rf "$file_name" "$folder_name"
popd

# Creates /etc/default config
sudo tee "/etc/default/prometheus" << EOF
# Set the command-line arguments to pass to the server.
ARGS="--config.file=/etc/prometheus/prometheus.yml \\
      --web.console.templates=/etc/prometheus/consoles \\
      --web.console.libraries=/etc/prometheus/console_libraries \\
      --storage.tsdb.path=/var/lib/prometheus/metrics/ \\
      --storage.tsdb.retention=15d \\
      --web.listen-address=0.0.0.0:9090 \\
      --log.level=info"
EOF

# Creates Systemd service
sudo tee "/etc/systemd/system/prometheus.service" << EOF
[Unit]
Description=Monitoring system and time series database
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Restart=always
User=prometheus
Group=prometheus
EnvironmentFile=/etc/default/prometheus
ExecStart=/usr/local/bin/prometheus \$ARGS
ExecReload=/bin/kill -HUP \$MAINPID
TimeoutStopSec=20s
SendSIGKILL=no

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus

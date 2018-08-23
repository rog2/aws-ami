#!/bin/bash

set -e

# Make file naming consistent with apt repository
NAME=prometheus-node-exporter
EXECUTABLE=/usr/local/bin/$NAME

get_latest_release() {
    curl -s https://api.github.com/repos/$1/releases/latest |
        grep browser_download_url |
        grep linux-amd64 |
        sed -E 's/.*"([^"]+)".*/\1/'
}

download_url=$(get_latest_release prometheus/node_exporter)
file_name=$(basename "$download_url")
folder_name=$(basename "$file_name" .tar.gz)

pushd /tmp
    wget "$download_url"
    tar zxfv "$file_name"
    sudo cp -vf "$folder_name/node_exporter" $EXECUTABLE
popd

# Creates user prometheus if not exist
if ! id -u prometheus > /dev/null 2>&1; then
    sudo adduser --system               \
        --disabled-login                \
        --no-create-home                \
        --home /nonexistent             \
        --shell /usr/sbin/nologin       \
        --gecos "Prometheus Monitoring" \
        prometheus
fi

# Creates Systemd service
sudo tee "/etc/systemd/system/$NAME.service" << EOF
[Unit]
Description=Prometheus exporter for machine metrics
Documentation=https://github.com/prometheus/node_exporter
Wants=network-online.target
After=network-online.target

[Service]
Restart=always
User=prometheus
Group=prometheus
EnvironmentFile=-/etc/default/$NAME
ExecStart=$EXECUTABLE \$ARGS

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $NAME
sudo systemctl start $NAME
sudo systemctl status $NAME

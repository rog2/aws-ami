#!/bin/bash

set -e

source "$BASH_HELPERS"

# Make file naming consistent with apt repository
readonly NAME=prometheus-node-exporter
readonly EXECUTABLE=/usr/local/bin/$NAME

readonly ARCH=$(dpkg --print-architecture)

readonly DOWNLOAD_URL=https://github.com/prometheus/node_exporter/releases/download/v"$NODE_EXPORTER_VERSION"/node_exporter-"$NODE_EXPORTER_VERSION".linux-$ARCH.tar.gz
readonly FILE_NAME=node_exporter-"$NODE_EXPORTER_VERSION".linux-$ARCH.tar.gz
readonly FOLDER_NAME=$(basename "$FILE_NAME" .tar.gz)

pushd /tmp
  http_download "$DOWNLOAD_URL" "$FILE_NAME"
  tar zxfv "$FILE_NAME"
  sudo cp -vf "$FOLDER_NAME/node_exporter" $EXECUTABLE
popd

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

# Creates Systemd service
sudo tee "/etc/systemd/system/${NAME}.service" << EOF
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

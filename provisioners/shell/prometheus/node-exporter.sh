#!/bin/bash

set -e

# Make file naming consistent with apt repository
NAME=prometheus-node-exporter
EXECUTABLE=/usr/local/bin/$NAME

download_url=https://github.com/prometheus/node_exporter/releases/download/v"$NODE_EXPORTER_VERSION"/node_exporter-"$NODE_EXPORTER_VERSION".linux-amd64.tar.gz
file_name=node_exporter-"$NODE_EXPORTER_VERSION".linux-amd64.tar.gz
folder_name=$(basename "$file_name" .tar.gz)

# S3 bucket in AWS China region as a file mirror,
# which works around network connectivity issue caused by the GFW
function download {
    local readonly url="$1"
    local readonly local_path="$2"
    local readonly az=$(ec2metadata --availability-zone)
    if [[ $az != cn-* ]]; then
        curl -o "$local_path" "$url" --location --silent --fail --show-error
    else
        local readonly s3_uri="s3://dl.seasungames.com/${url#https://}"
        aws s3 cp "$s3_uri" "$local_path" --region cn-north-1
    fi
}

pushd /tmp
    download "$download_url" "$file_name"
    tar zxfv "$file_name"
    sudo cp -vf "$folder_name/node_exporter" $EXECUTABLE
popd

# Creates user prometheus if not exist
if ! id -u prometheus > /dev/null 2>&1; then
    sudo adduser --system --group       \
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

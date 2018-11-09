#!/bin/bash -ex
#
# Installs Consul by Hashicorp
#

CONSUL_VERSION=1.3.0

CONSUL_DOWNLOAD_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"
CONSUL_ZIP_FILE=$(basename "${CONSUL_DOWNLOAD_URL}")

CONSUL_USER=consul
CONSUL_BIN_DIR=/usr/local/bin
CONSUL_CONFIG_DIR=/etc/consul.d
CONSUL_DATA_DIR=/var/lib/consul

# ==============================================================================

function download() {
    az=$(ec2metadata --availability-zone)
    if [[ $az != cn-* ]]; then
        wget "$1"
    else
        MIRROR_S3_BUCKET=rog2
        MIRROR_S3_PREFIX=file-mirror
        MIRROR_S3_REGION=cn-north-1
        s3_uri="s3://${MIRROR_S3_BUCKET}/${MIRROR_S3_PREFIX}/${CONSUL_DOWNLOAD_URL#https://}"
        aws s3 cp "${s3_uri}" . --region ${MIRROR_S3_REGION}
    fi
}

pushd /tmp
    download "${CONSUL_DOWNLOAD_URL}"
    unzip -o "${CONSUL_ZIP_FILE}"
    sudo mkdir -p ${CONSUL_BIN_DIR}
    sudo cp -vf consul ${CONSUL_BIN_DIR}
popd

# Creates user consul if not exist
if ! id -u ${CONSUL_USER} > /dev/null 2>&1; then
    sudo adduser --system --group       \
        --disabled-login                \
        --no-create-home                \
        --home /nonexistent             \
        --shell /usr/sbin/nologin       \
        --gecos "Consul by HashiCorp" \
        ${CONSUL_USER}
fi

if [ -d ${CONSUL_CONFIG_DIR} ]; then
    sudo rm -rf ${CONSUL_CONFIG_DIR}
fi
sudo mkdir -p ${CONSUL_CONFIG_DIR}

if [ -d ${CONSUL_DATA_DIR} ]; then
    sudo rm -rf ${CONSUL_DATA_DIR}
fi
sudo mkdir -p ${CONSUL_DATA_DIR}
sudo chown ${CONSUL_USER}:${CONSUL_USER} ${CONSUL_DATA_DIR}

consul version

# Ask systemd-resolved to forward 'consul' domain queries to localhost consul.service
# See: https://www.consul.io/docs/guides/forwarding.html#systemd-resolved-setup
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo tee /etc/systemd/resolved.conf.d/consul.conf << EOF
[Resolve]
DNS=127.0.0.1
Domains=~consul
EOF

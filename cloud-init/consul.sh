#!/bin/bash
#
# Initialize and start consul.service at EC2 instance launch
# See: https://www.consul.io/docs/agent/cloud-auto-join.html#amazon-ec2
#
# This script should be installed to cloud-init directory:
# /var/lib/cloud/scripts/per-instance/
#

set -e

CONSUL_TAG_KEY=consul-cluster
CONSUL_CONFIG_DIR=/etc/consul.d

instance_id=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .instanceId -r)
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)

consul_tag_value=$(aws ec2 describe-instances \
    --instance-ids $instance_id \
    --region $region \
    --query "Reservations[].Instances[].Tags[?Key==\`${CONSUL_TAG_KEY}\`].Value" | jq .[][] -r)

if [ -z "$consul_tag_value" ]; then
    echo "EC2 has no tag_key '${CONSUL_TAG_KEY}', skip initializing consul service."
    exit 1
fi

echo "EC2 should auto-join consul cluster: tag_key=${CONSUL_TAG_KEY} tag_value=${consul_tag_value}"

sed -i "s/__CONSUL_TAG_VALUE__/${consul_tag_value}/" ${CONSUL_CONFIG_DIR}/*.json

systemctl daemon-reload
systemctl enable consul.service
systemctl start consul.service

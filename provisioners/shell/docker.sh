#!/bin/bash

# Instructions from
# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce

set -e

source "$BASH_HELPERS"

assert_not_empty "DOCKER_VERSION" "$DOCKER_VERSION"

log_info "Start installing docker $DOCKER_VERSION"

log_info "Add Docker's official GPG Key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

log_info "Add Docker's apt repository (stable)"
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

log_info 'Verify apt-key fingerprint'
apt-key fingerprint 0EBFCD88

log_info 'apt-get update'
sudo apt-get update

readonly docker_version=$(apt-cache madison docker-ce | grep $DOCKER_VERSION | head -1 | awk '{print $3}')
log_info "Installing docker-ce=$docker_version"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q docker-ce=$docker_version

log_info 'Pin docker-ce to current version'
sudo apt-mark hold docker-ce docker-ce-cli

log_info 'Add current user to docker group'
sudo gpasswd -a $USER docker

log_info "Docker install complete!"

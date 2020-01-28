#!/bin/bash

set -e

source "$BASH_HELPERS"

# https://github.com/corretto/corretto-11/releases
# https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html
function install {
  assert_not_empty "JAVA_VERSION" "$JAVA_VERSION"
  local readonly version="$JAVA_VERSION"
  local readonly arch=$(dpkg --print-architecture)
  local readonly download_url="https://corretto.aws/downloads/resources/${version/-/.}/java-11-amazon-corretto-jdk_${version}_${arch}.deb"
  local readonly download_path="/tmp/$(basename "$download_url")"
  http_download "$download_url" "$download_path"
  sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q java-common
  sudo dpkg --install "$download_path"
}

install "$@"

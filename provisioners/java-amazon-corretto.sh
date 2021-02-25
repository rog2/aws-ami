#!/bin/bash

# Amazon Corretto 8
# https://github.com/corretto/corretto-8/releases
# https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/downloads-list.html
#
# Amazon Corretto 11
# https://github.com/corretto/corretto-11/releases
# https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html

set -e

source "$BASH_HELPERS"

function pkg_name {
  local readonly version="$1"
  if [[ "$version" = 8.* ]]; then
    echo "java-1.8.0-amazon-corretto-jdk"
  elif [[ "$version" = 11.* ]]; then
    echo "java-11-amazon-corretto-jdk"
  else
    log_error "Unsupported Amazon Corretto version: $version"
    echo ""
  fi
}

function install {
  assert_not_empty "JAVA_VERSION" "$JAVA_VERSION"
  local readonly version="$JAVA_VERSION"
  local readonly pkg=$(pkg_name "$JAVA_VERSION")
  assert_not_empty "pkg" "$pkg"
  local readonly arch=$(dpkg --print-architecture)
  local readonly download_url="https://corretto.aws/downloads/resources/${version/-/.}/${pkg}_${version}_${arch}.deb"
  local readonly download_path="/tmp/$(basename "$download_url")"
  http_download "$download_url" "$download_path"
  sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q java-common
  sudo dpkg --install "$download_path"
}

install "$@"

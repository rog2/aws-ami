#!/bin/bash

set -e

source "$BASH_HELPERS"

readonly DOWNLOAD_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
readonly LOCAL_PATH="/tmp/awscliv2.zip"

# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
function install_awscliv2 {
  echo "Downloading awscliv2 from $DOWNLOAD_URL"
  http_download "$DOWNLOAD_URL" "$LOCAL_PATH"
  pushd "$(dirname "$LOCAL_PATH")"
    unzip -q "$LOCAL_PATH"
    sudo ./aws/install
  popd
}

# Enable Command Completion for AWS CLI v2
function install_aws_completer {
  echo 'complete -C $(which aws_completer) aws' >> ~/.bash_completion
}

install_awscliv2
install_aws_completer

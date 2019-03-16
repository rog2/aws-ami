#!/bin/bash

set -e

readonly INSTALL_DIR=/usr/lib/jvm
readonly DOWNLOAD_URL=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-"$JAVA_VERSION"_linux-x64_bin.tar.gz
readonly FILE_NAME=openjdk-"$JAVA_VERSION"_linux-x64_bin.tar.gz
readonly FOLDER_NAME=jdk-$JAVA_VERSION

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

cd /tmp
if [[ ! -e $FILE_NAME ]]; then
  download $DOWNLOAD_URL $FILE_NAME
fi
sudo mkdir -p $INSTALL_DIR
sudo tar -zxf $FILE_NAME -C $INSTALL_DIR --no-same-owner

sudo mkdir -p /usr/local/bin

for bin in $INSTALL_DIR/$FOLDER_NAME/bin/*; do
  sudo update-alternatives --install /usr/local/bin/$(basename $bin) $(basename $bin) $bin 100;
  sudo update-alternatives --set $(basename $bin) $bin;
done

#!/bin/bash

set -e

# This script needs run as ROOT.
download_url=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-"$JAVA_VERSION"_linux-x64_bin.tar.gz
file_name=openjdk-"$JAVA_VERSION"_linux-x64_bin.tar.gz
folder_name=jdk-$JAVA_VERSION

function download {
    # S3 bucket in AWS China region as a file mirror,
    # which works around network connectivity issue caused by the GFW
    local readonly CN_MIRROR_S3_BUCKET=rog2
    local readonly CN_MIRROR_S3_PREFIX=file-mirror
    local readonly CN_MIRROR_S3_REGION=cn-north-1

    local readonly url="$1"
    local readonly az=$(ec2metadata --availability-zone)

    if [[ $az != cn-* ]]; then
        curl -o $(basename "$url") "$url" --location --silent --fail --show-error
    else
        local readonly s3_uri="s3://${CN_MIRROR_S3_BUCKET}/${CN_MIRROR_S3_PREFIX}/${url#https://}"
        aws s3 cp "${s3_uri}" . --region ${CN_MIRROR_S3_REGION}
    fi
}

cd /tmp
if [ ! -e $file_name ]; then
    download $download_url
fi
sudo mkdir -p /opt/java
sudo tar -zxf $file_name -C /opt/java --no-same-owner

sudo mkdir -p /usr/local/bin

for bin in /opt/java/$folder_name/bin/*; do
    sudo update-alternatives --install /usr/local/bin/$(basename $bin) $(basename $bin) $bin 100;
    sudo update-alternatives --set $(basename $bin) $bin;
done

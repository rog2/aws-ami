#!/bin/bash -ex

# This script needs run as ROOT.
JAVA_VERSION=11.0.1
SOURCE_URL=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-"$JAVA_VERSION"_linux-x64_bin.tar.gz
SOURCE_FILE=openjdk-"$JAVA_VERSION"_linux-x64_bin.tar.gz
SOURCE_FOLDER_NAME=jdk-$JAVA_VERSION

download() {
    az=$(ec2metadata --availability-zone)
    if [[ $az != cn-* ]]; then
        wget "$SOURCE_URL"
    else
        MIRROR_S3_BUCKET=rog2
        MIRROR_S3_PREFIX=file-mirror
        MIRROR_S3_REGION=cn-north-1
        s3_uri="s3://${MIRROR_S3_BUCKET}/${MIRROR_S3_PREFIX}/${SOURCE_URL#https://}"
        aws s3 cp "${s3_uri}" . --region ${MIRROR_S3_REGION}
    fi
}

cd /tmp
if [ ! -e $SOURCE_FILE ]; then
    download
fi
mkdir -p /opt/java
tar -zxf $SOURCE_FILE -C /opt/java --no-same-owner

mkdir -p /usr/local/bin

for bin in /opt/java/$SOURCE_FOLDER_NAME/bin/*; do
    update-alternatives --install /usr/local/bin/$(basename $bin) $(basename $bin) $bin 100;
    update-alternatives --set $(basename $bin) $bin;
done

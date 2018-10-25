#!/bin/bash -ex

JAVA_VERSION=11.0.1
SOURCE_URL=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-"$JAVA_VERSION"_linux-x64_bin.tar.gz
SOURCE_FILE=openjdk-"$JAVA_VERSION"_linux-x64_bin.tar.gz
SOURCE_FOLDER_NAME=jdk-$JAVA_VERSION

cd /tmp
if [ ! -e $SOURCE_FILE ]; then
    wget $SOURCE_URL
fi
mkdir -p /opt/java
tar -zxf $SOURCE_FILE -C /opt/java

mkdir -p /usr/local/bin

for bin in /opt/java/$SOURCE_FOLDER_NAME/bin/*; do
    update-alternatives --install /usr/local/bin/$(basename $bin) $(basename $bin) $bin 100;
    update-alternatives --set $(basename $bin) $bin;
done

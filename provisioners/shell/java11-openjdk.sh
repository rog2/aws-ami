#!/bin/bash -ex

JAVA_VERSION=11.0.1
SOURCE_URL=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-"$JAVA_VERSION"_linux-x64_bin.tar.gz
SOURCE_FILE=openjdk-"$JAVA_VERSION"_linux-x64_bin.tar.gz
SOURCE_FOLDER_NAME=jdk-$JAVA_VERSION

PROFILE_FILE=/etc/profile.d/openjdk-11.sh

cd /tmp
if [ ! -e $SOURCE_FILE ]; then
    wget $SOURCE_URL
fi
tar -zxf $SOURCE_FILE
mkdir -p /opt/java/$SOURCE_FOLDER_NAME
sudo mv $SOURCE_FOLDER_NAME /opt/java/

sudo touch $PROFILE_FILE
sudo chmod 644 $PROFILE_FILE

sudo tee "$PROFILE_FILE" << EOF
export JAVA_HOME=/opt/java/jdk-$JAVA_VERSION
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

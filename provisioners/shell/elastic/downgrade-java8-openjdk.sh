#!/bin/bash

set -ex

sudo apt -y install openjdk-8-jdk
sudo apt -y install icedtea-8-plugin
sudo update-java-alternatives --set /usr/lib/jvm/java-1.8.0-openjdk-amd64

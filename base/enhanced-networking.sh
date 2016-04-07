#!/bin/bash -ex

# Enables Enhanced Networking on Ubuntu Server
#
# See: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/enhanced-networking.html#enhanced-networking-ubuntu

VERSION='2.16.4'
FOLDER="ixgbevf-$VERSION"
FILE="$FOLDER.tar.gz"
DOWNLOAD_URL="http://sourceforge.net/projects/e1000/files/ixgbevf%20stable/$VERSION/$FILE"
DKMS_CONF="/usr/src/$FOLDER/dkms.conf"

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y dkms

cd /tmp
wget "$DOWNLOAD_URL"
tar -zxf $FILE
sudo mv $FOLDER /usr/src/

sudo touch $DKMS_CONF

echo 'PACKAGE_NAME="ixgbevf"'       | sudo tee -a $DKMS_CONF
echo "PACKAGE_VERSION=\"$VERSION\"" | sudo tee -a $DKMS_CONF
echo 'CLEAN="cd src/; make clean"'  | sudo tee -a $DKMS_CONF
echo 'MAKE="cd src/; make BUILD_KERNEL=${kernelver}"' | sudo tee -a $DKMS_CONF
echo 'BUILT_MODULE_LOCATION[0]="src/"'      | sudo tee -a $DKMS_CONF
echo 'BUILT_MODULE_NAME[0]="ixgbevf"'       | sudo tee -a $DKMS_CONF
echo 'DEST_MODULE_LOCATION[0]="/updates"'   | sudo tee -a $DKMS_CONF
echo 'DEST_MODULE_NAME[0]="ixgbevf"'        | sudo tee -a $DKMS_CONF
echo 'AUTOINSTALL="yes"'                    | sudo tee -a $DKMS_CONF

sudo dkms add -m ixgbevf -v "$VERSION"
sudo dkms build -m ixgbevf -v "$VERSION"
sudo dkms install -m ixgbevf -v "$VERSION"

sudo update-initramfs -c -k all

modinfo ixgbevf
ethtool -i eth0

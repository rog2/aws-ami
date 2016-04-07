#!/bin/bash -ex

#
# Install Jetty on Ubuntu Server, and configure it to be a daemon service.
#

JETTY_DEFAULT_LOCATION="/opt/jetty"

# Jetty Installation Directory Parameter
JETTY_LOCATION=$1
if [ -z "$JETTY_LOCATION" ]; then
    echo "No Jetty location specified, using default $JETTY_DEFAULT_LOCATION instead."
    JETTY_LOCATION="$JETTY_DEFAULT_LOCATION"
fi

echo "Begin installing Jetty under $JETTY_LOCATION ..."

JETTY_HOME="$JETTY_LOCATION/home"
JETTY_BASE="$JETTY_LOCATION/base"
JETTY_DIST="$JETTY_LOCATION/dist"
JETTY_TEMP="$JETTY_LOCATION/temp"

JETTY_VERSION='9.3.8.v20160314'

JETTY_DIST_TAR_FILENAME="jetty-distribution-$JETTY_VERSION.tar.gz"
JETTY_DIST_UNPACKED_DIRNAME="jetty-distribution-$JETTY_VERSION"
JETTY_DIST_FINAL_LOCATION="$JETTY_DIST/$JETTY_VERSION"
JETTY_DOWNLOAD_URL="http://download.eclipse.org/jetty/stable-9/dist/$JETTY_DIST_TAR_FILENAME"

# Check whether there exists a valid instance
# of Jetty installed at the specified directory
[[ -d $JETTY_LOCATION ]] && { service jetty status; } && {
    echo "Jetty is already installed at $JETTY_LOCATION. Skip reinstalling it."
    exit 0
}

# Clear and create install directory for Jetty
if [ -d $JETTY_LOCATION ]; then
    sudo rm -rf $JETTY_LOCATION
fi
sudo mkdir -p $JETTY_LOCATION
sudo mkdir -p $JETTY_BASE
sudo mkdir -p $JETTY_DIST
sudo mkdir -p $JETTY_TEMP

# Download the latest Jetty distribution
cd /tmp
wget $JETTY_DOWNLOAD_URL
if [[ -d /tmp/$JETTY_DIST_UNPACKED_DIRNAME ]]; then
    rm -rf /tmp/$JETTY_DIST_UNPACKED_DIRNAME
fi
tar xzf $JETTY_DIST_TAR_FILENAME

# Copy over under JETTY_DIST
sudo cp -r $JETTY_DIST_UNPACKED_DIRNAME $JETTY_DIST_FINAL_LOCATION

# Make JETTY_HOME a symbolic link to the latest Jetty distribution
sudo ln -sfT $JETTY_DIST_FINAL_LOCATION $JETTY_HOME

# Configure JETTY_BASE
# Depends on java has been installed.
# See install_java.sh
cd $JETTY_BASE
sudo java -jar $JETTY_HOME/start.jar --add-to-startd=deploy,http,logging,jsp

# Create a user to run Jetty
sudo useradd --user-group --shell /usr/sbin/nologin --home-dir $JETTY_TEMP jetty

# Add default index.html to root url
sudo mkdir -p $JETTY_BASE/webapps/ROOT
echo 'OK' | sudo tee -a $JETTY_BASE/webapps/ROOT/index.html

# Change permissions
sudo chown -R jetty:jetty $JETTY_LOCATION

# Configure the service
sudo cp $JETTY_HOME/bin/jetty.sh /etc/init.d/jetty
echo "JETTY_HOME=$JETTY_HOME"       | sudo tee    /etc/default/jetty
echo "JETTY_BASE=$JETTY_BASE"       | sudo tee -a /etc/default/jetty
echo "JETTY_RUN=$JETTY_BASE"        | sudo tee -a /etc/default/jetty
echo "JETTY_LOGS=$JETTY_BASE/logs"  | sudo tee -a /etc/default/jetty
echo "JETTY_USER=jetty"             | sudo tee -a /etc/default/jetty
echo "TEMPDIR=$JETTY_TEMP"          | sudo tee -a /etc/default/jetty

# Start Jetty service automatically on boot
sudo update-rc.d jetty defaults

# Start Jetty service and show status
sudo service jetty start

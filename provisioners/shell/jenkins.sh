#!/bin/bash -ex

# Installs Jenkins package with instructions in:
# http://pkg.jenkins-ci.org/debian/
#
# NOTE: Run this script as ROOT

TMP_DIR='/tmp/jenkins-install'
# Not using /etc/apt/sources.list because it's written by cloud-init on first boot of an instance,
# so modifications made there will not survive a re-bundle.
APT_SOURCE_FILE='/etc/apt/sources.list.d/jenkins.list'

# Lastest and greatest release, see:
# http://pkg.jenkins-ci.org/debian/
JENKINS_KEY_LATEST='http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key'
JENKINS_REPO_LATEST='http://pkg.jenkins-ci.org/debian'

# LTS stable relese, see:
# http://pkg.jenkins-ci.org/debian-stable/
JENKINS_KEY_STABLE='http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key'
JENKINS_REPO_STABLE='http://pkg.jenkins-ci.org/debian-stable'

# Switch between latest and stable
JENKINS_KEY=$JENKINS_KEY_LATEST
JENKINS_REPO=$JENKINS_REPO_LATEST

if [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
fi

mkdir -p "$TMP_DIR" && cd "$TMP_DIR"

echo 'Adding jenkins signing key ...'
wget -q -O - "$JENKINS_KEY" | apt-key add -

echo 'Adding jenkins repository to apt source list ...'
echo '# jenkins repository' >> "$APT_SOURCE_FILE"
echo "deb $JENKINS_REPO binary/" >> "$APT_SOURCE_FILE"

# Please note that this installs openjdk7 as default java
# to switch to java that comes with base AMI, run the following command:
# sudo update-alternatives --set java [path]
echo 'Installing jenkins by apt-get ...'
apt-get -y update
apt-get -y install jenkins

# Install Jenkins plugins
unzip /usr/share/jenkins/jenkins.war WEB-INF/jenkins-cli.jar -d /tmp/jenkins-war
cp -v /tmp/jenkins-war/WEB-INF/jenkins-cli.jar ~/
cd ~
JENKINS_CLI='java -jar jenkins-cli.jar -s http://localhost:8080'
JENKINS_INSTALL_PLUGIN="$JENKINS_CLI install-plugin -deploy"
$JENKINS_INSTALL_PLUGIN ansicolor
$JENKINS_INSTALL_PLUGIN packer
$JENKINS_INSTALL_PLUGIN git
$JENKINS_INSTALL_PLUGIN github-oauth
$JENKINS_INSTALL_PLUGIN codedeploy
$JENKINS_INSTALL_PLUGIN jenkins-cloudformation-plugin
$JENKINS_INSTALL_PLUGIN awseb-deployment-plugin
$JENKINS_INSTALL_PLUGIN aws-lambda
$JENKINS_INSTALL_PLUGIN snsnotify

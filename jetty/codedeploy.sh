#!/bin/bash -ex

# Install AWS CodeDeploy Agent as in documention:
# http://docs.aws.amazon.com/codedeploy/latest/userguide/how-to-run-agent.html#how-to-run-agent-install-ubuntu
#
# Depends on AWS CLI has been installed.

REGION=$1

CODEDEPLOY_TMP='/tmp/install-codedeploy'
BUCKET_NAME="aws-codedeploy-$REGION"
INSTALL_SCRIPT_URL="s3://$BUCKET_NAME/latest/install"

{ service codedeploy-agent status; } && {
    echo "CodeDeploy Agent is already installed. Skip reinstalling it."
    exit 0
}

sudo apt-get update
sudo apt-get -y install ruby2.0

echo 'Installing CodeDeploy agent ...'

mkdir -p $CODEDEPLOY_TMP && cd $CODEDEPLOY_TMP

aws s3 cp $INSTALL_SCRIPT_URL . --region $REGION
chmod +x ./install
sudo ./install auto

#!/bin/bash -ex

# Install AWS CodeDeploy Agent as in documention:
# http://docs.aws.amazon.com/codedeploy/latest/userguide/how-to-run-agent.html#how-to-run-agent-install-ubuntu
#
# Depends on AWS CLI has been installed.

CODEDEPLOY_TMP='/tmp/install-codedeploy'
BUCKET_NAME='aws-codedeploy-us-east-1'
INSTALL_SCRIPT_URL="https://s3.amazonaws.com/$BUCKET_NAME/latest/install"

{ service codedeploy-agent status; } && {
    echo "CodeDeploy Agent is already installed. Skip reinstalling it."
    exit 0
}

echo 'Installing CodeDeploy agent ...'

mkdir -p $CODEDEPLOY_TMP && cd $CODEDEPLOY_TMP

wget $INSTALL_SCRIPT_URL
chmod +x ./install
./install auto

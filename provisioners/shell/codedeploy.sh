#!/bin/bash -ex

# Install AWS CodeDeploy Agent as in documention:
# http://docs.aws.amazon.com/codedeploy/latest/userguide/how-to-run-agent.html#how-to-run-agent-install-ubuntu
#
# Depends on AWS CLI has been installed.

CODEDEPLOY_TMP='/tmp/install-codedeploy'

region=$1

bucket_name="aws-codedeploy-$region"
install_script_url="s3://$bucket_name/latest/install"

{ service codedeploy-agent status; } && {
    echo "CodeDeploy Agent is already installed. Skip reinstalling it."
    exit 0
}

echo 'Installing CodeDeploy agent ...'

mkdir -p $CODEDEPLOY_TMP && cd $CODEDEPLOY_TMP

aws s3 cp $install_script_url . --region $region
chmod +x ./install
sudo ./install auto

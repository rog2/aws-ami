#!/bin/bash -e

# Please refer to
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-helper-scripts-reference.html
# sudo easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

# lipengyang 
# /usr/bin/easy_install was not included in the dist-packages of python-setuptools in bionic LTS,which was included in xenial LTS,so I can't use easy_install directly 
# https://packages.ubuntu.com/bionic/all/python-setuptools/filelist
# https://packages.ubuntu.com/xenial/all/python-setuptools/filelist

sudo apt-get install python-setuptools
sudo python /usr/lib/python2.7/dist-packages/easy_install.py https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

sudo ln /usr/local/bin/cfn-hup /etc/init.d/
#!/bin/bash -e

# Please refer to
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-helper-scripts-reference.html
# sudo easy_install https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
# 中国区各个服务的 Endpoint:http://docs.amazonaws.cn/en_us/general/latest/gr/rande.html

sudo apt-get install python-setuptools
sudo python -m easy_install https://s3.cn-north-1.amazonaws.com.cn/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz

sudo ln /usr/local/bin/cfn-hup /etc/init.d/
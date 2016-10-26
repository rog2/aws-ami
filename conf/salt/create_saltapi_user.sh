#!/bin/bash

USER=saltapi
PASSWD_RANGE='1234567890!@#$%qwertQWERTasdfgASDFGzxcvbZXCVByuiopYUIOPhjklHJKLnmNM'
#create user if not exists
id $USER >& /dev/null
if [ $? -ne 0 ]
then
    PASSWD=$(</dev/urandom tr -dc $PASSWD_RANGE | head -c 10; echo "")

    useradd -M -s /sbin/nologin $USER

    echo " sudopsw" |sudo  -S echo $USER:$PASSWD |sudo chpasswd

    echo "//////////////////////////////////////////////////////////////////////////" | tee -a /var/log/boot.log
    echo "//                                                                      //" | tee -a /var/log/boot.log
    echo "//               saltapi_user:$USER,password:$PASSWD               //" | tee -a /var/log/boot.log
    echo "//                                                                      //" | tee -a /var/log/boot.log
    echo "//////////////////////////////////////////////////////////////////////////" | tee -a /var/log/boot.log

fi
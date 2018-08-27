#!/bin/bash

SALT_USER=salt
PASSWD_ALPHANUM='1234567890!@#$%qwertQWERTasdfgASDFGzxcvbZXCVByuiopYUIOPhjklHJKLnmNM'
# Create user if not exists
id $SALT_USER >& /dev/null
if [ $? -ne 0 ]
then
    SALT_PASSWD=$(</dev/urandom tr -dc $PASSWD_ALPHANUM | head -c 10; echo "")

    sudo adduser --system --group       \
        --disabled-login                \
        --no-create-home                \
        --home /nonexistent             \
        --shell /usr/sbin/nologin       \
        $SALT_USER

    echo " sudopsw" | sudo  -S echo $SALT_USER:$SALT_PASSWD | sudo chpasswd

    echo "//////////////////////////////////////////////////////////////////////////" | tee -a /var/log/boot.log
    echo "//                                                                      //" | tee -a /var/log/boot.log
    echo "//               Set $SALT_USER password to '$SALT_PASSWD'              //" | tee -a /var/log/boot.log
    echo "//                                                                      //" | tee -a /var/log/boot.log
    echo "//////////////////////////////////////////////////////////////////////////" | tee -a /var/log/boot.log

fi

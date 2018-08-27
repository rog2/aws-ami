#!/bin/bash

SALT_USER=salt
PASSWD_LENGTH=32

randpw() { tr -dc [:alnum:] < /dev/urandom | head -c${1:-15}; echo; }

# Create user if not exists
id $SALT_USER >& /dev/null
if [ $? -ne 0 ]
then
    SALT_PASSWD=$(randpw $PASSWD_LENGTH)

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

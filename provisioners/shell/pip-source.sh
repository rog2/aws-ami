#!/bin/bash -e

# Depends on pip.conf has been copyed to /tmp/pip
if [[ $1 == cn-* ]]; then
    mkdir ~/.pip
    chmod -R a+w ~/.pip
    cp -vf /tmp/pip/pip.conf ~/.pip/pip.conf
fi

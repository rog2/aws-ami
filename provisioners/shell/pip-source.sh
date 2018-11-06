#!/bin/bash -e

# Depends on pip.conf has been copyed to /tmp/pip
if [[ $1 == cn-* ]]; then
    mkdir ~/.pip
    chmod 700 ~/.pip
    cp -vf /tmp/pip/pip.conf ~/.pip/pip.conf
fi

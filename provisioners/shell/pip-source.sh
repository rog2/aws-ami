#!/bin/bash -e

# Depends on pip.conf has bean copyed to /tmp/pip
if [[ $1 == cn-* ]]; then
    sudo mkdir ~/.pip
    sudo chmod -R a+w ~/.pip
    sudo cp -vf /tmp/pip/pip.conf ~/.pip/pip.conf
fi

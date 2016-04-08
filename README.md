# Baking AMIs

We use [Packer](https://www.packer.io/) with [Jenkins](https://wiki.jenkins-ci.org/display/JENKINS/Packer+Plugin) to bake AMIs automatically.

The OS is **Ubuntu Server 14.04.4 LTS**.

## Prerequisites

Create an **AWS IAM Role** with name `packer-ec2`.

Attach managed policy **AmazonS3ReadOnlyAccess**.

## Run

    packer build -var 'key1=value1' -var 'key2=value2' templates/[name].json

# Baking AMIs

We use [Packer](https://www.packer.io/) with [Jenkins](https://wiki.jenkins-ci.org/display/JENKINS/Packer+Plugin) to bake AMIs automatically.

## Prerequisites

Create an **AWS IAM Role** with name `packer-ec2` and attach managed policy **AmazonS3ReadOnlyAccess**.

Configure the **EC2 Instance Profile** if you are running packer on EC2. Otherwise configure `~/.aws/credentials` on your machine.

## Run

```shell
packer build \
    -var 'region=[region]' \
    -var 'subnet_id=[subnet_id]' \
    templates/[name]
```

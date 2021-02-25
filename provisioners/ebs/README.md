# Amazon EBS Helpers

Helper scripts to make EBS volumes easier to use.

## NVMe block devices

NVMe device names are [NOT stable on EC2](https://docs.aws.amazon.com/en_pv/AWSEC2/latest/UserGuide/nvme-ebs-volumes.html).

So we are porting scripts from **Amazon Linux 2**, which create a symbolic link from the device name in the block device mapping (for example, `/dev/sdf`), to the NVMe device name.

Then, we could just use the device name in the block device mapping, like `/dev/sdf`, to [format and mount the volume](https://docs.aws.amazon.com/en_pv/AWSEC2/latest/UserGuide/ebs-using-volumes.html).

### Installation

    sudo install ebs-nvme-id /usr/local/bin/
    sudo install -m 644 99-ebs-nvme.rules /etc/udev/rules.d/

## Initialize EBS volumes

Format and mount EBS volume with one command.

### Installation

    sudo install ebs-init /usr/local/bin/

### Usage

    sudo ebs-init --device-name /dev/sdf --mount-point /mnt/data
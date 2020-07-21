# ---------------------------------------------------------------------------------------------------------------------
# Added HCL format support
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  description = "The type of EC2 Instances to run for each node in the Regional area id."
  default     = "cn-northwest-1"
}
variable "regions_to_copy" {
  description = "The type of EC2 Instances regions"
  default     = "cn-north-1"
}
variable "subnet_id" {
  type    = string
  default = null
}
variable "source_ami" {
  type    = list(string)
  default = []
}
variable "source_ami_owner" {
  type    = string
  default = "837727238323"
}
variable "os_arch" {
  type    = string
  default = "amd64"
}
variable "ami_name" {
  type    = string
  default = "ubuntu/18.04/{{user `os_arch`}}/{{isotime \"20060102T150405Z\"}}"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "iam_instance_profile" {
  type    = string
  default = "packer-ec2"
}
variable "timezone" {
  type    = string
  default = "Asia/Shanghai"
}
variable "java_version" {
  type    = string
  default = "11.0.7.10-1"
}
variable "node_exporter_version" {
  type    = string
  default = "1.0.1"
}
variable "docker_version" {
  type    = string
  default = "19.03.12"
}
variable "consul_version" {
  type    = string
  default = "1.8.0"
}
variable "nomad_version" {
  type    = string
  default = "0.12.0"
}
source "amazon-ebs" "ubuntu" {
  ami_description             = "Linux golden image based on Ubuntu 18.04"
  ami_name                    = var.ami_name
  ami_regions                 = var.regions_to_copy
  associate_public_ip_address = true
  communicator                = "ssh"
  ssh_username                = "ubuntu"
  iam_instance_profile        = var.iam_instance_profile
  instance_type               = var.instance_type
  pause_before_connecting     = "30s"
  region                      = var.region
  source_ami                  = var.source_ami
  source_ami_filter = {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-${var.os_arch}-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = var.source_ami_owner
  }
  ssh_clear_authorized_keys = true
  subnet_id                 = var.subnet_id
  tags = {
    Name                  = var.ami_name
    build_region          = "{{ .BuildRegion }}"
    consul_version        = var.consul_version
    docker_version        = var.docker_version
    java_distro           = "Amazon Corretto"
    java_version          = var.java_version
    node_exporter_version = var.node_exporter_version
    nomad_version         = var.nomad_version
    os_arch               = os_arch
    os_name               = "Ubuntu"
    os_version            = "18.04"
    source_ami            = "{{ .SourceAMI }}"
    source_ami_name       = "{{ .SourceAMIName }}"
    timezone              = var.timezone
  }
}
build {
  provisioner "file" {
    source      = "provisioners/shell/bash-helpers.sh"
    destination = "/tmp/"
  }
  provisioner "file" {
    source      = "provisioners/shell/cloud-init/mount-nvme-instance-store"
    destination = "/tmp/"
  }
  provisioner "file" {
    source      = "provisioners/shell/ebs"
    destination = "/tmp/"
  }
  provisioner "file" {
    source      = "provisioners/shell/docker"
    destination = "/tmp/"
  }
  provisioner "file" {
    source      = "provisioners/shell/consul"
    destination = "/tmp/"
  }
  provisioner "file" {
    source      = "provisioners/shell/nomad"
    destination = "/tmp/"
  }
  provisioner "shell" {
    environment_vars = {
      "BASH_HELPERS"          = "/tmp/bash-helpers.sh"
      "TIMEZONE"              = "{var.timezone}"
      "JAVA_VERSION"          = "{var.java_version}"
      "NODE_EXPORTER_VERSION" = "{var.node_exporter_version}"
    }
    scripts = [
      "provisioners/shell/apt-mirrors.sh",
      "provisioners/shell/apt-upgrade.sh",
      "provisioners/shell/apt-daily-conf.sh",
      "provisioners/shell/packages.sh",
      "provisioners/shell/journald-conf.sh",
      "provisioners/shell/core-pattern.sh",
      "provisioners/shell/kernel-tuning.sh",
      "provisioners/shell/chrony.sh",
      "provisioners/shell/timezone.sh",
      "provisioners/shell/awscliv2.sh",
      "provisioners/shell/java-amazon-corretto.sh",
      "provisioners/shell/prometheus/node-exporter.sh"
    ]
  }
  provisioner "shell" {
    inline = [
      "cd /tmp/",
      "sudo install -v mount-nvme-instance-store /var/lib/cloud/scripts/per-instance/"
    ]
  }
  provisioner "shell" {
    inline = [
      "cd /tmp/ebs",
      "sudo install -v ebs-nvme-id /usr/local/bin/",
      "sudo install -v -m 644 99-ebs-nvme.rules /etc/udev/rules.d/",
      "sudo install -v ebs-init /usr/local/bin/"
    ]
  }
  provisioner "shell" {
    inline = [
      "cd /tmp/docker",
      "chmod +x install-docker",
      "./install-docker --version ${var.docker_version}"
    ]
  }
  provisioner "shell" {
    inline = [
      "cd /tmp/consul",
      "chmod +x install-consul",
      "./install-consul --version {{user `consul_version`}}"
    ]
  }
  provisioner "shell" {
    inline = [
      "cd /tmp/nomad",
      "chmod +x install-nomad",
      "./install-nomad --version ${var.nomad_version}"
    ]
  }
  provisioner "shell" {
    inline = [
      "echo 'Validating provisioners...'",
      "aws --version", "java -version",
      "prometheus-node-exporter --version",
      "docker --version",
      "consul --version",
      "nomad --version"
    ]
  }
  post-processor "manifest" {
    only = ["source.amazon-ebs.ubuntu"]
  }
}

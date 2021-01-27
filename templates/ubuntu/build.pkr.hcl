build {
  description = "Linux golden image based on Ubuntu Server LTS."

  sources = [
    "source.amazon-ebs.bionic-amd64",
    "source.amazon-ebs.focal-amd64",
  ]

  provisioner "file" {
    source      = "provisioners/shell/bash-helpers.sh"
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      "BASH_HELPERS=/tmp/bash-helpers.sh",
      "TIMEZONE=${var.timezone}",
      "JAVA_VERSION=${local.java_version}",
      "NODE_EXPORTER_VERSION=${local.node_exporter_version}",
    ]
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
      "provisioners/shell/prometheus/node-exporter.sh",
    ]
  }

  provisioner "file" {
    source      = "provisioners/shell/cloud-init/mount-nvme-instance-store"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "cd /tmp/",
      "sudo install -v mount-nvme-instance-store /var/lib/cloud/scripts/per-instance/",
    ]
  }

  provisioner "file" {
    source      = "provisioners/shell/ebs"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "cd /tmp/ebs",
      "sudo install -v ebs-nvme-id /usr/local/bin/",
      "sudo install -v -m 644 99-ebs-nvme.rules /etc/udev/rules.d/",
      "sudo install -v ebs-init /usr/local/bin/",
    ]
  }

  provisioner "file" {
    source      = "provisioners/shell/docker"
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      "BASH_HELPERS=/tmp/bash-helpers.sh",
    ]
    inline = [
      "cd /tmp/docker",
      "chmod +x install-docker install-docker-compose install-ecr-helper",
      "./install-docker --version ${local.docker_version}",
      "./install-docker-compose --version ${local.docker_compose_version}",
      "./install-ecr-helper --version ${local.ecr_helper_version}",
    ]
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "provisioners/shell/consul"
  }

  provisioner "shell" {
    inline = [
      "cd /tmp/consul",
      "chmod +x install-consul",
      "./install-consul --version ${local.consul_version}",
    ]
  }

  provisioner "file" {
    source      = "provisioners/shell/nomad"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "cd /tmp/nomad",
      "chmod +x install-nomad",
      "./install-nomad --version ${local.nomad_version}",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Validating provisioners...'",
      "aws --version",
      "java -version",
      "prometheus-node-exporter --version",
      "docker --version",
      "docker-compose --version",
      "docker-credential-ecr-login -v",
      "consul --version",
      "nomad --version",
    ]
  }

  post-processor "manifest" {}
}

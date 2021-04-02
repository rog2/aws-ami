build {
  description = "Linux golden image based on Ubuntu Server LTS."

  sources = [
    "source.amazon-ebs.focal_amd64",
    "source.amazon-ebs.focal_arm64",
  ]

  provisioner "file" {
    source      = "provisioners/bash-helpers.sh"
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
      "provisioners/apt-mirrors.sh",
      "provisioners/apt-upgrade.sh",
      "provisioners/apt-daily.sh",
      "provisioners/apt-packages.sh",
      "provisioners/journald-conf.sh",
      "provisioners/core-pattern.sh",
      "provisioners/kernel-tuning.sh",
      "provisioners/chrony.sh",
      "provisioners/timezone.sh",
      "provisioners/awscliv2.sh",
      "provisioners/java-amazon-corretto.sh",
      "provisioners/prometheus/node-exporter.sh",
    ]
  }

  provisioner "file" {
    source      = "provisioners/cloud-init/mount-nvme-instance-store"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "cd /tmp/",
      "sudo install -v mount-nvme-instance-store /var/lib/cloud/scripts/per-instance/",
    ]
  }

  provisioner "file" {
    source      = "provisioners/ebs"
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
    source      = "provisioners/docker"
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      "BASH_HELPERS=/tmp/bash-helpers.sh",
    ]
    inline = [
      "cd /tmp/docker",
      "chmod +x install-docker install-ecr-helper",
      "./install-docker --version ${local.docker_version}",
      "./install-ecr-helper --version ${local.ecr_helper_version}",
    ]
  }

  provisioner "shell" {
    # docker-compose only supports amd64
    # https://www.packer.io/docs/templates/hcl_templates/blocks/build/provisioner#run-on-specific-builds
    only = [
      "amazon-ebs.focal_amd64",
    ]
    environment_vars = [
      "BASH_HELPERS=/tmp/bash-helpers.sh",
    ]
    inline = [
      "cd /tmp/docker",
      "chmod +x install-docker-compose",
      "./install-docker-compose --version ${local.docker_compose_version}",
      "docker-compose --version",
    ]
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "provisioners/consul"
  }

  provisioner "shell" {
    inline = [
      "cd /tmp/consul",
      "chmod +x install-consul",
      "./install-consul --version ${local.consul_version}",
    ]
  }

  provisioner "file" {
    source      = "provisioners/nomad"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "cd /tmp/nomad",
      "chmod +x install-nomad",
      "./install-nomad --version ${local.nomad_version}",
    ]
  }

  provisioner "file" {
    source      = "provisioners/nginx"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "cd /tmp/nginx",
      "chmod +x install-nginx",
      "./install-nginx --repo stable",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Validating provisioners...'",
      "aws --version",
      "java -version",
      "prometheus-node-exporter --version",
      "docker --version",
      "docker-credential-ecr-login -v",
      "consul --version",
      "nomad --version",
      "nginx -V",
    ]
  }

  # https://www.packer.io/docs/post-processors/manifest
  # https://www.packer.io/docs/templates/hcl_templates/contextual-variables#source-variables
  post-processor "manifest" {
    custom_data = {
      region     = var.region
      image_name = local.ami_names[source.name]
    }
  }
}

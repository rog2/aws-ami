source "amazon-ebs" "bionic-amd64" {
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = local.source_ami_owners
    most_recent = true
  }

  region          = var.region
  ami_regions     = var.regions_to_copy
  ami_users       = var.users_to_share
  ami_description = "Linux golden image based on Ubuntu 18.04 (amd64)"
  ami_name        = local.ami_names.bionic_amd64

  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type_amd64
  iam_instance_profile        = var.iam_instance_profile
  pause_before_connecting     = "30s"
  communicator                = "ssh"
  ssh_username                = "ubuntu"
  ssh_clear_authorized_keys   = true
  associate_public_ip_address = true

  tags = {
    Name                   = local.ami_names.bionic_amd64
    build_region           = "{{ .BuildRegion }}"
    docker_compose_version = local.docker_compose_version
    docker_version         = local.docker_version
    ecr_helper_version     = local.ecr_helper_version
    java_distro            = "Amazon Corretto"
    java_version           = local.java_version
    node_exporter_version  = local.node_exporter_version
    consul_version         = local.consul_version
    nomad_version          = local.nomad_version
    os_arch                = "amd64"
    os_name                = "Ubuntu"
    os_version             = "18.04"
    source_ami             = "{{ .SourceAMI }}"
    source_ami_name        = "{{ .SourceAMIName }}"
    timezone               = var.timezone
  }
}

source "amazon-ebs" "focal-amd64" {
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = local.source_ami_owners
    most_recent = true
  }

  region          = var.region
  ami_regions     = var.regions_to_copy
  ami_users       = var.users_to_share
  ami_description = "Linux golden image based on Ubuntu 20.04 (amd64)"
  ami_name        = local.ami_names.focal_amd64

  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type_amd64
  iam_instance_profile        = var.iam_instance_profile
  pause_before_connecting     = "30s"
  communicator                = "ssh"
  ssh_username                = "ubuntu"
  ssh_clear_authorized_keys   = true
  associate_public_ip_address = true

  tags = {
    Name                   = local.ami_names.focal_amd64
    build_region           = "{{ .BuildRegion }}"
    docker_compose_version = local.docker_compose_version
    docker_version         = local.docker_version
    ecr_helper_version     = local.ecr_helper_version
    java_distro            = "Amazon Corretto"
    java_version           = local.java_version
    node_exporter_version  = local.node_exporter_version
    consul_version         = local.consul_version
    nomad_version          = local.nomad_version
    os_arch                = "amd64"
    os_name                = "Ubuntu"
    os_version             = "20.04"
    source_ami             = "{{ .SourceAMI }}"
    source_ami_name        = "{{ .SourceAMIName }}"
    timezone               = var.timezone
  }
}

source "amazon-ebs" "focal-arm64" {
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = local.source_ami_owners
    most_recent = true
  }

  region          = var.region
  ami_regions     = var.regions_to_copy
  ami_users       = var.users_to_share
  ami_description = "Linux golden image based on Ubuntu 20.04 (arm64)"
  ami_name        = local.ami_names.focal_arm64

  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type_arm64
  iam_instance_profile        = var.iam_instance_profile
  pause_before_connecting     = "30s"
  communicator                = "ssh"
  ssh_username                = "ubuntu"
  ssh_clear_authorized_keys   = true
  associate_public_ip_address = true

  tags = {
    Name                   = local.ami_names.focal_arm64
    build_region           = "{{ .BuildRegion }}"
    docker_version         = local.docker_version
    ecr_helper_version     = local.ecr_helper_version
    java_distro            = "Amazon Corretto"
    java_version           = local.java_version
    node_exporter_version  = local.node_exporter_version
    consul_version         = local.consul_version
    nomad_version          = local.nomad_version
    os_arch                = "arm64"
    os_name                = "Ubuntu"
    os_version             = "20.04"
    source_ami             = "{{ .SourceAMI }}"
    source_ami_name        = "{{ .SourceAMIName }}"
    timezone               = var.timezone
  }
}

locals {
  # format: 20210126T024552Z
  timestamp = regex_replace(timestamp(), "[- :]", "")

  # software versions
  java_version           = "11.0.10.9-1"
  node_exporter_version  = "1.0.1"
  docker_version         = "20.10.2"
  docker_compose_version = "1.28.2"
  ecr_helper_version     = "0.4.0"
  consul_version         = "1.9.3"
  nomad_version          = "1.0.2"

  # Canonical's official China/Global AWS account IDs
  source_ami_owners = [substr(var.region, 0, 3) == "cn-" ? "837727238323" : "099720109477"]

  # AMI names for OS releases/architectures
  ami_names = {
    bionic_amd64 = "ubuntu/18.04/amd64/${local.timestamp}"
    focal_amd64  = "ubuntu/20.04/amd64/${local.timestamp}"
    focal_arm64  = "ubuntu/20.04/arm64/${local.timestamp}"
  }
}

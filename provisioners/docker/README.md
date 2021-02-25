# Docker

Install and run [Docker CE (stable)](https://docs.docker.com/install/).

Inspired by [run-consul](../consul/run-consul) and [run-nomad](../nomad/run-nomad).

## install-docker

Installs docker, but make sure `docker.service` is stopped and disabled.

Expected to run as a Packer shell provisioner (unprivileged user).

## run-docker

Configure and start `docker.service`.

Prefer NVMe instance store (if available) as Docker data dir.

Expected to run as EC2 user data (root user).

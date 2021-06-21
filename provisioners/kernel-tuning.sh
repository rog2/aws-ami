#!/bin/bash

set -e

readonly SYSCTL_CONF="/etc/sysctl.d/98-kingsoftgames-kernel-tuning.conf"

sudo tee "$SYSCTL_CONF" <<EOF
# Disable virtual memory
vm.swappiness = 0

# Networking
# upper limit allowed for a listen() backlog
net.core.somaxconn = 1024
# per-socket receive/send buffers
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
# port range used by TCP and UDP to choose the local port
net.ipv4.ip_local_port_range = 1024 65535
EOF

sudo sysctl -p "$SYSCTL_CONF"

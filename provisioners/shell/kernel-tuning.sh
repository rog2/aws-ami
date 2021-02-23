#!/bin/bash

set -e

readonly SYSCTL_CONF="/etc/sysctl.d/98-kingsoftgames-kernel-tuning.conf"

sudo tee "$SYSCTL_CONF" <<EOF
# Disable virtual memory
vm.swappiness = 0

# Networking
net.core.somaxconn = 1024
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
EOF

sudo sysctl -p "$SYSCTL_CONF"

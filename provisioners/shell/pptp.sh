#!/bin/bash -ex

# Installs and configures pptp service on Ubuntu Server as in doc:
# https://help.ubuntu.com/community/PPTPServer
#
# needs run as root.

if [ "$EUID" -ne 0 ]
    then echo "Please run as root."
    exit 1
fi

apt-get -y install pptpd

# Class-C sized address
PPTPD_CONF='/etc/pptpd.conf'
echo 'localip 192.168.0.1' >> $PPTPD_CONF
echo 'remoteip 192.168.0.2-254' >> $PPTPD_CONF

PPTPD_OPTIONS='/etc/ppp/pptpd-options'
echo "" >> $PPTPD_OPTIONS
echo "# Google public DNS" >> $PPTPD_OPTIONS
echo "ms-dns 8.8.8.8" >> $PPTPD_OPTIONS
echo "ms-dns 8.8.4.4" >> $PPTPD_OPTIONS

# TODO: download backuped /etc/ppp/chap-secrets from S3

/etc/init.d/pptpd restart

# Setup IP Forwarding
SYSCTL_CONF=/etc/sysctl.d/60-pptp-ip-forward.conf
echo "net.ipv4.ip_forward=1" | tee $SYSCTL_CONF
# Reload the configuration
sysctl -p $SYSCTL_CONF

# NAT and Forward rules
IPTABLES_NAT='iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE'
IPTABLES_FORWARD='iptables -A FORWARD -p tcp --syn -s 192.168.0.0/24 -j TCPMSS --set-mss 1356'

# Add rules to iptables, effective immediately
$IPTABLES_NAT
$IPTABLES_FORWARD

# Add rules to iptables upon startup
RC_LOCAL='/etc/rc.local'
sed "s|^exit 0$||" -i $RC_LOCAL
echo "$IPTABLES_NAT" >> $RC_LOCAL
echo "$IPTABLES_FORWARD" >> $RC_LOCAL

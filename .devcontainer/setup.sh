#!/bin/sh
set -eux

wget -O /tmp/dnscontrol.deb https://github.com/StackExchange/dnscontrol/releases/download/v4.7.3/dnscontrol-4.7.3.amd64.deb
sudo dpkg -i /tmp/dnscontrol.deb
rm -f /tmp/dnscontrol.deb

dnscontrol write-types
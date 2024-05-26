#!/bin/bash
set -eux

# https://docs.digitalocean.com/reference/doctl/how-to/install/#install-2
DIR=`mktemp -d`
cd "$DIR"
wget https://github.com/digitalocean/doctl/releases/download/v1.104.0/doctl-1.104.0-linux-amd64.tar.gz
tar xf doctl-1.104.0-linux-amd64.tar.gz
sudo mv doctl /usr/local/bin
rm -rf "$DIR"

which doctl
# infisical run -- bash -c 'doctl auth init -t "$DIGITALOCEAN_TOKEN"'
# doctl auth list
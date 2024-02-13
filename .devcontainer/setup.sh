#!/bin/sh
set -eux

cp -f git-hooks/* .git/hooks/

wget -O /tmp/dnscontrol.deb https://github.com/StackExchange/dnscontrol/releases/download/v4.7.3/dnscontrol-4.7.3.amd64.deb
sudo dpkg -i /tmp/dnscontrol.deb
rm -f /tmp/dnscontrol.deb

cd dns
dnscontrol write-types
cd -

# https://opentofu.org/docs/intro/install/deb
# install boilerplate is lame, but this installs a more recent version than the devcontainer feature
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/keyrings/opentofu.gpg >/dev/null
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null
sudo chmod a+r /etc/apt/keyrings/opentofu.gpg

echo \
  "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | \
sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null

sudo apt-get update
sudo apt-get install -y tofu
#!/bin/sh
set -eux
cd "`dirname "$0"`/.."

cp -f git-hooks/* .git/hooks/

which dnscontrol || (
wget -O /tmp/dnscontrol.deb https://github.com/StackExchange/dnscontrol/releases/download/v4.7.3/dnscontrol-4.7.3.amd64.deb
sudo dpkg -i /tmp/dnscontrol.deb
rm -f /tmp/dnscontrol.deb
)

cd dns
dnscontrol write-types
cd -

# https://opentofu.org/docs/intro/install/deb
# install boilerplate is lame, but this installs a more recent version than the devcontainer feature
which tofu || (
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
)

# infisical.com secrets management
# https://infisical.com/docs/cli/overview
# https://infisical.com/docs/cli/commands/vault
curl -1sLf \
'https://dl.cloudsmith.io/public/infisical/infisical-cli/setup.deb.sh' \
| sudo -E bash
sudo apt-get update && sudo apt-get install -y infisical

if [ "${CI:-}" == "" ]; then
    # make `infisical login` work in the devcontainer.
    echo 'non-CI infisical setup'
    # transient local passphrase. this prevents nagging for a passphrase whenever we call infisical
    export INFISICAL_VAULT_FILE_PASSPHRASE=$(tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 32)
    echo "export INFISICAL_VAULT_FILE_PASSPHRASE=\"$INFISICAL_VAULT_FILE_PASSPHRASE\"" >> ~/.bashrc
    infisical vault set file
else
    # CI expects INFISICAL_TOKEN. no need during setup, though
    echo 'CI infisical setup'
    # [ "${INFISICAL_TOKEN:-}" != "" ] || (echo 'INFISICAL_TOKEN is required' && exit 1)
fi
#!/bin/bash
set -eux

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
    if [ "${INFISICAL_VAULT_FILE_PASSPHRASE:-}" == "" ]; then
      export INFISICAL_VAULT_FILE_PASSPHRASE=$(tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 32)
      echo "export INFISICAL_VAULT_FILE_PASSPHRASE=\"$INFISICAL_VAULT_FILE_PASSPHRASE\"" >> ~/.bashrc
    fi
    infisical vault set file || true
else
    # CI expects INFISICAL_TOKEN. no need during setup, though
    echo 'CI infisical setup'
    # [ "${INFISICAL_TOKEN:-}" != "" ] || (echo 'INFISICAL_TOKEN is required' && exit 1)
fi
# let the devcontainer open host's web browser. https://github.com/microsoft/vscode-remote-release/issues/3540
sudo apt-get update && sudo apt-get install -y xdg-utils
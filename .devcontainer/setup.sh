#!/bin/bash
set -eux
cd "`dirname "$0"`/.."

cp -f git-hooks/* .git/hooks/

echo 'PATH=$PATH:/usr/lib/git-core/' >> ~/.bashrc

.devcontainer/setup/dnscontrol.sh
.devcontainer/setup/tofu.sh
.devcontainer/setup/doctl.sh
.devcontainer/setup/infisical.sh
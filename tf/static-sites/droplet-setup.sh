#!/bin/bash
set -eux

ufw allow 80
ufw allow 443

# mount digitalocean volume for caddy's persistent data
# https://docs.digitalocean.com/products/volumes/how-to/mount/
mkdir /mnt/static-sites
grep /mnt/static-sites /etc/fstab || (
    cat <<EOF >> /etc/fstab
# mount digitalocean volume for caddy's persistent data
# https://docs.digitalocean.com/products/volumes/how-to/mount/
/dev/disk/by-label/static-sites /mnt/static-sites ext4 defaults,nofail,discard,noatime 0 2
EOF
)
mount -a
findmnt /mnt/static-sites

cd ~
docker compose pull
docker compose up -d

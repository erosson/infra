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

# `--restart unless-stopped` works pretty well!
# * `service docker restart`: caddy container is restarted
# * `service docker stop` -> `start`: caddy container stops, and restarts
# * `reboot`: caddy container restarts shortly after boot
# one open question: how to update the image on change? docker pull > re-run should do it, right?
#
# possible strategy: create images with userdata; update images with rsync. just have to make sure the state of create->update is the same as recreate...
# https://www.reddit.com/r/selfhosted/comments/w2wwum/gitops_tool_for_docker_compose_specifically_not/igwobaf/
# https://www.reddit.com/r/selfhosted/comments/19c6zut/best_way_to_push_websites/
#
# volume mounts, ports, and cap-add necessary for caddy and ssl's persistent data, as described here: https://hub.docker.com/_/caddy
# restart unless-stopped ensures docker restarts this container on machine reboot
docker run -d \
    --cap-add=NET_ADMIN -p 80:80 -p 443:443 -p 443:443/udp \
    --restart unless-stopped \
    -v /mnt/static-sites/caddy-data:/data \
    -v /mnt/static-sites/caddy-config:/config \
    ghcr.io/erosson/public-infra-static-sites-small:main 

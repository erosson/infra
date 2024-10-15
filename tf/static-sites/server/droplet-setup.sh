#!/bin/bash
set -eux
cd ~

df -h
truncate -s 0 /var/lib/docker/containers/**/*-json.log
df -h

ufw allow 80
ufw allow 443

# pull a private docker image. logout when done.
# .env is created with the machine (cloud-init), but not updated on redeploy
(
    set +x -o allexport
    source .env
    set -x +o allexport
    echo "$GITHUB_TOKEN_PRIVATE_INFRA_READ_DOCKER_IMAGE" | docker login ghcr.io -u erosson --password-stdin
    docker compose -f docker-compose.tmp.yml pull 
    docker logout
    rm -rf /root/.docker/config.json
)

# overwrite and run docker-compose only if the pull succeeds
cp -f docker-compose.yml docker-compose.bak.yml || true
mv -f docker-compose.tmp.yml docker-compose.yml
docker compose up -d
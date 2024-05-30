FROM caddy:2.8
ARG DOT_LOCALHOST

COPY --from=ghcr.io/erosson/www.erosson.org:main         /usr/share/caddy /sites/www.erosson.org
COPY src/ops.erosson.org /sites/ops.erosson.org

RUN for host in $(ls /sites); do \
    mkdir -p /var/www ;\
    ln -s /sites/$host /var/www/$host ;\
    ln -s /sites/$host /var/www/docker-$host ;\
    if [ "${DOT_LOCALHOST}" != "" ]; then \
    ln -s /sites/$host /var/www/$host.localhost ;\
    ln -s /sites/$host /var/www/docker-$host.localhost ;\
    fi ;\
    done

COPY src/error /sites/error

COPY small-image/Caddyfile /etc/caddy/Caddyfile
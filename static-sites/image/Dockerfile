FROM caddy:2.8
ARG NO_LOCALHOST

COPY --from=ghcr.io/erosson/math2.swarmsim.com:main      /usr/share/caddy /sites/math2.swarmsim.com
COPY --from=ghcr.io/erosson/math.swarmsim.com:master     /usr/share/caddy /sites/math.swarmsim.com
COPY --from=ghcr.io/erosson/cooking.erosson.org:main     /usr/share/caddy /sites/cooking.erosson.org
COPY --from=ghcr.io/erosson/vegas-wordle:main            /usr/share/caddy /sites/vegas-wordle.erosson.org
COPY --from=ghcr.io/erosson/freecbt.erosson.org:master   /usr/share/caddy /sites/freecbt.erosson.org
COPY --from=ghcr.io/erosson/zealgame.com:main            /usr/share/caddy /sites/www.zealgame.com
COPY --from=ghcr.io/swarmsim/www.swarmsim.com:master     /usr/share/caddy /sites/preprod.swarmsim.com
COPY --from=ghcr.io/swarmsim/www.swarmsim.com:production /usr/share/caddy /sites/www.swarmsim.com
COPY --from=ghcr.io/erosson/www.erosson.org:main         /usr/share/caddy /sites/www.erosson.org
COPY src/ops.erosson.org /sites/ops.erosson.org

RUN for host in $(ls /sites); do \
    mkdir -p /var/www ;\
    ln -s /sites/$host /var/www/$host ;\
    ln -s /sites/$host /var/www/docker-$host ;\
    if [ "${NO_LOCALHOST}" != "" ]; then \
    ln -s /sites/$host /var/www/$host.localhost ;\
    ln -s /sites/$host /var/www/docker-$host.localhost ;\
    fi ;\
    done

COPY src/error /sites/error

COPY image/Caddyfile /etc/caddy/Caddyfile
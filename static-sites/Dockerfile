FROM caddy:2.8
ARG NO_LOCALHOST

COPY --from=ghcr.io/erosson/math2.swarmsim.com:main /usr/share/caddy /var/www/math2.swarmsim.com
COPY --from=ghcr.io/erosson/cooking.erosson.org:main /usr/share/caddy /var/www/cooking.erosson.org
COPY --from=ghcr.io/erosson/vegas-wordle:main /usr/share/caddy /var/www/vegas-wordle.erosson.org
COPY --from=ghcr.io/erosson/freecbt.erosson.org:master /usr/share/caddy /var/www/freecbt.erosson.org
COPY --from=ghcr.io/erosson/zealgame.com:main /usr/share/caddy /var/www/www.zealgame.com

RUN if [ "${NO_LOCALHOST}" != "" ]; then \
    ln -s /var/www/math2.swarmsim.com /var/www/math2.swarmsim.com.localhost ;\
    ln -s /var/www/cooking.erosson.org /var/www/cooking.erosson.org.localhost ;\
    ln -s /var/www/vegas-wordle.erosson.org /var/www/vegas-wordle.erosson.org.localhost ;\
    ln -s /var/www/freecbt.erosson.org /var/www/freecbt.erosson.org.localhost ;\
    ln -s /var/www/www.zealgame.com /var/www/www.zealgame.com.localhost ;\
    fi

COPY error /var/www/error
COPY Caddyfile /etc/caddy/Caddyfile
FROM alpine:3.14

MAINTAINER Ilia Dmitriev ilia.dmitriev@gmail.com

RUN set -xe \
    
# Install postgres, python3, runit, pgbouncer
    && apk add --no-cache musl-locales postgresql pgbouncer \
                     python3 py3-pip runit curl \
    && mkdir -p /run/postgresql \
    && chown -R postgres:postgres /run/postgresql \
    && mkdir -p /var/lib/postresql \
    && chown -R postgres:postgres /var/lib/postresql \

# Install build dependencies
    && apk add --no-cache --virtual .build-deps \
            build-base python3-dev \
            linux-headers postgresql-dev \
            
# Install patroni, psycopg2
    && pip install --no-cache-dir patroni psycopg2 \
                                patroni[kubernetes] \

# cleanup
    && rm -rf /tmp/* \
    && apk del .build-deps \
    && find /var/log -type f -exec truncate --size 0 {} \; \
    && rm -rf /var/cache/apk/*
    
ENV LANG=ru_RU.UTF-8 \
    PGDATA=/var/lib/postgresql/data

COPY runit /etc
COPY --chown=postgres patroni /etc/patroni
COPY --chown=postgres pgbouncer /etc/pgbouncer

RUN chown -R postgres:postgres /etc/patroni \
    && chmod +x /etc/service/*/*

STOPSIGNAL SIGINT

EXPOSE 6432 5432 8008

CMD ["/sbin/runsvdir", "-P", "/etc/service"]

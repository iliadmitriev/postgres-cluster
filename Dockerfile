FROM alpine:3.14

MAINTAINER Ilia Dmitriev ilia.dmitriev@gmail.com

RUN set -xe \
    
# Install postgres, python3
    && apk add --no-cache musl-locales postgresql \
                     python3 py3-pip \
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

COPY --chown=postgres:postgres patroni /etc/patroni

USER postgres

STOPSIGNAL SIGTERM

EXPOSE 5432 8008

CMD ["/usr/bin/patroni", "/etc/patroni/postgres0.yml"]

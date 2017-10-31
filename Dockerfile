FROM alpine:3.6

# Install glibc on Alpine (required by docker-compose) from
# https://github.com/sgerrand/alpine-pkg-glibc
# See also https://github.com/gliderlabs/docker-alpine/issues/11
RUN set -x && \
    apk add --no-cache -t .deps ca-certificates curl && \
    GLIBC_VERSION='2.23-r3' && \
    curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    curl -Lo glibc.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk && \
    curl -Lo glibc-bin.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-bin-$GLIBC_VERSION.apk && \
    apk update && \
    apk add glibc.apk glibc-bin.apk && \
    rm -rf /var/cache/apk/* && \
    rm glibc.apk glibc-bin.apk && \
    apk del .deps

# Install docker-compose
# https://docs.docker.com/compose/install/
RUN set -x && \
    apk add --no-cache -t .deps ca-certificates curl && \
    DOCKER_COMPOSE_URL=https://github.com$(curl -L https://github.com/docker/compose/releases/latest | grep -Eo 'href="[^"]+docker-compose-Linux-x86_64' | sed 's/^href="//') && \
    curl -Lo /usr/local/bin/docker-compose $DOCKER_COMPOSE_URL && \
    chmod a+rx /usr/local/bin/docker-compose && \
    docker-compose version && \
    apk del .deps

# Install Core Utilities
RUN apk add --no-cache bash gawk sed grep bc coreutils git openssl
RUN apk add --no-cache py-pip && pip install --no-cache-dir awscli 

# Install Dockerize
ENV DOCKERIZE_VERSION v0.5.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

FROM alpine:edge

RUN apk upgrade --no-cache && \
    apk add --no-cache \
      sudo \
      ruby ruby-bundler ruby-bigdecimal \
      ruby-rmagick \
      libc6-compat \
      tzdata

COPY assets /home/build/assets/

RUN adduser -s /bin/sh -g 'redmine' -D redmine; \
    chown -R redmine:redmine /home/redmine; \
    ash -ex /home/build/assets/build/install.sh

ENTRYPOINT ["/home/build/assets/runtime/docker-entrypoint.sh"]

EXPOSE 3000/tcp

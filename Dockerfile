FROM alpine:edge

RUN apk upgrade --no-cache && \
    apk add --no-cache \
      vim \
      sudo \
      git \
      ruby ruby-bundler ruby-rdoc ruby-rake ruby-bigdecimal ruby-irb \
      ruby-rmagick \
      tzdata \
      imagemagick

COPY assets /home/build/assets/

RUN adduser -s /bin/sh -g 'redmine' -D redmine; \
    chown -R redmine:redmine /home/redmine; \
    ash -ex /home/build/assets/build/install.sh

ENTRYPOINT ["/home/build/assets/runtime/docker-entrypoint.sh"]

EXPOSE 3000/tcp

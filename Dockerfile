FROM alpine:edge

RUN apk upgrade --no-cache && \
    apk add --no-cache \
      vim \
      sudo \
      git \
      ruby ruby-bundler ruby-rdoc ruby-rake ruby-bigdecimal ruby-irb \
      tzdata \
      imagemagick

COPY assets /home/redmine/assets/

RUN adduser -s /bin/sh -g 'redmine' -D redmine; \
    chown -R redmine:redmine /home/redmine; \
    ash -ex /home/redmine/assets/build/install.sh

ENTRYPOINT ["/home/redmine/assets/runtime/docker-entrypoint.sh"]

EXPOSE 3000/tcp

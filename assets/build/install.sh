#!/bin/sh

# Prepare for install
apk add --no-cache --virtual .builddev \
  build-base \
  ruby-dev \
  zlib-dev \
  cmake \
  mariadb-dev \
  linux-headers \
  coreutils \
  git

# Download
ash -ex /home/build/assets/build/download.sh

cd /home/redmine/

sudo -u redmine -H echo "install: --no-document" > ~/.gemrc

sudo -u redmine -H cp config/database.yml.example config/database.yml

bundle install --without development test -j$(nproc)

chown -R redmine:redmine files log tmp public/plugin_assets
chmod -R 755 files log tmp public/plugin_assets

# Clean up
ash -x  /home/build/assets/build/clean_up.sh

# Remove build dependencies
apk del --no-cache .builddev

# Install for runtime
RUNDEP=`scanelf --needed --nobanner --format '%n#p' --recursive /usr/lib/ruby | tr ',' '\n' | sort -u | awk 'system("[ -e /lib/" $1 " -o -e /usr/lib/" $1 " -o -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }'`

apk add --no-cache $RUNDEP

#!/bin/sh

set -x

# set default
MYSQL_HOST=${DB_HOST:-redmine-mariadb}
MYSQL_DATABASE=${DB_NAME:-redmine}
MYSQL_USER=${DB_USER:-redmine}
MYSQL_PASSWORD=${DB_PASS:-redminepass}

cd /home/redmine

cat <<EOF > config/database.yml
production:
  adapter: mysql2
  database: $MYSQL_DATABASE
  host: $MYSQL_HOST
  username: $MYSQL_USER
  password: $MYSQL_PASSWORD
  encoding: utf8
EOF

chown -R redmine:redmine .

bundle exec rake db:migrate RAILS_ENV="production" --trace

rake generate_secret_token --trace

exec sudo -u redmine -H ruby bin/rails server -e production -b 0.0.0.0

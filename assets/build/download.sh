#!/bin/sh

cd /home/

[ -z "$TAG" ] && \
TAG=`git ls-remote -t https://github.com/redmine/redmine.git | grep -v -e '\^{}' -e 'rc[0-9]*' -e 'pre' | grep -o '[0-9]\..*$' | tail -1`

echo "Downloading redmine ${TAG}"

sudo -u redmine -H git clone --depth 1 -b ${TAG} https://github.com/redmine/redmine.git redmine -v

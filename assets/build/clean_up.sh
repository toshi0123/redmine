#!/bin/sh

for fn in `find / -type f -name 'Makefile'`;do ( cd `dirname $fn`;make clean );done > make.log 2>&1

find / -type f -name '*.gem' | xargs rm -f

find /usr/lib/ruby/gems/ -type f -name '*.o' | xargs rm -f
find /usr/lib/ruby/gems/ -type f -name '*.a' | xargs rm -f
find /home/redmine/ -type f -name '*.a' | xargs rm -f

find /usr/lib/ruby/gems/*/gems/ -type f -name "*.so" -delete

rm -rf /root/.bundle/cache /home/redmine/.bundle/cache

find / -type f -name "*.rdoc" -delete
find / -type f -name "*.log" -delete

#!/bin/sh

cd /home/

[ -z "$TAG" ] && \
TAG=`git ls-remote -t https://github.com/redmine/redmine.git | grep -v -e '\^{}' -e 'rc[0-9]*' -e 'pre' | grep -o '[0-9]\..*$' | tail -1`

echo "Downloading redmine ${TAG}"

sudo -u redmine -H git clone --depth 1 -b ${TAG} https://github.com/redmine/redmine.git redmine -v

cd /home/redmine/public/themes
while read line;do
 sudo -u redmine -H git clone --depth 1 -v $line
done<<EOF
https://github.com/tsi/redmine-theme-flat.git
https://github.com/akabekobeko/redmine-theme-minimalflat2.git
https://github.com/hardpixel/minelab.git
https://github.com/makotokw/redmine-theme-gitmike.git
EOF

cd /home/redmine/plugins
while read line;do
 sudo -u redmine -H git clone --depth 1 -v $line
done<<EOF
https://github.com/onozaty/redmine-view-customize.git
https://github.com/sciyoshi/redmine-slack.git
https://github.com/hokkey/redmine_chatwork.git
https://github.com/hidakatsuya/redmine_default_custom_query.git
https://github.com/akiko-pusu/redmine_issue_templates.git
https://github.com/alexbevi/redmine_knowledgebase.git
https://github.com/paginagmbh/redmine_lightbox2.git
https://github.com/Restream/redmine_tagging.git
EOF

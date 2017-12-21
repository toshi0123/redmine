#!/bin/sh

cd /home/

[ -z "$TAG" ] && \
TAG=`git ls-remote -t https://github.com/redmine/redmine.git | grep -v -e '\^{}' -e 'rc[0-9]*' -e 'pre' | grep -o '[0-9]\..*$' | tail -1`

echo "Downloading redmine ${TAG}"

sudo -u redmine -H git clone --depth 1 -b ${TAG} https://github.com/redmine/redmine.git redmine -v

cat <<EOF | patch -N /home/redmine/lib/redmine/wiki_formatting/macros.rb
--- macros.rb.org
+++ macros.rb
@@ -168,6 +168,11 @@
         )
       end

+      desc "BR."
+      macro :BR do |obj, args|
+        raw "<BR>"
+      end
+
       desc "Displays a list of all available macros, including description if available."
       macro :macro_list do |obj, args|
         out = ''.html_safe
EOF

cd /home/redmine/public/themes
while read line;do
 sudo -u redmine -H git clone --depth 1 -v $line
done<<EOF
https://github.com/tsi/redmine-theme-flat.git
https://github.com/hardpixel/minelab.git
https://github.com/makotokw/redmine-theme-gitmike.git
EOF

cd redmine-theme-flat
sed -i '/^@import url(.https:/s|^|//|g' sass/application.scss stylesheets/application.css
cd -

wget https://github.com/akabekobeko/redmine-theme-minimalflat2/releases/download/v1.3.5/minimalflat2-1.3.5.zip -O minimalflat.zip
unzip minimalflat.zip
rm -f minimalflat.zip

cd /home/redmine/plugins
while read line;do
 sudo -u redmine -H git clone --depth 1 -v $line
done<<EOF
https://github.com/hokkey/redmine_chatwork.git
https://github.com/hidakatsuya/redmine_default_custom_query.git
https://github.com/akiko-pusu/redmine_issue_templates.git
https://github.com/paginagmbh/redmine_lightbox2.git
https://github.com/Restream/redmine_tagging.git
https://github.com/ncoders/redmine_local_avatars.git
https://github.com/haru/redmine_theme_changer.git
https://github.com/suer/redmine_absolute_dates.git
https://github.com/akiko-pusu/redmine_banner.git
https://github.com/suer/redmine_issues_summary_graph.git
https://github.com/Loriowar/redmine_issues_tree.git
https://github.com/ameya86/redmine_maintenance.git
https://github.com/deecay/redmine_pivot_table.git
https://github.com/tkusukawa/redmine_wiki_lists.git
https://github.com/bdemirkir/sidebar_hide.git
EOF

sudo -u redmine -H git clone --depth 1 -v https://github.com/sciyoshi/redmine-slack.git redmine_slack
sudo -u redmine -H git clone --depth 1 -b develop -v https://github.com/TheMagician1/redmine_backlogs.git

cat <<EOF | patch -N /home/redmine/plugins/redmine_backlogs/lib/backlogs_setup.rb
--- backlogs_setup.rb.org
+++ backlogs_setup.rb
@@ -30,14 +30,7 @@
   module_function :"development?"

   def platform_support(raise_error = false)
-    travis = nil # needed so versions isn't block-scoped in the timeout
-    begin
-      ReliableTimout.timeout(10) { travis = YAML::load(open('https://raw.githubusercontent.com/themagician1/redmine_backlogs/master/.travis.yml').read) }
-      Rails.logger.warn "Used remote travis.yml"
-    rescue => e
-      travis = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', '.travis.yml')).read)
-      Rails.logger.warn "Used local travis.yml: #{e}"
-    end
+    travis = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', '.travis.yml')).read)

     matrix = []
     travis['rvm'].each{|rvm|
EOF

ls -l /home/redmine/plugins/redmine_backlogs/lib/

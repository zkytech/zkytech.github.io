#!/bin/sh
unset GIT_DIR
TMP_GIT_CLONE=/srv/tmp/hexo_blog_source
PUBLIC_WWW=/var/www/blog
GIT_REPO=/srv/gitrepo/hexo_blog_source.git
PUBLIC_PATH=/srv/tmp/hexo_blog_source/public

echo "ffffff" > log
cd ${TMP_GIT_CLONE} 
git pull
yarn install 
hexo grm -rf ${PUBLIC_WWW}
cp -rf ${PUBLIC_PATH} ${PUBLIC_WWW}
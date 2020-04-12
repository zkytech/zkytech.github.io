#!/bin/sh
unset GIT_DIR
unset $(git rev-parse --local-env-vars)
TMP_GIT_CLONE=/srv/tmp/hexo_blog_source
PUBLIC_WWW=/var/www/blog
GIT_REPO=/srv/gitrepo/hexo_blog_source.git
PUBLIC_PATH=/srv/tmp/hexo_blog_source/public
echo 进入工作目录${TEMP_GIT_CLONE}
cd ${TMP_GIT_CLONE} 
echo 开始同步...
git pull
echo 更新依赖...
yarn install 
echo 更新页面...
hexo g
rm -rf ${PUBLIC_WWW}
cp -rf ${PUBLIC_PATH} ${PUBLIC_WWW}
echo 完成发布...
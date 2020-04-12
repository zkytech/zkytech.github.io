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
echo 设定git参数...
git config --global user.mail "zhangkunyuan@hotmail.com" 
git config --global user.name "zkytech"
echo 开始部署到github pages 以及 coding pages
hexo d
echo 推送sitemap到百度
curl -H 'Content-Type:text/plain' --data-binary "${TMP_GIT_CLONE}/public/sitemap.xml" "http://data.zz.baidu.com/urls?site=https://blog.zkytech.top&token=O5pZwxEz87RWR2jB"
rm -rf ${PUBLIC_WWW}
cp -rf ${PUBLIC_PATH} ${PUBLIC_WWW}
echo 完成发布!!!!
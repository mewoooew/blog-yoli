#!/bin/bash
# 使用方法:
# yoli.sh "提交说明的内容"
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

cp -rf ./content/zh/posts/* ./content/en/posts/

# 清除缓存
git rm -rf --cached $(git ls-files)
# 提交内容
git add .
# 提交说明
# $#表示提供的参数个数
# $1表示提供的第一个参数
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# 推送到远程仓库
git push -u origin master
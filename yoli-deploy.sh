#!/bin/bash
# 使用方法:
# 第一次使用时先赋予脚本执行权限
# (./表示当前目录,不加系统会去PATH找, 而当前目录并不在PATH中):
# chmod +x ./yoli-deploy.sh
# 之后每次执行只需要:
# ./yoli-deploy.sh

# If a command fails then the deploy stops
set -e

# 在命令行输出绿色提示"Deploying updates to GitHub..."
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# 将中文目录下的文章复制到英文目录下
cp -rf ./content/zh/posts/* ./content/en/posts/

# 清除缓存
git rm -rf --cached $(git ls-files)

# 提交内容
git add .

# 提交说明
# $#表示提供的参数个数
# $1表示提供的第一个参数
msg="publish new post `date`"
if [ $# -eq 1 ]
  then msg=""$1" `date`"
fi
git commit -m "$msg"

# 推送到远程仓库
git push -u origin master
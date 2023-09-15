# ! /bin/bash
# 使用方法:
# 第一次使用时先赋予脚本执行权限
# (./表示当前目录,不加系统会去PATH找, 而当前目录并不在PATH中):
# chmod +x ./yoli-post.sh
# 之后每次执行只需要:
# ./yoli-post.sh "文件名"

# If a command fails then the deploy stops
set -e

cd ~/echoo/blog-yoli/
# 在命令行输出绿色提示"new post..."
echo -e "\033[0;32m new post...\033[0m"

if [ $# -eq 1 ]
  then 
    postfilename="$1" 
  else 
    # 输入文件名
    echo -e "\033[0;32m input file name: \033[0m"
    echo -e "\033[0;32m (enter will set name as draft) \033[0m"
    read postfilename
fi

# 选择文章分类 1 broken-thoughts | 2 pocket-book | 3 time-machine
echo -e "\033[0;32m input number to chose ONE category in: \033[0m"
echo -e "\033[0;33m 1 broken-thoughts | 2 pocket-book | 3 time-machine  \033[0m"
read category
# 设置默认分类
default_category="broken-thoughts"
case $category in
  1)  category="broken-thoughts"
  ;;
  2)  category="pocket-book"
  ;;
  3)  category="time-machine"
  ;;
  "") 
      # 为空则归到默认分类
      echo -e "\033[0;31m no input detected \n\033[0m"
      echo -e "\033[0;32m archive to ideas \033[0m"
      category=$default_category
  ;;
  *)  # 未在指定范围内, 归到默认分类
      echo -e "\033[0;31m input error \n\033[0m"
      echo -e "\033[0;32m archive to default_category: broken-thoughts \n \033[0m"
      category=$default_category
  ;;
esac

# 自定义文件名
isold="f"
if [ $postfilename ]
then 
  # 如果存在相似文件名
  if [ -e "./content/zh/posts/$category/"*"-$postfilename.md" ]  
  then 
    # 询问重新建立文件名还是打开已有文件
    echo -e "\033[0;32m the name already exists, suggest a new name(n), or open the existed file(*)"
    read isold

    if [[ $isold != "n" ]]
    then
      isold="e"
      echo -e "\033[0;32m will open the existed file \033[0m"
    fi

    # 若选择新建 则执行循环直到不重名为止
    while [ $isold = "n" ]
    do 
      echo -e "\033[0;32m last name already exists, input a new one: \033[0m"
      echo -e "\033[0;32m (enter will set name as draft) \033[0m"
      read postfilename

      if [ $postfilename ]
      then
        if [ -e "./content/zh/posts/$category/"*"-$postfilename.md" ]
        then
          isold="n"
        else
          isold="f"
        fi
      else
        isold="d"
        postfilename="draft"
        echo -e "\033[0;32m set as a draft \033[0m"
      fi 
    done 
  fi
else 
  # 文件名为空则命名为"日期-草稿"
  isold="d"
  postfilename="draft"
fi

# 获取日期字符串作为前缀
today=$(date -d "now" +%Y-%m-%d)

# 建立路径
case $isold in
  "e")
    # 如果已选择打开已有文件,则不进行新的创建
    echo -e "\033[0;32m post file already exists \033[0m"
    dirfile="./content/zh/posts/$category/"*"-$postfilename.md"
  ;;
  "d")
    # 根据分类和文件名建立路径
    postfilename=""$today"-draft.md"
    dirfile="./content/zh/posts/"$category"/"$postfilename""
    # 如果已存在当日草稿 则不进行创建
    if [ -e $dirfile ]
    then
      echo -e "\033[0;32m draft already exists \033[0m"
    else
      hugo new posts/$category/$postfilename
    fi
  ;;
  "f")
    postfilename=""$today"-"$postfilename".md"
    # 根据分类和文件名创建新文章
    dirfile="./content/zh/posts/$category/$postfilename"
    hugo new posts/$category/$postfilename
  ;;
esac

# 用typora对文档进行编辑
echo -e "\033[0;32m edit "$dirfile"... \033[0m"
echo -e "\033[0;32m start with typora... \033[0m"
typora $dirfile

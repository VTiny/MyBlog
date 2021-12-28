#!/bin/sh
# 博客工程，本地Markdown展示时和远程根据代码仓库展示所使用的内容格式不同，此脚本处理两种情况的内容转换
#
# 参数说明：
#   -l 转换成本地样式
#   -r 转换成远程(代码仓库)样式
#   -s 默认扫描的为html，加-s后表示扫描源码(markdown文件)
#
# 转换内容说明：
#   本地：
#     - public文件夹下自己图片使用相对路径 <img src="/images/image
#   远程:
#     - public文件夹下自己图片使用绝对路径 <img src="/images/image
#
# DEMO
# workspace=$(pwd)
# sh "$workspace"/shell/blog_transformer.sh -r "$workspace"/blog

localImageLabel="<img src\=\"\.\.\/images\/image"
remoteImageLabel="<img src=\"\/images\/image"

localMarkdownLabel="](\.\.\/images\/image"
remoteMarkdownLabel="](\/images\/image"

# $1 目录位置
# $2 原始字符串
# $3 修改后的字符串
replaceString() {
  for item in "$1"/*; do
    if [ -d "$item" ]; then
      replaceString "$item" "$2" "$3"
    elif [ -f "$item" ] && [ "$(grep -c "$2" "$item")" -ne '0' ]; then
      echo "  processing file:$item"
      sed -i "" "s/$2/$3/g" "$item"
    fi
  done
}

while getopts "r:l:s:h" cmd; do
  case $cmd in
  r)
    echo ">>> Transform to remote start..."
    replaceString "$OPTARG" "$localImageLabel" "$remoteImageLabel"
    echo ">>> Transform to remote style success."
    ;;
  l)
    echo ">>> Transform to local start..."
    replaceString "$OPTARG" "$remoteImageLabel" "$localImageLabel"
    echo ">>> Transform to local style success."
    ;;
  s)
    echo ">>> Transform markdown source code..."
    replaceString "$OPTARG" "$remoteImageLabel" "$localImageLabel"
    replaceString "$OPTARG" "$remoteMarkdownLabel" "$localMarkdownLabel"
    echo ">>> Transform markdown source code success"
    ;;
  h)
    echo help
    ;;
  esac
done

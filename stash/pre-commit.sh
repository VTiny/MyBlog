#!/bin/sh
#
# use absolute path for image resource in websites
#

localImageLabel="<img src\=\"\.\.\/images\/image"
remoteImageLabel="<img src=\"\/images\/image"

# $1 目录位置
# $2 原始字符串
# $3 修改后的字符串
replaceString() {
  for item in "$1"/*; do
    if [ -d "$item" ]; then
      replaceString "$item" "$2" "$3"
    elif [ -f "$item" ]; then
      echo "process file: $item"
#      echo "  processing file:$item"
#      sed -i "" "s/$2/$3/g" "$item"
#      git add "$item"
    fi
  done
}

echo ">>> Transform image resources of RELATIVE PATH into ABSOLUTE PATH starts..."
echo path: "$(pwd)"
replaceString "$(pwd)/blog" "$localImageLabel" "$remoteImageLabel"
replaceString "$(pwd)/public/blog" "$localImageLabel" "$remoteImageLabel"
echo ">>> Transform image resources success."


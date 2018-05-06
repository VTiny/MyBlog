---
title: Git将修改提交到已经commit的n次提交之前
date: 2018-04-02 11:55:12
update: 2018-04-02
comments: true
tags: [Git, shell]
categories: Tools
id: git-commit-to-swh
---

在使用git的过程中，遇到了想把新的修改添加到之前的提交中的情况。如果想追加到最后一次提交，那很好办，直接``git commit --amend``就可以；如果想提交到之前的某次提交，那就有点麻烦了

<!---more--->

### 想法1: 使用stash （❌）

#### 1.1 实现步骤：

1. 依次将倒序过去的每次提交`git reset --soft`后用stash存起来
2. 将要追加的修改`commit —amend`添加进去
3. 依次将每个`stash pop`应用出来

#### 1.2 遇到的问题：

1. 使用stash保存，发现apply的时候需要重新commit，达不到好的自动化效果
2. reset的时候需要将每次commit的信息保存好，再次commit的时候使用，麻烦



### 想法2: 使用patch+stash （✅）

#### 2.1 实现步骤：

1. 将现有修改stash贮存
2. 将距离目标commit中间的若干提交生成patch
3. 将仓库`reset --hard`到目标commit
4. 应用stash，追加到目标commit
5. 将patch恢复，删除缓存patch文件

#### 2.1 具体实现：

```shell
#!/usr/bin/env bash

##
# 参数为倒数第n次提交
##

# 判断参数是否合法
if [ $# == 0 ] ;then
    echo "there should be an args"
    exit
fi

if [ $1 == "help" ] ;then
    echo "将现有修改提交到n次提交之前"
    echo "比如commit1<-commit2<-commit3,提交到commit1,则参数为2"
    exit
fi

if [ $1 -gt 0 ] 2>/dev/null  ;then
    echo "git add to commit HEAD~$a"
else
    echo "$1 should be a number"
    exit
fi


# 正题
n=$1
# 将现有修改添加到stash
git add .
git stash
# 将中间n次提交打patch
git format-patch HEAD~$n --numbered-files -o ~/patchtemp
# 将git强制reset到n次提交之前
git reset --hard HEAD~$n
# 将stash应用,并添加到目标提交
git stash apply stash@{0}
git add .
git commit --amend
# 将各个patch恢复
declare -i i=1
while((i<=$n))
do
    git am -s < ~/patchtemp/$i
    let ++i
done
# 删除patch
rm -r ~/patchtemp

```


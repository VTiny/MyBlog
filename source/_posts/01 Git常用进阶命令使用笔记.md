---

title: Git常用进阶命令使用笔记
date: 2018/1/10
updated: 2018/1/10
comments: true
tags: Git
categories: Tools
id: git-advanced-command-note
---

本文记录了使用git过程中常用的命令，因git基础命令多数人都知道，所以把常用的进阶命令写在前面，也当作是自己的笔记。文章中间有几个使用git遇到的小问题，还挺有意思，给出我的解决方案作为参考～

<!---more--->

> 建议多查官网  
>
> https://git-scm.com/book  
> https://git-scm.com/book/zh/v2

## 常用进阶命令

#### 1. 修改仓库/分支信息

```shell
git remote set-url origin https://xxx.git    #修改整个仓库的远程位置
git branch --set-upstream-to=origin/master   #修改当前分支关联的远程分支
```

#### 2. 修改提交信息(commit message)

```shell
git commit --amend      #修改上一次提交的commit message
git rebase -i HEAD~n    #修改上n次提交的commit message（也可以用来删除某次提交）
```

#### 3. 将修改追加到上次到提交

```shell
git add . 
git commit --ammend     #多用途
```

#### 4. 撤销add

```shell
git reset HEAD                     #全部撤销
git reset HEAD your_file_path      #撤销单个文件
```

#### 5. 查看git信息

```bash
git config --list   #查看git整体配置信息列表
git remote -v       #查看远程仓库地址
git branch -v       #查看本地分支&基本信息
git branch -vv      #比上条多了关联的远程分支（pull/fetch的分支）
git branch -r       #查看所有远程分支
git branch -a       #查看所有分支
```

#### 6. stash

```shell
git stash
git stash save "message"    #将stash命名为message
git stash save -a "message" #将git忽略的文件也stash，不常用
git stash list              #stash列表
git stash pop               #将stash第0条应用并删除
git stash apply stash@{2}   #将index=2的stash应用
```

#### 7. patch

```shell
git format-patch HEAD^        #HEAD的patch
git format-patch HEAD^^       #HEAD和前一个的patch
git format-patch HEAD~$n -o ~/patchdir       #将前n次提交打patch，保存到～/patchdir目录下
git format-patch HEAD~$n --numbered-files    #将前n次提交打patch，文件名保存为数字
git apply --stat xxx.patch    #检查patch
git apply --check xxx.patch   #查看是否能应用成功
git am -s < xxx.patch         #应用patch
```

#### 8. 创建新分支

```shell
git checkout -b feature/dev_liuxiao
git checkout -b feature/dev_liuxiao --track origin/master #基于远程跟踪分支master创建本地分支
```

#### 9. pull/fetch/push

```shell
#1. pull
git pull origin master:dev                  #拉取远程master分支，和本地dev分支合并
git pull --rabase origin master:dev         #拉取远程master分支，和本地dev分支使用rebase的方式合并
#如果本地和远程分支之间存在追踪关系（tracking），可以省略分支名
git pull origin
git branch --set-upstream dev origin/master #将本地dev分支建立远程追踪分支为origin/master

#2. fetch 
#pull相当于fetch+merge
git fetch origin            #拉取远程更新
git merge origin/master     #将远程更新合并到本地当前分支

#3. push
#-u
git push -u origin dev      #将本地dev分支push到远端
#-u 相当于 没有参数+upstream
git branch --set-upstream dev origin/master
git push origin dev
#-f
git push -f origin dev      #将本地dev分支强行push到远端，冲突强行覆盖（保护的分支需要权限）
#如果本地分支名和远程目标分支名不同
git push origin HEAD:master
```

#### 10. 删除

```shell
git clean -f      #删除untracked files
git clean -f -n   #查看会删除的files
git clean -f -d   #删除untracked文件夹
```

#### 11. log

```shell
git reflog        #历史记录
                  #可以拿到已经回滚reset过的提交的id，通过git reset id，可以把回滚过的提交找回
```



## 可思考/研究的常见问题

#### 1. 如何删除一个远程分支？

```shell
#方式1. git UI操作，通常在setting/branches中
#方式2. 将一个空目录提交到制定远程
git push origin:dev
#方式3. delete参数
git push origin -delete dev
```

#### 2. 如何将修改追加到已经push了的n次提交之前？



## 基础

#### 1. 安装git环境
```shell
sudo apt-get install git-core     #windows在官网下载环境
```

#### 2. 创建代码仓库

- 配置身份

```java
git config --global user.name "liushaox"
git config --global user.email "liushaox@163.com"
```

- 查看身份

```java
git config --global user.name
git config --global user.email
```

- 初始化为git文件夹

```java
git init
```

#### 3. 提交本地代码

```shell
git add AndroidMainfest.xml    #添加单个文件
git add src                    #添加单个文件夹
git add .                      #添加所有文件
git commit -m "first commit"   #添加提交描述信息
```

#### 4. 状态相关

```shell
git status    #查看git状态，包括commit、修改、冲突等
git diff      #查看更改内容
git diff app/src/main/java/activity/MainActivity.java   #查看单个文件更改内容
```
#### 5. 常见操作流程

```shell
# clone
git clone https://xxx.git
# 第一次上传
git init
git add . 
git commit -m "commit message"
git remote add origin https://xxx.git
git push -u origin master
# 以后上传
git add . 
git commit -m "commit message"
git push -u origin master
```
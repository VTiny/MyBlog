---
title: Git Submodule 使用笔记
date: 2019-03-05
update: 2019-08-16
comments: true
tags: Git
categories: Tools
id: git-submodule-note
---
在学习和工作中，经常会遇到一个Git仓库中要引入另一个Git仓库，或者工程中的一部分代码在单独的Git仓库管理更清晰的情况，如：

- 整个博客工程对应了一个Git仓库，但展示需要的只是其中一部分，部署在一个单独的Git仓库更合适
- 实际工作中负责新闻客户端的开发，需要本地集成前端模板，由前端同学维护，是一个独立的Git仓库

遇到这种情况，使用`submodule(子模块)`的方式集成到主工程中较好。因为平时用得不多，命令总记不住，所以写个博客记录下～

<!---more--->

### 0. 相关资源

- `git submodule --help`
- [Git子模块 官方文档](https://git-scm.com/book/zh/v1/Git-工具-子模块)

### 1. 添加子模块

```shell
git submodule add ${submoduleRepositoryUrl}
```

运行后会将添加的子模块仓库clone到工程中，完成后会自动出现`.gitmodules`配置文件，格式如下

![image-20190816141645823](/images/image-20190816141645823.png)

### 2. 更新子模块`

#### 方式1 直接在主工程下更新子模块

```shell
git submodule update --remote ${submoduleName}
```

#### 方式2 在子模块工程下更新自己

```shell
cd ${submoduleName}
git pull #(or fetch + rebase ...)
```

### 3. 移除子模块

#### 方式1 直接在主工程操作

```shell
git rm -f ${submoduleName}
git rm -f --cached ${submoduleName} #在本地保留
```

#### 方式2 在配置文件中删除+操作文件

```shell
vi .gitmodules
vi .git/config
```

### 4. 克隆含有子模块的工程

#### 方式1 递归克隆

```shell
git clone --recursive ${repositoryUrl}
```

#### 方式2 克隆主工程后再拉取子模块

```shell
git clone ${repositoryUrl}
git submodule init
git submodule update
```




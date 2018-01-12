---
title: Hexo给博文加密
date: 2018/1/11
updated: 2018/1/11
comments: true
tags: Hexo
categories: Tools
---

博客当然也要有记录生活的功能，怎么能放心的记(tu)录(cao)生活而不担心被陌生人看到呢，那就需要对博文进行加密了。本文介绍了使用hexo-blog-encrypt插件完成对博文进行加密的方式，可以放心的写一些羞羞的事情了~

<!---more--->

通过hexo-blog-encrypt插件实现，插件github地址：https://github.com/MikeCoder/hexo-blog-encrypt ，上面有使用方式的介绍

### 1. 安装encrypt插件

在hexo根目录下的**package.json**中**dependencies**标签下添加：

```json
"hexo-blog-encrypt": "2.0.*"
```

更新环境安装插件

```shell
$ npm install 
```

### 2. 在配置文件中启用插件

在[站点配置文件](http://theme-next.iissnan.com/getting-started.html) **_config.yml**中启用插件，添加如下配置

```yaml
# Security
## Docs: https://github.com/MikeCoder/hexo-blog-encrypt
encrypt:
    enable: true
```

### 3. 使用encrypt插件加密文章

在文章头中添加password字段

```markdown
---
title: hello world
password: liushaoxia
abstract: 加密文章的简介
message: 输入密码上方的提示
---
```

### 4. live demo

demo: [博文加密测试](http://liushaox.com/2018/01/11/博文加密测试/) , 密码是**liushaoxia**

### 5. 高阶使用方式

可以对文章目录```TOC```进行加密、修改加密模板，具体方式转步插件作者wiki查看：

- github：https://github.com/MikeCoder/hexo-blog-encrypt/


- 中文版：https://github.com/MikeCoder/hexo-blog-encrypt/blob/master/ReadMe.zh.md


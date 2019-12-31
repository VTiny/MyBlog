---
title: Keynote使用笔记
date: 2019-08-14
update: 2019-08-14
comments: true
tags: [Tools, Keynote]
categories: Tools
id: note-keynote
---

#### 在演示期间显示鼠标

按下 `c` 键

#### 粘贴高亮代码块

首先安装 highlight 工具 

```shell
brew install highlight
```

先复制代码，接着执行如下代码，最后直接在 Keynote 中 Command + V 粘贴

```shell
# Dart语言、显示行号、字号23
pbpaste | highlight --syntax=dart --style=github --line-numbers --font=Monaco --font-size=23 -u "utf-8" --replace-tabs=4 --out-format=rtf --line-number-length=2 | pbcopy
```


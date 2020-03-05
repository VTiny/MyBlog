---
title: mac升级踩坑记录
date: 2019-10-30
update: 2019-10-30
comments: true
tags: [mac, macOS]
categories: mac
id: mac-reset-system-note
---

作为一个 IT 行业从业者，在新系统刚发布的时候当然忍不住第一时间更新，今年也是第一时间更新了 macOS Catalina (10.15) 系统，然而踩了坑，不但很多软件用不了，而且还一直在切焦点，无法正常使用，咋整？？？

<!---more--->



还好给自己留了一手，只升级了笔记本的系统，没有升级办公 Mac mini 的系统，还有的参考

想了三种方案：

1. 笔记本恢复出厂设置
2. 下载一个旧版本系统装到笔记本上
3. 将 Mac mini 使用 Time Machine 进行备份，然后把备份应用到笔记本

出于安全和方便的考虑，选择了第三种方案（使用 Time Machine），因为两台电脑的一些配置不同，在应用完成后还需要进行一些设置，操作实录如下

#### 1. 使用 Time Machine 恢复备份

https://support.apple.com/zh-cn/HT203981

#### 2. 修改用户名

`System Preference` -> `Users & Groups` -> `Advanced Options` -> `Full name`

#### 3. 修改主机名 (Terminal)

```shell
sudo scutil --set HOST liuxia
```

#### 4. 修改设备名

`System Preference` -> `Sharing` -> `Computer Name`

#### 5. 修改根目录

重命名根文件夹、System Preference -> Users & Groups -> Home directory
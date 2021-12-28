---
date: 2018-05-24
update: ':year-:month-:day'
comments: true
tags:
  - Shell
  - QR Code
categories: Shell
id: generate-qr-code-in-terminal
title: 在命令行(Terminal)中自动生成二维码
---
shell小白，此脚本实现的功能是在命令行中自动生成输入的文字/链接的二维码
<!---more---> 

### 相关资源

- brew: 或许是mac上安装软件最方便的方式？ https://brew.sh/
- qrencode: "a fast and compact QR Code encoding library" https://github.com/fukuchi/libqrencode

### 实现思路

1. 检测brew环境，若没有，则安装
2. 检测qrencode环境，活没有，则安装
3. 使用qrencode生成二维码，并打印

```shell
#!/usr/bin/env bash

#若没有brew环境，安装brew
if which brew > /dev/null ; then
    echo "brew has been installed."
else
    echo "brew not installed, install brew first."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

#若没有qrencode库，安装qrencode
if which qrencode > /dev/null ; then
    echo "qrencode has been installed."
else
    echo "qrencode not installed, install brew first"
    brew install qrencode
fi

#处理参数，获取要生成二维码的信息
if [ $# == 0 ]; then
    read -p "Enter message here: " message
elif [[ $1 == "help" ]] || [[ $1 == "--help" ]]; then
    echo "A tool for generating qr code."
    echo "Example usage:"
    echo "  qrcode \"http://www.163.com\""
    echo "  qrcode \"n 55!W\""
    echo "Further help:"
    echo "  qrcode help"
    echo "  qrcode --help"
    exit
elif [ $1 ]; then
    message=$1
fi

#打印二维码
echo $message | qrencode -o - -t UTF8
```

### 运行效果

![image-20190306111207633](../images/image-20190306111207633.png)
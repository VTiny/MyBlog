---
title: Mac执行定时任务
date: 2020-03-26
update: 2020-03-26
comments: true
tags: [Mac, Shell, 定时任务]
categories: Mac
id: mac-timer-task
---
作为一个懒人，让自己电脑定时执行一些任务（如运行脚本）是很常见的想法，比如前阵研究了下抓取，每天手动跑脚本太蠢了，自然而然的想法就是搞个定时任务，每天自动去跑，顺带着也有闹钟的作用

本文记录了如何通过 `launchctl` 在 Mac 上完成定时任务

<!---more--->

> [learn from here](https://www.jianshu.com/p/4addd9b455f2)
>
> `launchctl` 是一个统一的服务管理框架，可以启动、停止和管理守护进程、应用程序、进程和脚本等。
> launchctl是通过配置文件来指定执行周期和任务的。



#### Step0 准备工作

- 如果是希望直接打开程序，忽略此步骤
- 如果是希望执行自己的脚本类程序，自行完成



#### Step1 编写定时任务配置文件

`launchctl` 会根据 plist 配置文件信息来启动任务，常见的存放目录为：

- `/Library/LaunchDaemons`: 系统启动即会执行
- `/Library/LaunchAgents`: 用户登录后才会执行

完整的配置文件存放目录：

- `~/Library/LaunchAgents`: 用户自己定义的任务项
- `/Library/LaunchAgents`: 管理员为用户定义的任务项
- `/Library/LaunchDaemons`: 管理员定义的守护进程任务项
- `/System/Library/LaunchAgents`: 由 macOS 为用户定义的任务项
- `/System/Library/LaunchDaemons`: 由 macOS 定义的守护进程任务项

在相应的目录下新建自己的 plist 配置文件，文件名为 `${labelValue}.plist` ，内容为：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <!-- 唯一标志，需保证全局唯一 -->
    <key>Label</key>
    <string>com.mrliuxia.seeker.bilirank.plist</string>
    <!-- 指定使用命令的方式运行，参数和命令行相同，每一段为字符串数组的一项 -->
    <!-- 比如下面是执行 js 脚本的例子，同理也可以不是脚本，直接直接命令 -->
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/bin/node</string>
      <string>/Users/liuxia/Workspace/WebstormProjects/headless-nick/seeker/bili-tech-rank.js</string>
    </array>
    <!-- 指定要定时执行的时间 -->
    <key>StartCalendarInterval</key>
    <dict>
      <key>Minute</key>
      <integer>20</integer>
      <key>Hour</key>
      <integer>16</integer>
    </dict>
    <!-- 标准输出日志文件 -->
    <key>StandardOutPath</key>
    <string>/Users/liuxia/Workspace/WebstormProjects/headless-nick/seeker/outputs/autoRun.txt</string>
    <!-- 标准输出错误日志文件 -->
    <key>StandardErrorPath</key>
    <string>/Users/liuxia/Workspace/WebstormProjects/headless-nick/seeker/outputs/autoRun.err</string>
  </dict>
</plist>
```

plist 中支持两种执行时间的配置方式，可根据场景灵活选择：

- `StartInterval`: 指定脚本每间隔多久执行一次，单位：秒
- `StartCalendarInterval`: 指定脚本在具体时间执行，可包含的 key 如下
  - `Minute <integer>`
  - `Hour <integer>`(24-hour system)
  - `Day <integer>`
  - `Weekday <integer>`(0 and 7 are Sunday)
  - `Month <integer>`

plist 常见参数说明

- `Label`: 需保证全局危矣

- `Program`: 要运行的程序
- `ProgramArguments`: 命令语句
- `StartInterval`: 时间间隔，与 StartCalendarInterval 使用其中一个
- `StartCalendarInterval`: 运行的时间，与 StartInterval 使用其中一个；单个时间点使用 dict，多个时间点使用 array\<dict\>
- `StandardInPath StandardOutPath StandardErrorPath`: 日志文件
- 启动定时任务时，如果涉及网络，但 mac 处于睡眠状态，是无法执行的（可通过定时启动屏幕来解决）



#### Step2 加载定时任务配置

```shell
➜  ~ launchctl load -w com.mrliuxia.seeker.bilirank.plist
```

完工，大吉大利

更多命令：

```shell
# 加载任务，-w 含义为将 plist 中无效的 key 覆盖掉，建议加上
➜  ~ launchctl load -w com.mrliuxia.seeker.bilirank.plist
# 删除任务
➜  ~ launchctl unload -w com.mrliuxia.seeker.bilirank.plist
# 查看任务列表，可配合 grep 命令过滤
➜  ~ launchctl list
# 开始任务
➜  ~ launchctl start com.mrliuxia.seeker.bilirank.plist
# 结束任务
➜  ~ launchctl stop com.mrliuxia.seeker.bilirank.plist
```

> - 如果任务被修改了，那么必须先 unload，再重新 load
> - start 可用于测试任务，效果为立即执行，无论时间是否符合条件
> - 在执行 start 和 unload 前，任务必须先 load 过，否则报错
> - stop 可以停止任务
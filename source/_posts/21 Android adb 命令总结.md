---
title: Android adb 命令总结
date: 2020-03-04
update: 2020-03-04
comments: true
tags: [Android, Shell]
categories: Android
id: android-adb-command-summary
---
Android Debug Bridge (adb) 是 Android 开发中常用的命令行工具，可以与设备进行通信。本文记录了常用的 adb 命令，其中重点会用 ❗️ 标出，“骚操作”会用 🌟 标出
<!---more--->



> [官方文档 - Android Debug Bridge](https://developer.android.com/studio/command-line/adb)

## 一. 工作环境

- adb 工具在 Android SDK 中，需配置环境变量
- ` ${android_sdk}/platform-tools` 目录下



## 二. 工作原理概述

> [官方说明](https://developer.android.com/studio/command-line/adb#howadbworks)

- 启动某个 adb 客户端，若未在运行，则启动服务器进程
- 服务器在启动后会与本地 TCP 端口 5037 绑定，监听 adb 客户端发出的命令，所有客户端均通过端口 5037 与 adb 服务器通信
- 扫描 5555 到 5585 间的端口，查找模拟器
- 偶数号端口用户控制台连接
- 奇数号端口用于 adb 连接



## 三. 通过 WLAN 连接到设备 🌟

一般情况下，adb 通过 USB 与设备进行通信，但也可以在通过 USB 完成一些初始设置后通过 WLAN 使用 adb 工具，步骤如下：

1. 将 Android 设备和 adb 主机连接到两者都可以访问的同一 WLAN 网络
2. 使用 USB 数据线将设备连接到主机
3. 使用命令 `adb tcpip 5555` 设置目标设备监听 5555 端口上的 TCP/IP 连接
4. 拔掉与目标设备相连的数据线
5. 找到 Android 设备的 IP 地址
   - 通过手机自身设置（我的测试机可在 关于手机 - 状态消息 - IP 地址 中找到）
   - 通过 adb shell 命令行，`ifconfig wlan0`
6. 使用命令 `adb connect ${device_ip_address}` 来连接到设备
7. 确认主机已连接到目标设备

```shell
➜  ~ adb devices
List of devices attached
${device_ip}:5555	device
```

🌟 因为 Android Studio 的 debug 调试，也是通过 ADB Server 与 设备间的通信来完成的，所以如上设置成功后，不用连接数据线即可 debug 调试代码！



## 四. 命令小全

### 1. 启动与关闭

```shell
# 启动 adb
➜  ~ adb start-server 
# 杀死 adb
➜  ~ adb kill-server 
```

### 2. 列出设备

```shell
➜  ~ adb devices
List of devices attached
B2T7N16711003140	device
${device_ip}:5555	device

➜  ~ adb devices -l
List of devices attached
B2T7N16711003140       device usb:338690048X product:EVA-TL00 model:EVA_TL00 device:HWEVA transport_id:4
${device_ip}:5555    device product:EVA-TL00 model:EVA_TL00 device:HWEVA transport_id:3
```

### 3. 安全应用

```shell
➜  ~ adb install ${apk_file_path}

# 安装测试APK
➜  ~ adb -t install ${apk_file_path}
```

### 4. 设置端口转发

将对特定主机端口上的请求转发到设备上的其他端口

```shell
# 设置主机端口 6100 到设备端口 7100 的转发
➜  ~ adb forword tcp:6100 tcp:7100

# 设置主机端口 6100 到 local:logd 的转发
➜  ~ adb forword tcp:6100 local:logd
```

### 5. 与设备传输文件

```shell
# 从设备复制文件 或 目录及其子目录
➜  ~ adb pull ${remote} ${local}

# 将文件 或 目录及其子目录 复制到设备
➜  ~ adb push ${local} ${remote}
```

### 6. 发出 adb 命令

```shell
➜  ~ adb [ -d | -e | -s ${serial_number}] ${command}
```

### 7. 发出 shell 命令

```shell
# 可以使用 shell 命令，通过 adb 发出命令
➜  ~ adb [ -d | -e | -s ${serial_number}] shell ${shell_command}

# 也可以启动交互式 shell
➜  ~ adb [ -d | -e | -s ${serial_number}] shell
```

可以按 `Control + D` 或输入 `exit` 退出交互式 shell

#### 7.1 查看可用的工具列表

```shell
➜  ~ db shell ls /system/bin
```

#### 7.2 Activity 管理器 - am

可以使用 am 工具发出命令以执行各种系统操作，如启动 Activity、强行停止进程、广播 intent、修改设备屏幕属性等，语法为: `adb shell am ${command}`

下面列出常用 Activity 管理器命令

##### 7.2.1 启动指定的 Activity 🌟

```shell
➜  ~ adb shell am start [${options}] ${intent}
```

常见 intent 参数的规范：

- `-a ${action}`: 指定 action 的 intent

- `-d ${data_uri}`: 指定数据 URI 的 intent (intent-filter scheme)
- `-f ${flags}`: 将标志添加到 setFlags() 支持的 intent
- `-e | --es ${extra_key} ${extra_string_value}`: 添加字符串数据
- `--ez ${extra_key} ${extra_boolean_value}`: 添加布尔值数据
- `--ei ${extra_key} ${extra_int_value}`: 添加整数数据
- `--el ${extra_key} ${extra_long_value}`: 添加长整数数据
- `--ef ${extra_key} ${extra_float_value}`: 添加浮点数数据
- `--eu ${extra_key} ${extra_uri_value}`: 添加 URI 数据

> [完整的 intent 参数规范](https://developer.android.com/studio/command-line/adb#IntentSpec)

🌟 通过 action 启动 Activity

```shell
➜  ~ adb shell am start -a android.intent.action.VIEW
```

🌟 通过 URI 启动 Activity (scheme 协议的方式)

```shell
➜  ~ adb shell am start -d newsapp://nc/doc/F6CM029U000189FH
```

##### 7.2.2 启动指定的 Service

```shell
➜  ~ adb shell am startservice [${options}] ${intent}
```

##### 7.2.3 强制关闭进程 🌟

```shell
# 强行停止与包名关联的所有进程
➜  ~ adb shell am force-stop ${package_name}
```

##### 7.2.4 安全终止进程

```shell
# 终止与包名关联的所有进程，仅可终止可安全终止且不会影响用户体验的进程
➜  ~ adb shell am kill [${options}] ${package_name}
```

选项如下：

- `--user ${user_id} | all | current`: 指定要终止哪个用户的进程，若未指定，则终止所有用户的进程

##### 7.2.5 终止所有后台进程

```shell
➜  ~ adb shell am kill-all
```

##### 7.2.6 开始监控崩溃或 ANR

```shell
➜  ~ adb shell am monitor
```

##### 7.2.7 控制应用的[屏幕兼容](https://developer.android.com/guide/topics/manifest/supports-screens-element#compat-mode)模式

```shell
➜  ~ adb shell am screen-compat { on | off } ${package_name}
```

##### 7.2.8 替换设备显示尺寸 🌟

```shell
➜  ~ adb shell am display-size [reset | ${width}x${height}]
➜  ~ adb shell am display-size 1280x880

# 若无效可使用 wm 命令
➜  ~ adb shell wm size [reset | ${width}x${height}]
```

##### 7.2.9 替换设备显示密度 🌟

```shell
➜  ~ adb shell am display-density ${dpi}
➜  ~ adb shell am display-density 480

# 若无效可使用 wm 命令
➜  ~ adb shell wm density [reset | ${dpi}]
```

> [所有可用的 Actiivty 管理器命令](https://developer.android.com/studio/command-line/adb#am)

#### 7.3 软件包管理器 -  pm

```shell
➜  ~ adb shell pm ${command}
```

##### 7.3.1 列出所有软件包

```shell
➜  ~ adb shell pm list packages [${options}] ${filter}
```

options:

- `-f`: 查看关联文件
- `-d`: 仅显示已停用的软件包
- `-e`: 仅显示已启用的软件包
- `-s`: 仅显示系统软件包
- `-3`: 仅显示第三方软件包
- `-i`: 查看软件包的安装程序
- `-u`: 包括写在的软件包
- `--user ${user_id}`: 要查询的用户空间

##### 7.3.2 输出所有已知权限组

```shell
➜  ~ adb shell pm list permission-groups
```

##### 7.3.3 输出所有已知权限

```shell
➜  ~ adb shell pm list permission [${options}] ${group}
```

options：

- `-g`: 按组进行整理
- `-f`: 输出所有信息
- `-s`: 简短摘要
- `-d`: 仅列出危险权限
- `-u`: 仅列出用户将看到的权限

##### 7.3.4 输出系统的所有功能

```shell
➜  ~ adb shell pm list features
```

##### 7.3.5 输出当前设备所有支持的库

```shell
➜  ~ adb shell pm list libraries
```

##### 7.3.6 输出系统中的所有用户

```shell
➜  ~ adb shell pm list users
```

##### 7.3.7 输出指定应用的安装包路径 🌟

```shell
➜  ~ adb shell pm path ${package}
```

##### 7.3.8 安装应用 ❗️

```shell
➜  ~ adb shell install [${options}] ${apk_path}
```

options:

- `-r`: 重新安装现有应用，保留其数据
- `-t`: 安装测试 APK
- `-d`: 允许版本代码降级
- `-g`: 收于应用清单中列出的所有权限
- `--fastdeploy`: 通过仅更新已更改的 APK 部分来快速更新安装的软件包

可简写为：

```shell
➜  ~ adb install [${options}] ${apk_path}
```

##### 7.3.9 卸载应用 ❗️

```shell
➜  ~ adb shell pm uninstall [${options}] ${package_name}
```

options:

- `-k`: 卸载后保留数据和缓存目录

可简写为：

```shell
➜  ~ adb uninstall [${options}] ${package_name}
```

##### 7.3.10 删除数据

```shell
➜  ~ adb shell pm clear ${package_name}
```

##### 7.3.11 向应用授予权限

```shell
➜  ~ adb shell pm grant ${package_name} ${permission_name}
```

##### 7.3.12 撤销授予应用的权限 🌟

```shell
➜  ~ adb shell pm revoke ${package_name} ${permission_name}
```

> [所有可用的包管理器命令](https://developer.android.com/studio/command-line/adb#pm)

#### 7.4 获取屏幕截图 🌟

截图格式默认为 png

```shell
➜  ~ adb shell screencap ${file_path}
```

可配合 pull 命令使用

```shell
➜  ~ adb shell screencap
/sdcard/com.netease.newsreader.activity/screenshot.png
➜  ~ adb pull /sdcard/com.netease.newsreader.activity/screenshot.png ~/Downloads/screenshot.png
```

#### 7.5 获取录屏 🌟

录屏默认格式为 MPEG-4 (mp4)

```shell
➜  ~ adb shell screenrecord [${options}] ${file_path}
```

按 `Command + C` 键停止录制视频，否则到三分钟，或 `--time-limit` 设置的时间限制时，录制将自动终止

screenrecord 的局限性：

- 音频不与视频文件一起录制
- 无法在 Wear OS 的设备上录制
- 某些设备啃根无法以她们本机的显示屏分辨率进行录制
- 不支持在录制时旋转屏幕

options：

- `--help`:  显示命令语法和选项
- `--size ${width}x${height}`: 设置视频分辨率
- `--bit-rate ${rate}`: 设置视频的视频比特率，默认4Mbps (400000000)
- `--time-limit ${time}`: 设置最大录制时长，最大值和默认值均为180 (3 分钟)
- `--rotate`: 将输出旋转 90 度
- `--verbose`: 在命令行屏幕显示日志信息

#### 7.6 不 root 读取 data 下应用所有数据 ❗️🌟

```shell
➜  ~ adb shell run-as ${package_name}
```

可结合 `cat` / `adb pull` 使用

#### 7.7 sqlite

- `sqlite3` 可启动用于检查 sqlite 数据库的 sqlite 命令行程序
- 包含用于输出表格内容的 `.dump` 以及用于输出现有表格的 `SQL CREATE` 语句的 `.schema` 等命令
- 也可以从命令行执行 SQLite 命令

```shell
➜  ~ adb -s emulator-5554 shell
➜  ~ sqlite3 /data/data/com.example.app/databases/rssitems.db
    SQLite version 3.3.12
    Enter ".help" for instructions
```

#### 7.8 logcat

```shell
➜  ~ adb logcat
➜  ~ adb logcat | grep ${keyword} > /Downloads/my_log.txt
```

> [logcat完整使用方式可参看此官方文档](https://developer.android.com/studio/command-line/logcat)


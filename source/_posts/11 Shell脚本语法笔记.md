---
title: Shell脚本笔记
date: 2019-02-07
update: 2019-02-07
comments: true
tags: [Shell, 编程语言]
categories: Shell
id: shell-programming-note
---


现在算是一个shell编程入了门的小菜鸟，本文是把学习、开发过程中遇到的一些常见的/有用的 语法/命令记录下来

<!---more--->

## Shell命令篇

> 一些常见的就不列举出来了，如`ls` `cd`等

#### dig

- 域名解析命令，可以看到域名状态、重定向等信息

```shell
dig www.mrliuxia.com
```

#### man

- 命令介绍手册，不过一些后安装的、非系统自带的命令不一定有，原理是要往系统的一个目录下写入类似于windows chm格式的说明文档

#### which

- 查找文件，会在环境变量$PATH设置的目录里查找符合条件的文件
- 常用于查看指令的绝对路径



## Shell编程语法篇

### while循环

```shell
while 条件
do
    ...
done
```

### for循环

```shell
# 将输入的所有参数组合起来
for args in $* ; do
    title=${title}${args}
done
```

### 写入文件

```shell
# 覆盖写入
echo "${content}" > ${filePath}
# 追加写入
echo "${content}" >> ${filePath}
```

### 整数相关

#### 自加

```shell
# 相加，4种方法，萝卜白菜
let a=$1+$2
b=$[$1+$2]
((c=$1+$2))
d=`expr $1 + $2`
# 自加1，6种方法
a=$(($a+1))
a=$[$a+1]
a=`expr $a + 1`
let a++
let a+=1
((a++))
```

#### 比较

```shell
# 等于
if [[ "$a" -eq "$b" ]]...
# 不等于
if [[ "$a" -ne "$b" ]]...
# 大于
if [[] "$a" -gt "$b" ]]...
# 大于等于
if [[ "$a" -ge "$b" ]]...
# 小于
if [[ "$a" -lt "$b" ]]...
# 小于等于
if [[ "$a" -le "$b" ]]...
# 也可以使用用符号，如
if [[ ${a}==${b} ]]...
if (("$a" != "$b"))...
```

#### 输入是否是整数

```shell
## 记录一种简单的方式
if [[ "$1" -gt 0 ]] 2>/dev/null ;then 
  echo "$1 is number." 
else 
  echo 'no.' 
fi 
```

### 字符串相关

#### 比较字符串

```shell
# 是否相等
if [[ "$a" = "$b" ]]...
if [[ "$a" == "$b" ]]...
```

####  是否为空

```shell
if [[ -z "$a" ]]...
if [[ -n "$a" ]]...
```

#### 反转字符串

```shell
# 判断是否是回文
function palindromic(){
    if [[ !(-z "$1") && $(rev <<< "$1") == "$1" ]]; then
        echo yes
    else
        echo no
    fi
}
```

#### 过滤字符串

```shell
# 将第一个参数过滤掉","
echo $1 | grep -v ","
```

#### 截取字符串

```shell
# 从第1个字符开始，截取a的两个字符
echo ${str:1:2}
# 截取最后两位
echo $str | sed 's//(.*/)/(../)$//'
```

#### IFS INIT_PATH

### 脚本常见开头

#### 判断参数个数

```shell
# 若参数个数小于2则报错
if [[ $# -lt 2 ]]; then
    echo -e "\033[31mError: need 2 args.\033[0m"
    exit 2
fi
```

#### 获取输入参数

```shell
# 获取-t -i参数
while getopts "t:p:g:c:i:" cmd
do
    case ${cmd} in
        t)
            title=${OPTARG};;
        i)
            id=${OPTARG};;
    esac
done
```

### 按行读文件

```shell
# 按行读文件并输出
cat $0 | while read lineNo
do
    echo "$lineNo"
done
# 使用awk
cat $0 | awk 'for(i=2;i<NF;i++) {printf $i} printf "\n"}'
```

### 附录

#### 1. 一元操作符

| 指令     | 含义                                                         |
| -------- | ------------------------------------------------------------ |
| -e       | 文件存在                                                     |
| -a       | 文件存在（已被弃用）                                         |
| -f       | 被测文件是一个regular文件（正常文件，非目录或设备）          |
| -s       | 文件长度不为0                                                |
| -d       | 被测对象是目录                                               |
| -b       | 被测对象是块设备                                             |
| -c       | 被测对象是字符设备                                           |
| -p       | 被测对象是管道                                               |
| -h       | 被测文件是符号连接                                           |
| -L       | 被测文件是符号连接                                           |
| -S(大写) | 被测文件是一个socket                                         |
| -t       | 关联到一个终端设备的文件描述符。用来检测脚本的stdin[-t0]或[-t1]是一个终端 |
| -r       | 文件具有读权限，针对运行脚本的用户                           |
| -w       | 文件具有写权限，针对运行脚本的用户                           |
| -x       | 文件具有执行权限，针对运行脚本的用户                         |
| -u       | set-user-id(suid)标志到文件，即普通用户可以使用的root权限文件，通过chmod +s file实 |
| -k       | 设置粘贴位                                                   |
| -O       | 运行脚本的用户是文件的所有者                                 |
| -G       | 文件的group-id和运行脚本的用户相同                           |
| -N       | 从文件最后被阅读到现在，是否被修改                           |

#### 2. 二元操作符

| 指令 | 含义     |
| ---- | -------- |
| -eq  | 等于     |
| -ne  | 不等于   |
| -gt  | 大于     |
| -ge  | 大于等于 |
| -lt  | 小于     |
| -le  | 小于等于 |

注释: shell中也支持`>` `>=` `<` `<=` `=` `==` `!=`操作符，其中`=`和`==`含义相同
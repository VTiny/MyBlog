---
title: 【不懂就记】Gradle implementation、api命令
date: 2018-07-29
update: 2018-07-29
comments: true
tags: [Android, Gradle]
categories: Android
id: android-gradle-implentation-api
---
发现Android Studio升级到3.0版本以后，新建工程默认的app包的build.gradle文件有点不认识了，长成这样，主要是implemention这个命令是什么鬼

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    implementation 'com.android.support:appcompat-v7:26.1.0'
    implementation 'com.android.support.constraint:constraint-layout:1.1.2'
    testImplementation 'junit:junit:4.12'
    androidTestImplementation 'com.android.support.test:runner:1.0.2'
    androidTestImplementation 'com.android.support.test.espresso:espresso-core:3.0.2'
}
```

<!---more--->

### 背景

Android Studio再升级到3.0版本后，gradle插件版本默认升级到了3.0.0版本，在此版本中不推荐使用gradle的compile命令，推荐使用implemention命令和api命令

### 文档资源

- [强推: Google I/O 2017 - Speeding Up Your Android Gradle Builds演讲关于Implemention和API的部分](https://www.youtube.com/watch?v=7ll-rkLCtyk&feature=youtu.be&t=22m20s)
- [Implementation vs API dependency (大概是把I/O演讲的整理记录了下)](https://jeroenmols.com/blog/2017/06/14/androidstudio3/)
- [记录的中文翻译版本](https://juejin.im/entry/59476897da2f60006786029f)
- [谷歌官方迁移(升级)到Android Plugin for Gradle3.0文档](https://developer.android.com/studio/build/gradle-plugin-3-0-0-migration#new_configurations)

### Implemention和API命令的使用

> 在I/O 2017的演讲中，演讲者将build一个工程比作是pay taxes，给人的感觉确实也是如此，构建工程的速度很重要，立个flag，过段时间整体研究下

#### api命令

和原来的compile命令完全相同

#### implemention命令

对于使用了该命令编译的依赖，对该项目有依赖的项目将无法访问到使用该命令编译的依赖中的任何程序，也就是将该依赖隐藏在内部，而不对外部公开

#### 例子

##### 1. 使用compile/api

```
A compile B
B compile C
```

那么A是可以直接调用C的方法的

##### 2. 使用implemention

```
A implemention B
B implemention C
```

- C的内部方法对B可见，对A不可见，即A不能直接调用C的方法
- **好处：在C源码发生变化的时候，只重新编译直接引用C的module(B)，A不重新编译，提高工程构建速度**


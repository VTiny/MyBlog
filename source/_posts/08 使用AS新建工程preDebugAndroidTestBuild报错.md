---
title: 使用AS新建工程preDebugAndroidTestBuild报错
date: 2018-07-29
update: 2018-07-29
comments: true
tags: [Android Studio, AS, Gradle]
categories: Android
id: android-studio-new-project-build-failed-preDebugAndroidTestBuild
---
使用Android Studio 3.0新建工程，一路默认走下来竟然报错了，报错内容：

```
Error:Execution failed for task ':app:preDebugAndroidTestBuild'.
> Conflict with dependency 'com.android.support:support-annotations' in project ':app'. Resolved versions for app (26.1.0) and test app (27.1.1) differ. See https://d.android.com/r/tools/test-apk-dependency-conflicts.html for details.
```

<!---more--->

> 文内图片找回中，七牛真坑，图片原外链不让访问，还不让下载

### 原因排查

>  吐槽：讲道理，怎么编译器新建一个默认工程还能报错啊，好吧，解决它

看报错信息，是``com.android.support:support-annotations``这个包引入了两个版本，看编译后的环境，确实如此

![20180729153284735777363.png](http://7xravb.com1.z0.glb.clouddn.com/20180729153284735777363.png)

默认的build.gradle dependencies标签下是这样的

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

排查后发现，``'com.android.support:appcompat-v7:26.1.0'``这里包含的是26.1.0版本的annotations包，而``'com.android.support.test:runner:1.0.2'``和``'com.android.support.test.espresso:espresso-core:3.0.2'``这两个用于测试的库包含27.1.1版本

### 解决问题

#### 方式1

如果需要用runner和espresso这两个用于测试的库，可以直接把这两行去掉，gralde文件变成：

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])
    implementation 'com.android.support:appcompat-v7:26.1.0'
    implementation 'com.android.support.constraint:constraint-layout:1.1.2'
    testImplementation 'junit:junit:4.12'
}
```

#### 方式2

声明runner和espress两个测试库不重复引入annotations包

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])Ω
    implementation 'com.android.support:appcompat-v7:26.1.0'
    implementation 'com.android.support.constraint:constraint-layout:1.1.2'
    testImplementation 'junit:junit:4.12'
    androidTestImplementation 'com.android.support.test:runner:1.0.2', {
        exclude module: 'junit'
        exclude group: 'com.android.support', module: 'support-annotations'
    }
    androidTestImplementation 'com.android.support.test.espresso:espresso-core:3.0.2', {
        exclude group: 'com.android.support', module: 'support-annotations'
    }
}
```

#### 方式3

强制声明最终引入的annotations包的版本

```groovy
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])Ω
    implementation 'com.android.support:appcompat-v7:26.1.0'
    implementation 'com.android.support.constraint:constraint-layout:1.1.2'
    testImplementation 'junit:junit:4.12'
    androidTestImplementation 'com.android.support.test:runner:1.0.2'
    androidTestImplementation 'com.android.support.test.espresso:espresso-core:3.0.2'

    androidTestImplementation('com.android.support:support-annotations:26.1.0') {
        force = true
    }

}
```

### 大吉大利

好了终于正常了，大吉大利

![20180729153284783623098.png](http://7xravb.com1.z0.glb.clouddn.com/20180729153284783623098.png)
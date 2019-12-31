---
title: 面向Java开发者的Dart使用建议
date: 2019-04-10
update: 2019-05-27
comments: true
tags: [Dart, Flutter]
categories: Language
id: dart-advice-for-java-developers
---

Flutter 发展的如火如荼，越来越多的开发者开始使用，Dart 作为它的编程语言，借鉴了很多 Java 的特性，并针对其被人诟病的地方做了大量的优化，以下列出一些针对 Java 开发者的 Dart 使用建议，包括书写思想、特殊语法等

<!---more--->



#### 面向对象

Dart 中的面向对象更加彻底

- null 、操作符、方法 都是对象



#### private

Dart 中没有 public private 关键字，私有通过标识符以下划线开头来表示



#### var dynamic

Dart中可以不指定变量类型，或指定为动态类型



#### 操作符

操作符是对象，也可以被重载



#### 字符串插值器

多使用字符串插值器，`${expression}` `$var`，少用 Java 中使用加号连接的方式



#### 方法是对象

灵活使用方法，方法可以赋值给变量，可以当作方法的参数



#### 更优雅的重载

Dart 中的方法重载于 Java 不同，个人更喜欢 Dart 的实现方式

- 可选位置参数

```dart
String say(String name, [String message, String device]) {
  /// ...
}
```

- 可选命名参数

```dart
updateProfileData(String nickName, {String avatar, int age}) {
  /// ...
}
```



#### `is` 与 `is!`

Dart 中有 `is!` 操作符，不需要 `!(object is String)` 这种方式



#### 级联操作符 `..`

- 在同一个对象上连续调用多个函数以及访问成员变量
- 避免创建临时变量，代码整洁流畅
- 严格来说，不是操作符，可以理解成Dart的语法糖

```dart
final Paint bgPaint = Paint()
   ..color = circleBgColor
   ..strokeWidth = strokeWidth
   ..style = PaintingStyle.stroke; 
```



#### 条件成员访问操作符 `?.`

- 和访问成员类似，但左面表达式为空则不执行后面的表达式，如foo?.bar，如果foo为空则返回空，否则返回bar成员
- 减少了大量的判空代码



#### 非空操作符`??` 

前面的表达式非空时才执行后面的表达式



#### 空赋值操作符`??=`

指定值为 null 的变量的值



#### 断言 Assert

- 如果条件表达式结果不满足需要，可以使用assert语句打断代码的执行
- 断言只在检查模式下运行有效
- 生产模式下，断言不会执行
- 断言检查失败，会抛出一个AssertionError异常
- 多用！



#### new关键字可省略



#### 异步支持

- Dart 是基于事件循环机制的单线程模型编程语言
- 有一些语言特性来支持异步，最常见的是 async 和 await 
- “Dart是单线程的”与“Dart支持异步”是不矛盾的
- 返回 Future 和 Stream 对象的方法

**踩坑**

- 请牢记，await、await for 表达式需要确保使用它的方法被 async 包裹！
- 不管有多少层调用，只要有一层没 async，后调用的就可能出现问题！
- 因为构造方法不能被 async，所以避免在构造方法中使用 await！



#### Effective Dart

- 类命名使用大驼峰，库、导入前缀和文件命名使用小写加下划线，常量使用小驼峰
- 要使用编译器格式化或 dartfmt 命令格式化代码
- 要使用 /// 文档注释来为成员和类型增加注释
- 定义字符串推荐多使用相邻字面量和插值器的方式，避免使用多余的大括号
- 要尽可能的使用集合字面量来定义集合
- 推荐使用 final 关键字来限定只读性
- 推荐使用箭头来实现只有一个单一返回语句的函数
- 不建议显示捕获 Error 及其子类
- 推荐使用 await async 完成异步，而不是使用底层的特性
- 不要在没有作用效果的情况下使用 async
- 要使用 getter 来定义访问属性的操作
- 避免在不必要的地方使用 dynamic 类型
- 要在复写 == 的同时复写 hashCode



#### 踩坑记录

- 不要在 Iterable.forEach() 中使用函数声明形式
- 如果想完成异步，包含 await 表达式的函数，包括间接调用的，都需要加上 async 标记
- 不要在 Iterable.forEach() 中使用 await 语句
- 不要在构造函数与内使用 await 语句



#### 个人建议

- 多看源码

- - 学习
  - 发现便捷的函数 list.isEmpty() 与 list.isNotEmpty()

- 理解面向对象

- - 操作符
  - 方法

- 多使用提供的语法糖，体验灵活性

- - ??=  ??  ..  ?.
  - getter setter 
  - 方法的可选参数

- 不影响阅读的前提下，尽可能简化代码

- - 私有方法，方法返回类型不需要声明

- 适合一个编译器窗口，左右同时打开两个文件写代码

- 不要把类和文件当作一个维度
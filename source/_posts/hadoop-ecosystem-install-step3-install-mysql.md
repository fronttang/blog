---
title: Hadoop生态系统安装 Step3：安装JDK（每台机器）
date: 2019-06-28 10:19:14
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
  - JDK
---

### 用戶：root

### 安裝包：jdk-8u121-linux-x64.rpm

### 配置方式：

#### 1. 安装之前先检查一下系统有没有自带 JDK

检查方式:

```
rpm -qa | grep jdk
```

如果是 openjdk 版本，需要卸载。
如果不是 openjdk,并且 JDK 版本>=1.6，可以保留使用，1.6 版本以下也需要卸载。

#### 2.（可选步骤）批量卸载所有带有 Java 的文件

```
rpm -qa | grep java | xargs rpm -e --nodeps
```

![image 1](1.jpeg)

#### 3. 创建 JAVA 目录

```
mkdir /usr/java
```

#### 4. 上传 jdk-8u121-linux-x64.rpm 到 JAVA 目录中

安装 JDK
命令:

```
chmod +x jdk-8u121-linux-x64.rpm
rpm -ivh jdk-8u121-linux-x64.rpm
```

#### 5. 配置系统变量

命令：

```
vi etc/provile
```

在最后加上：

```
export JAVA_HOME=/usr/java/jdk1.8.0_121\
export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib
export PATH=.:$JAVA_HOME/bin:$PATH
```

#### 6. 使设置生效

命令:

```
. /etc/profile
# (注意”.”和”/”中间有个空格)
```

#### 7. 检查安装是否成功

```
java -version
java
javac
echo $JAVA_HOME     # 检验变量值
java -version
$JAVA_HOME/bin/java -version  # 与直接执行 java -version 一样
```

![image 2](2.jpeg)

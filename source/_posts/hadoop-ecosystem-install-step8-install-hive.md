---
title: Hadoop生态系统安装 Step8：安装Hive
date: 2018-12-05 13:01:00
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
  - Hive
---

<!--more-->

### 用户：hadoop

### 说明：

### 安装包：apache-hive-2.1.1-bin.tar.gz

### 安装方式：

1. 将 hive 文件上传到/home/hadoop
2. 解压文件（解压即可，不需要安装，主要是做配置）

```
cd /home/hadoop/
tar zxvf apache-hive-2.1.1-bin.tar.gz
```

3. 删除安装包（可选，小心操作）

```
rm -rf apache-hive-2.1.1-bin.tar.gz
```

4. 添加快捷方式（可选）

```
ln -s apache-hive-2.1.1-bin hive
```

### 配置方式：

1. 创建 hive 数据库、用户并授予相应权限
   登陆录 mysql 主机，执行如下命令

```
mysql -uroot –pthinkive
create database hive;
alter database hive character set latin1;
CREATE USER hive@'%' IDENTIFIED BY 'hive';
flush privileges;
```

2、配置环境变量

```
vi .base_profile
# 添加内容
export HIVE_HOME=/home/hadoop/apache-hive-2.0.0-bin
export PATH=$PATH:$HIVE_HOME/bin
```

2. 修改 hive

```
cd /home/hadoop/apache-hive-2.1.1-bin/conf
cp hive-default.xml.template hive-site.xml
```

修改 hive-site.xml （见附件）

3. 修改 hive-env.sh

```
cp hive-env.sh.template hive-env.sh
# 编辑hive-env.sh
export HADOOP_HOME=/home/hadoop/hadoop-2.7.2
export HIVE_CONF_DIR=/home/hadoop/apache-hive-2.1.1-bin/conf
export HADOOP_CLASSPATH=.:$CLASSPATH:$HADOOP_CLASSPATH:$HADOOP_HOME/bin
```

4. 修改 hive-config.sh

```
cd /home/hadoop/apache-hive-2.0.0-bin/bin
vi hive-config.sh
# 末尾添加
export JAVA_HOME=/usr/java/jdk1.8.0_121
export HADOOP_HOME=/home/hadoop/hadoop-2.7.2
export HIVE_HOME=/home/hadoop/apache-hive-2.0.0-bin
```

5. 上传 mysql 驱动包
   将 mysql-connector-java-5.1.x-bin.jar 上传到 lib 目录下

6. 执行 hive 初始化脚本

```
./schematool -dbType mysql -initSchema
```

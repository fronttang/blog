---
title: Hadoop生态系统安装 Step11：安装Sqoop
date: 2019-06-28 16:24:49
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
  - Sqoop
---

<!--more-->

### 用户：hadoop

### 说明：

### 安装包：sqoop-1.4.6.tar.gz

### 安装方式：

1. 解压缩

   ```
   tar zxvf sqoop-1.4.6.tar.gz
   ```

2. 修改/etc/profile 增加配置 SQOOP_HOME,PATH

   ```
   vi .bash_profile
   export SQOOP_HOME=/home/hadoop/sqoop-1.4.6
   export LOGDIR=$SQOOP_HOME/logs
   export PATH=$PATH:\$SQOOP_HOME/bin
   ```

3. 修改配置文件\$SQOOP_HOME/conf/sqoop-env.sh

   ```
   cd /home/hadoop/sqoop-1.4.6/conf/
   cp sqoop-env-template.sh sqoop-env.sh
   vi sqoop-env.sh
   export HADOOP_COMMON_HOME=/home/hadoop/hadoop-2.7.2
   export HADOOP_MAPRED_HOME=/home/hadoop/hadoop-2.7.2
   export HBASE_HOME=/home/hadoop/hbase-1.2.1
   export HIVE_HOME=/home/hadoop/apache-hive-2.0.0-bin
   ```

4. 修改\$SQOOP_HOME/bin/configure-sqoop

   ```
   cd /home/hadoop/sqoop-1.4.6/bin/
   vi configure-sqoop
   去掉：HCAT_HOME，ACCUMULO_HOME，ZOOKEEPER_HOME
   ```

5. 上传 lib 包
   将 oracle/mysql 驱动包 lib 目录下

6. 测试
   ```
   sqoop version
   ```
   ![image 1](1.jpeg)

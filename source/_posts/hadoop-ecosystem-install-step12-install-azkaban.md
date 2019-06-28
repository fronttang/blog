---
title: Hadoop生态系统安装 Step12：安装Azkaban
date: 2019-06-28 16:28:18
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
  - Azkaban
---

<!--more-->

### 用户：hadoop

### 说明：

### 安装包：

azkaban-executor-server-2.5.0.tar.gz
azkaban-web-server-2.5.0.tar.gz
以上两个程序上传到 hadoop-master-002
azkaban-sql-script-2.5.0.tar.gz
上传到 mysql 服务器 hadoop-slave-001

### 安装方式

1. 解压 azkaban-sql-script-2.5.0.tar.gz

   ```
   tar -xzvf azkaban-sql-script-2.5.0.tar.gz
   ```

2. 登录 Mysql 创建 Database Azkaban,并初始化数据库脚本
   root 登录 mysql 服务器 hadoop-slave-001

   ```
   mysql -uroot –pthinkive
   mysql> create database azkaban;
   mysql> use azkaban
   mysql> source /home/hadoop/azkaban-2.5.0/create-all-sql-2.5.0.sql
   mysql> grant all privileges on azkaban.\* to 'azkaban'@'%' identified by 'azkaban';
   mysql> flush privileges;
   ```

3. 生成生成一个含有一个私钥的 keystore 文件

   ```
   keytool -genkey -keystore keystore -alias jetty-azkaban -keyalg RSA
   ```

   keystore 的口令是 keystore
   执行完毕后会生成一个 keystore 的文件，keypass 也是 keystore

   ![image 1](1.jpeg)

   ```
   tar –xzvf azkaban-web-server-2.5.0.tar.gz
   #修改 ./conf/azkaban.properties 如下项
   azkaban.name=Azkaban
   default.timezone.id=Asia/Shanghai
   mysql.host=hadoop-slave-001
   mysql.database=azkaban
   mysql.user=azkaban
   mysql.password=azkaban
   jetty.keystore=web/keystore
   jetty.password=keystore
   jetty.keypassword= keystore
   jetty.truststore=web/keystore
   jetty.trustpassword=keystore
   ```

4. 启动 azkaban-web

   ```
   sh bin/azkaban-web-start.sh
   ```

Note: 1. Azkaban 在启动是会生成两个日志文件 azkaban-access.log/azkaban-webserver.log，他们的生成位置是在你执行脚本的目录，所以建议你最好还是在 AZKABAN_HOME 目录下执行启动脚本
　　 2. Azkaban 需要在 ./plugins 的文件夹下手动生成一个 triggers 的目录，否则启动日志会报错。但如果添加 triggers 文件夹后，登录页面时 500 并提示 Velocity could not be initialized! 那就删除 ./plugins/tirggers 文件夹

![image 2](2.jpeg)

5. 配置 azkaban-executor
   ```
   tar -xzvf azkaban-executor-server-2.5.0.tar.gz
   ```
   配置 ./conf/azkaban.properties
   修改如下参数
   ```
   default.timezone.id=Asia/Shanghai
   mysql.port=3306
   mysql.host=hadoop-slave-001
   mysql.database=azkaban
   mysql.user=azkaban
   mysql.password=azkaban
   ```

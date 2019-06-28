---
title: Hadoop生态系统安装 Step5：安装配置zookeeper
date: 2019-06-28 10:38:22
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
  - Zookeeper
---

<!--more-->

### 用户：hadoop

### 说明

Zookeeper 在 HDFS 体系中主要起到的作用是配置管理，在 HBASE 里起到的作用是当 leader 宕机后，选举新的 leader,是一种高 HA 需求，zookeeper 只能部署在单数服务器，因为内部机制会判断，当网内>=一半 zookeeper 服务器宕机，整个 zookeeper 服务会停止，所以装 3 台和装 4 台效果是一样的

### 安装包：zookeeper-3.4.9.tar.gz

### 安装方式：

1. 将 zookeeper 压缩文件上传到/home/hadoop 目录
2. 解压文件（解压即可，不需要安装，主要是做配置）
   ```
   tar zxvf zookeeper-3.4.9.tar.gz
   ```
3. 删除安装包（可选，小心操作）
   ```
   m -rf zookeeper-3.4.9.tar.gz
   ```
4. 添加快捷方式（可选）
   ```
   ln -s zookeeper-3.4.9 zookeeper
   ```

### 配置方式：

1. 配置环境变量

   ```
   vi .bash_profile
   ```

   添加内容

   ```
   export ZOOKEEPER_HOME=/home/hadoop/zookeeper-3.4.9
   export PATH=$ZOOKEEPER_HOME/bin:$PATH
   ```

   用命令:. .bash_profile 使配置生效 (注意”.”后面有个空格)

2. 进入到指定目录

   ```
   cd /home/hadoop/zookeeper-3.4.9/conf/
   ```

3. 创建配置文件

   ```
   cp zoo_sample.cfg zoo.cfg
   ```

4. 配置 zoo.cfg 文件

   ```
   vi zoo.cfg
   #增加以下内容:
   dataDir=/home/hadoop/zookeeper-3.4.9/var/data
   dataLogDir=/home/hadoop/zookeeper-3.4.9/var/datalog
   server.1=hadoop-master-002:2888:3888
   server.2=hadoop-slave-001:2888:3888
   server.3=hadoop-slave-002:2888:3888
   ```

5. 新增数据及日志目录

   ```
   mkdir /home/hadoop/zookeeper-3.4.9/var
   mkdir /home/hadoop/zookeeper-3.4.9/data
   mkdir /home/hadoop/zookeeper-3.4.9/var/datalog
   mkdir /home/hadoop/zookeeper-3.4.9/var/data
   ```

6. 创建 myid 文件

   ```
   vim /home/hadoop/zookeeper-3.4.9/var/data/myid
   ```

   文件内容需要根据 zoo.cfg 文件中定义服务器编号进行，如本用户器是 hadoop-master-002,而对应的服务器编码是 server.1，所以这里 myid 文件内容为 1

7. 将 zookeeper-3.4.9 目录复制到其它服务器上，并修改 myid 文件
8. 启动 zookeeper （每台 zookeeper 服务器）
   ```
   cd /home/hadoop/zookeeper-3.4.9/bin
   ./zkServer.sh start
   ```
   ![image 1](1.jpeg)
9. 检测集群启动是否成功
   在三台机器上分别执行
   ```
   /home/hadoop/zookeeper-3.4.9/bin/zkServer.sh status
   ```
   结果如下：
   ![image 2](2.jpeg)
   ![image 3](3.jpeg)
   ![image 4](4.jpeg)

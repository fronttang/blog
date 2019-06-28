---
title: Hadoop生态系统安装 Step9：安装kafka
date: 2019-06-28 16:09:26
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
  - Kafka
---

<!--more-->

### 用户：hadoop

### 说明：

### 安装包：kafka_2.11-0.10.0.0.tgz

### 安装方式：

1. 将 kafka 文件上传到/home/hadoop 目录
2. 解压文件（解压即可，不需要安装，主要是做配置）
   ```
   cd /home/hadoop
   tar -xzvf kafka_2.11-0.10.0.0.tgz
   ```
3. 删除安装包（可选，小心操作）
   ```
   rm -rf kafka_2.11-0.10.0.0.tgz
   ```
4. 添加快捷方式（可选）
   ```
   ln -s kafka_2.11-0.10.0.0 kafka
   ```

### 配置方式：

1. 创建 log 文件目录
   ```
   mkdir /home/hadoop/tmp/kafkalogs
   ```
2. 修改配置文件

   ```
   cd /home/hadoop/kafka/config
   vim server.properties
   ```

   修改内容：

   ```
   broker.id=0 //当前机器在集群中的唯一标识，和 zookeeper 的 myid 性质一样不同服务器标示不一样,第二台机器上配置 id 为 1
   log.dirs=/home/hadoop/tmp/kafkalogs //设置 kafka 日志目录
   zookeeper.connect=hadoop-master-002:2181,hadoop-slave-001:2181,hadoop-slave-002:2181/kafka //设置 zookeeper 的连接端口
   ```

   增加内容：

   ```
   host.name=hadoop-sub-001 //服务器名，第二台机器配置为 hadoop-sub-002
   message.max.byte=5242880//消息保存的最大值 5M
   default.replication.factor=2 //kafka 保存消息的副本数，如果一个副本失效了，另一个还可以继续提供服务
   replica.fetch.max.bytes=5242880//取消息的最大直接数
   ```

3. 开启服务
   ```
   /home/hadoop/kafka_2.11-0.10.0.0/bin/kafka-server-start.sh -daemon /home/hadoop/kafka_2.11-0.10.0.0/config/server.properties
   ```
   ![image 1](1.jpeg)

### 查看服务是否正常

```
jps
```

![image 2](2.jpeg)

### 检测 kafka 集群进程是否正常启动

1. 创建 topic
   ```
   /home/hadoop/kafka_2.11-0.10.0.0/bin/kafka-topics.sh --create --zookeeper hadoop-slave-002:2181 --replication-factor 2 --partitions 1 --topic kafkatest
   ```
   ![image 3](3.jpeg)

查看 topic 是否创建成功

```
/home/hadoop/kafka_2.11-0.10.0.0/bin/kafka-topics.sh --list --zookeeper hadoop-slave-002:2181
```

![image 4](4.jpeg)

2. hadooop-sub-001 机器 创建 broker

   ```
   /home/hadoop/kafka_2.11-0.10.0.0/bin/kafka-console-producer.sh --broker-list hadoop-sub-001:9092 --topic kafkatest
   ```

   ![image 5](5.jpeg)

3. hadooop-sub-002 机器 创建订阅者

   ```
   /home/hadoop/kafka_2.11-0.10.0.0/bin/kafka-console-consumer.sh --zookeeper hadoop-slave-002:2181 --topic kafkatest --from-beginning
   ```

   ![image 6](6.jpeg)

4. hadooop-sub-001 机器 输入 hello world
   ![image 7](7.jpeg)

5. hadooop-sub-002 机器 显示 hello world
   ![image 8](8.jpeg)

6. 查看 kafka 日志
   ![image 9](9.jpeg)
   ![image 10](10.jpeg)

7. 查看 zookeeper 日志
   ![image 11](11.jpeg)
   ![image 12](12.jpeg)

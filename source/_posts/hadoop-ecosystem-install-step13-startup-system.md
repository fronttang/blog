---
title: Hadoop生态系统安装 Step13：集群启动
date: 2018-12-10 13:01:00
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
---

<!--more-->

### 修改配置

1. 将所有文件复制到其他节点,并修改配置

   ```
   scp -r /home/hadoop/ root@hadoop-master-002:/home/
   scp -r /home/hadoop/ root@hadoop-slave-001:/home/
   scp -r /home/hadoop/ root@hadoop-slave-002:/home/
   scp -r /home/hadoop/ root@hadoop-bigdata-01:/home/
   scp -r /home/hadoop/ root@hadoop-bigdata-02:/home/

   rm -rf hadoop
   rm -rf hbase
   rm -rf hive/
   rm -rf storm/
   rm -rf sqoop
   rm -rf zookeeper
   rm -rf kafka

   ln -s apache-hive-2.0.0-bin hive
   ln -s hbase-1.2.1 hbase
   ln -s apache-storm-1.0.1 storm
   ln -s kafka_2.11-0.10.0.0 kafka
   ln -s hadoop-2.7.2 hadoop
   ln -s sqoop-1.4.6 sqoop
   ln -s zookeeper-3.4.8 zookeeper
   ```

2. 修改 hadoop-master-02 上 yarn-site.xml

   ```
   cd /home/hadoop/hadoop/etc/hadoop
   vi yarn-site.xml
   <property>
   <name>yarn.resourcemanager.ha.id</name>
   <value>rm2</value>
   <description>If we want to launch more than one RM in single node, we need this configuration</description>
   </property>
   ```

3. 修改 hadoop-slave-001,hadoop-slave-002 上 zookeeper 的 myid

   ```
   vi /home/hadoop/zookeeper/var/data/myid
   ```

4. 修改 zoo.cfg 当前 server ip 为 0.0.0.0
   ```
   server.\*=0.0.0.0:2888:3888
   ```

### 启动集群

1. 启动 zookeeper
   在 hadoop-master-002,hadoop-slave-001,hadoop-slave-002 节点上运行 zookeeper

   ```
   cd /home/hadoop/zookeeper/bin
   ./zkServer.sh start
   ./zkServer.sh status
   ```

   检查端口

   ```
   netstat -anp | grep 2181
   ```

2. 启动 hadoop
   主 Master 节点运行

   ```
   hdfs zkfc -formatZK
   ```

   所有的 Journal 节点运行：

   ```
   ~/hadoop/sbin/hadoop-daemon.sh start journalnode
   ```

   两个 master 节点运行：

   ```
   ~/hadoop/sbin/hadoop-daemon.sh start zkfc
   ```

   主 Master 节点运行：

   ```
   hdfs namenode -format ns
   ```

   主 Master 节点运行：

   ```
   hdfs namenode -initializeSharedEdits
   ```

   主 master 节点运行：

   ```
   ~/hadoop/sbin/hadoop-daemon.sh start namenode
   ```

   备 master 节点运行：

   ```
   hdfs namenode -bootstrapStandby
   ```

   备 master 节点运行：

   ```
   ~/hadoop/sbin/hadoop-daemon.sh start namenode
   ```

   主 master 节点运行：

   ```
   ~/hadoop/sbin/start-all.sh
   ```

   以上为首次启动 Hadoop，后续启动 Hadoop 集群只需在主 master 节点运行./start-all.sh
   查看两个 namenode 状态

   ```
   hdfs haadmin -getServiceState nn1
   hdfs haadmin -getServiceState nn2
   yarn rmadmin -getServiceState rm1
   yarn rmadmin -getServiceState rm2
   yarn-daemon.sh start resourcemanager
   ```

   hdfs namenode -bootstrapStandby 报错连不上主 master:9000
   解决方案：修改主 master hosts 文件 0.0.0.0 hadoop-master-001

3. 启动 Hbase 主节点运行：

   ```
   ./start-hbase.sh
   ```

4. hadoop-master-002 上启动 hive
   将 mysql 的 jdbc 驱动 copy 到/home/hadoop/hive/lib 目录下载
   执行./hiveserver2（使用 jdbc 连接 hive 时需要）

5. hadoop-slave-001 和 hadoop-slave-002 上启动 kafka
   如果要启动两台 kafka，则注意修改 broker.id=1 配置

   ```
   nohup bin/kafka-server-start.sh config/server.properties > kafka.log &
   ```

6. 启动 storm
   主节点 hadoop-master-002 上启动
   ```
   nohup ./storm nimbus>nimbus.log &
   nohup ./storm ui>ui.log &
   ```
   从节点 hadoop-slave-001,hadoop-slave-002 上启动
   ```
   nohup ./storm supervisor >supervisor.log &
   nohup ./storm logviewer>logviewer.log &
   ```

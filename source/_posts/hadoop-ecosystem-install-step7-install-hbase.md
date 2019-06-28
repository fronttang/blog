---
title: Hadoop生态系统安装 Step7：安装Hbase
date: 2019-06-28 11:21:08
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
  - HBase
---

<!--more-->

### 用户：hadoop

### 说明：

### 安装包：hbase-1.2.4-bin.tar.gz

### 安装方式：

1. 将 hbase 文件上传到/home/hadoop
2. 解压文件（解压即可，不需要安装，主要是做配置）
   ```
   cd /home/hadoop/
   tar zxvf hbase-1.2.4-bin.tar.gz
   ```
3. 删除安装包（可选、小心操作）
   ```
   rm -rf hbase-1.2.4-bin.tar.gz
   ```
4. 添加快捷方式（可选）
   ```
   ln -s hbase-1.2.4-bin hbase
   ```

### 配置方式

1. 配置环境变量

   ```
   vi .bash_profile
   export HBASE_HOME=/home/hadoop/hbase-1.2.4/
   export PATH=$HBASE_HOME/bin:$PATH
   ```

2. 生效配置

   ```
   . .bash_profile
   ```

3. 修改 regionservers 文件（regionserver）

   ```
   vim /home/hadoop/hbase-1.2.4/conf/regionservers
   # 删除原有内容，添加以下内容：
   hadoop-slave-001
   hadoop-slave-002
   ```

4. 修改 hbase-env.sh（见附件）

   ```
   vim /home/hadoop/hbase-1.2.4/conf/hbase-env.sh
   # 添加以下内容：
   export HBASE_PID_DIR=/home/hadoop/pids
   export JAVA_HOME=/usr/java/jdk1.8.0_121
   export HBASE_MANAGES_ZK=false
   ```

5. 修改 hbase-site.xml 配置（见附件）

   ```
   vim /home/hadoop/hbase-1.2.4/conf/hbase-site.xml
   ```

   删除原有<configuration></configuration>内容，添加以下内容：

   ```
   <configuration>
   <property>
   <name>hbase.rootdir</name>
   <value>hdfs://hadoop-master-001:9000/hbase</value>
   </property>
   <property>
   <name>hbase.cluster.distributed</name>
   <value>true</value>
   </property>
   <property>
   <name>hbase.tmp.dir</name>
   <value>/home/hadoop/tmp/hbase</value>
   </property>
   <property>
   <name>hbase.zookeeper.quorum</name>
   <value>hadoop-master-002,hadoop-slave-001,hadoop-slave-002</value>
   </property>
   <property>
   <name>dfs.replication</name>
   <value>1</value>
   </property>
   <property>
   <name>hbase.master</name>
   <value>hadoop-master-002</value>
   </property>
   <property>
   <name>hbase.master.info.port</name>
   <value>60010</value>
   </property>
   <property>
   <name>hbase.master.port</name>
   <value>60000</value>
   </property>
   <property>
   <name>hbase.master.info.bindAddress</name>
   <value>0.0.0.0</value>
   </property>
   </configuration>
   ```

6. 复制到其他节点

   ```
   scp -r /home/hadoop/hbase-1.2.4 hadoop@hadoop-slave-001:/home/hadoop
   scp -r /home/hadoop/hbase-1.2.4 hadoop@hadoop-slave-002:/home/hadoop
   ```

7. 主节点运行

   ```
   /home/hadoop/hbase-1.2.4/bin/start-hbase.sh
   ```

8. 检测是否启动成功
   主节点：
   ![image 1](1.jpeg)
   从节点
   ![image 2](2.jpeg)
   注意：主从节点的时间一定要一致，否则从节点可能启动不起来。

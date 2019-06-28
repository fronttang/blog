---
title: Hadoop生态系统安装 Step10：安装storm
date: 2018-12-07 13:01:00
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
  - Storm
---

<!--more-->

### 用户：hadoop

### 说明：

### 安装包：apache-storm-1.0.1.tar.gz

### 安装方式：

1. 将 storm 文件上传到/home/hadoop 目录
2. 解压文件（解压即可，不需要安装，主要是做配置）
   ```
   cd /home/hadoop/
   tar zxvf apache-strom-1.0.1.tar.gz
   ```
3. 删除安装包（可选，小心操作）
   ```
   rm -rf apache-storm-1.0.1.tar.gz
   ```
4. 添加快捷方式（可选）
   ```
   ln -s apache-storm-1.0.1 storm
   ```

### 配置方式：

1. 创建本地数据目录

   ```
   mkdir /home/hadoop/storm/stdata
   mkdir /home/hadoop/storm/logs
   ```

2. 配置环境

   ```
   vi .bash_profile
   export STORM_HOME=/home/hadoop/storm/
   export PATH=$STORM_HOME/bin:$PATH
   ```

3. 生效配置

   ```
   . .bash_profile
   ```

4. 配置 storm 环境

   ```
   cd /home/hadoop/storm/conf
   vim storm.yaml
   # 增加以下内容:
   storm.zookeeper.servers: - "hadoop-master-002" - "hadoop-slave-001" - "hadoop-slave-002"
   ui.port: 9090
   nimbus.seeds: ["hadoop-master-002","hadoop-slave-001"]
   storm.zookeeper.port: 2181
   nimbus.host: "hadoop-master-002"
   storm.local.dir: "/home/hadoop/storm/stdata"
   storm.local.mode.zmq: true
   supervisor.slots.ports:
     - 6700
     - 6701
     - 6702
     - 6703
   nimbus.childopts: "-Xmx1024m"
   supervisor.childopts: "-Xmx1024m"
   worker.heap.memory.mb: 768
   worker.childopts: "-Xmx1024m"
   ```

   ![image 1](1.jpeg)

5. 复制 strom 到其它服务器

   ```
   scp -r /home/hadoop/storm hadoop@hadoop-slave-001:/home/hadoop/
   scp -r home/hadoop/storm hadoop@hadoop-slave-002:/home/hadoop/
   ```

6. storm 集群启动

   hadoop-master-002 作为 nimbus 和 supervisor
   hadoop-slave-001 作为 supervisor
   hadoop-slave-002 作为 supervisor

   hadoop-master-002

   ```
   cd /home/hadoop/storm/bin
   ./storm nimbus >> /home/hadoop/storm/logs/nimbus.out 2>&1 &
   ./storm ui>> /home/hadoop/storm/logs/ui.out 2>&1 &
   ./storm logviewer>> /home/hadoop/storm/logs/logviewer.out 2>&1 &
   ```

   ![image 2](2.jpeg)

   hadoop-slave-001 和 hadoop-slave-002

   ```
   cd /home/hadoop/storm/bin
   ./storm supervisor>> /home/hadoop/storm/logs/supervisor.out 2>&1 &
   ```

   ![image 3](3.jpeg)

7. 检测集群是否启动成功
   在浏览器上访问 hadoop-master-002 对应的 ip 加上端口号 9090 访问状态界面查看如：
   http：//xxx.xxx.xxx.xxx:9090/index.html
   ![image 4](4.jpeg)

8. 运行 jar
   ```
   storm kill main-top -w 200
   storm jar thinkive-bigdata-bdms-storm-topology-0.0.1-SNAPSHOT.jar com.thinkive.bigdata.bdms.storm.topology.Topology conf/configuration.properties
   ```
   查看 storm 任务
   ```
   storm list
   ```

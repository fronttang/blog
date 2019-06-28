---
title: Hadoop生态系统安装 Step6：安装HADOOP
date: 2018-12-03 13:01:00
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
---

<!--more-->

### 用户：hadoop

### 说明：

### 安装包：hadoop-2.7.2.tar.gz

### 安装方式：

1. 将 Hadoop 压缩文件上传到/home/hadoop 目录
2. 解压文件（解压即可，不需要安装，主要是做配置）

```
tar zxvf hadoop-2.7.2.tar.gz
```

3. 删除安装包（可选，小心操作）

```
rm -rf hadoop-2.7.2.tar.gz
```

4. 添加快捷方式（可选）

```
ln -s hadoop-2.7.2 hadoop
```

### 配置方式：

1. 配置系统变量

```
vi .bash_profile
# 在最后加上：
export HADOOP_HOME=/home/hadoop/hadoop-2.7.2
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
```

2. 使设置生效
   命令:. .bash_profile (注意”.”和”/”中间有个空格)

3. 关闭 Transparent Hugepage（可选）
   说明：
   RHEL6 优化了内存申请的效率，而且在某些场景下对 KVM 的性能有明显提升。而 Hadoop 是个高密集型内存运算系统，这个改动似乎给它带来了副作用。理论上运算型 Java 程序应该更多的使用用户态 CPU 才对，Cloudera 官方也推荐关闭 THP。
   a) 查看 Transparent Hugepage 的状态

```
cat /sys/kernel/mm/transparent_hugepage/enabled
```

![image 1](1.jpeg)

表示服务为开启状态
b) 关闭服务
打开文件

```
vi /etc/rc.local
```

增加代码：

```
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
   echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
```

c) 重启服务器
d) 查看 Transparent Hugepage 的状态

```
cat /sys/kernel/mm/transparent_hugepage/enabled
```

![image 2](2.jpeg)
表示服务已经永久关闭

4. 创建目录

```
mkdir /home/hadoop/journal
mkdir /home/hadoop/temp
mkdir /home/hadoop/data
mkdir /home/hadoop/hdfs
mkdir /home/hadoop/hdfs/name
mkdir /home/hadoop/hdfs/data
mkdir /home/hadoop/yarn
mkdir /home/hadoop/yarn/local
mkdir /home/hadoop/yarn/logs
mkdir /home/hadoop/yarn/config
mkdir /home/hadoop/pids
```

5. 复制配置文件到相应目录(上传 config 目录到/home/hadoop/software)：
   注意配置文件需要根据文件上的注释进行相应的修改

```
cp slaves /home/hadoop/hadoop-2.7.2/etc/hadoop/
cp core-site.xml /home/hadoop/hadoop-2.7.2/etc/hadoop/
cp hdfs-site.xml /home/hadoop/hadoop-2.7.2/etc/hadoop/
cp mapred-site.xml /home/hadoop/hadoop-2.7.2/etc/hadoop/
cp yarn-site.xml /home/hadoop/hadoop-2.7.2/etc/hadoop/

vi /home/hadoop/hadoop/sbin/hadoop-daemon.sh
HADOOP_PID_DIR=/home/hadoop/pids

vi /home/hadoop/hadoop/sbin/yarn-daemon.sh
YARN_PID_DIR=/home/hadoop/pids

# 修改hadoop-env.sh、yarn-env.sh，修改JAVA_HOME
cd /home/hadoop/hadoop-2.7.2/etc/hadoop
vi hadoop-env.sh
vi yarn-env.sh
export JAVA_HOME=/usr/java/jdk1.8.0_121
```

6. 将 hadoop 复制到其他 datanode 服务器

7. 在第二台 yarn 机器上修改配置文件 yarn-site.xml,参数 yarn.resourcemanager.ha.id,值改为 rm2
8. 启动 hadoop 集群
   a) 在每台 yarn 机器上启动 yarn

```
cd /home/hadoop/hadoop-2.7.2/sbin/
./yarn-daemon.sh start resourcemanager
```

![image 3](3.jpeg)
b) 主 MASTER 格式化 ZK

```
hdfs zkfc -formatZK
```

![image 4](4.jpeg)
c) 启动所有 Journal 节点

```
~/hadoop-2.7.2/sbin/hadoop-daemon.sh start journalnode
```

![image 5](5.jpeg)
d) 主 MASTER 格式化 ns

```
hdfs namenode -format ns
```

![image 6](6.jpeg)
e) 主 master 节点运行

```
~/hadoop-2.7.2/sbin/hadoop-daemon.sh start namenode
```

![image 7](7.jpeg)
f) 备 master 节点运行

```
hdfs namenode -bootstrapStandby
```

![image 8](8.jpeg)
g) 备 master 节点运行

```
~/hadoop-2.7.2/sbin/hadoop-daemon.sh start namenode
```

![image 9](9.jpeg)
h) 主 master 节点运行

```
~/hadoop-2.7.2/sbin/start-all.sh
```

第一次启动的时候会报如下警告：
![image 10](10.jpeg)
只需要根据提示输入 yes 即可，第二次启动的时候不会报这个错

9. 检测 HADOOOP 集群进程是否正常启动
   在每台机器上执行命令

```
jps -l
```

a) hadoop-master-001 节点
![image 11](11.jpeg)
b) hadoop-master-002 节点
![image 12](12.jpeg)
c) hadoop-slave-001 节点
![image 13](13.jpeg)
d) hadoop-slave-002 节点
![image 14](14.jpeg)

---
title: Hadoop生态系统安装 Step4：配置SSH无密码登录
date: 2018-12-01 13:01:00
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
  - SSH
---

<!--more-->

### 用户：hadoop

### 说明

Hadoop 运行过程中需要管理远端 Hadoop 守护进程，在 Hadoop 启动以后，NameNode 是通过 SSH（Secure Shell）来启动和停止各个 DataNode 上的各种守护进程的。这就必须在节点之间执行指令的时候是不需要输入密码的形式，故我们需要配置 SSH 运用无密码公钥认证的形式，这样 NameNode 使用 SSH 无密码登录并启动 DataName 进程，同样原理，DataNode 上也能使用 SSH 无密码登录到 NameNode。

### 配置方式一

#### 1. 在每一台机器上执行如下指令

hadoop-master-001

```
ssh-keygen -t rsa
scp ~/.ssh/id_rsa.pub hadoop@hadoop-master-001:/home/hadoop/.ssh/authorized_keys
```

hadoop-master-002

```
ssh-keygen -t rsa
scp ~/.ssh/id_rsa.pub hadoop@hadoop-master-002:/home/hadoop/.ssh/authorized_keys
scp ~/.ssh/authorized_keys hadoop@hadoop-master-001:/home/hadoop/.ssh/authorized_keys_master_002
```

hadoop-slave-001

```
ssh-keygen -t rsa
scp ~/.ssh/id_rsa.pub hadoop@hadoop-slave-001:/home/hadoop/.ssh/authorized_keys
scp ~/.ssh/authorized_keys hadoop@hadoop-master-001:/home/hadoop/.ssh/authorized_keys_slave_001
```

hadoop-slave-002

```
ssh-keygen -t rsa
scp ~/.ssh/id_rsa.pub hadoop@hadoop-slave-002:/home/hadoop/.ssh/authorized_keys
scp ~/.ssh/authorized_keys hadoop@hadoop-master-001:/home/hadoop/.ssh/authorized_keys_slave_002
```

hadoop-sub-001

```
ssh-keygen -t rsa
scp ~/.ssh/id_rsa.pub hadoop@hadoop-sub-001:/home/hadoop/.ssh/authorized_keys
scp ~/.ssh/authorized_keys hadoop@hadoop-master-001:/home/hadoop/.ssh/authorized_keys_sub_001
```

hadoop-sub-002

```
ssh-keygen -t rsa
scp ~/.ssh/id_rsa.pub hadoop@hadoop-sub-002:/home/hadoop/.ssh/authorized_keys
scp ~/.ssh/authorized_keys hadoop@hadoop-master-001:/home/hadoop/.ssh/authorized_keys_sub_002
```

hadoop-master-001

```
cat ~/.ssh/authorized_keys_master_002 >> ~/.ssh/authorized_keys
cat ~/.ssh/authorized_keys_slave_001 >> ~/.ssh/authorized_keys
cat ~/.ssh/authorized_keys_slave_002 >> ~/.ssh/authorized_keys
cat ~/.ssh/authorized_keys_sub_001 >> ~/.ssh/authorized_keys
cat ~/.ssh/authorized_keys_sub_002 >> ~/.ssh/authorized_keys
scp ~/.ssh/authorized_keys hadoop@hadoop-master-002:/home/hadoop/.ssh/authorized_keys
scp ~/.ssh/authorized_keys hadoop@hadoop-slave-001:/home/hadoop/.ssh/authorized_keys
scp ~/.ssh/authorized_keys hadoop@hadoop-slave-002:/home/hadoop/.ssh/authorized_keys
scp ~/.ssh/authorized_keys hadoop@hadoop-sub-001:/home/hadoop/.ssh/authorized_keys
scp ~/.ssh/authorized_keys hadoop@hadoop-sub-002:/home/hadoop/.ssh/authorized_keys
```

#### 2. 检测是否配置成功

a) 检测本机无密码登录

```
ssh localhost
```

如没有要求输入密码，表示配置成功

b) 检测其它机器无密码登录(每台机器与其它机器都可以无密登录)
例:ssh hadoop-slave-001
如没有要求输入密码，表示配置成功

### 配置方式二

#### 1、master 主节点执行：

```
ssh-keygen -t rsa
cd .ssh
cat id_rsa.pub > authorized_keys
# 将 authorized_keys 文件复制到其他机器上~/.ssh 目录下
scp id_rsa.pub hadoop/hadoop-\*\*:/home/hadoop/.ssh/authorized_keys
```

#### 2、设置权限

```
设置 authorized_keys 权限
chmod 600 authorized_keys
# 设置.ssh 目录权限：
chmod 700 -R .ssh
```

---
title: Hadoop生态系统安装 Step1：修改主机名，配置HOSTS（每台机器）
date: 2018/11/27 13:00:00
categories:
  - Haddop
  - CentOS
tags:
  - hadoop
  - CentOS
  - hosts
---

<!--more-->

### 用户：root

### 说明：

    配置主机名与IP之间的映射关系
    配置主机名，主机名与hosts文件中的名字保持一致

### 配置方式：

#### 1、修改主机名

修改/etc/sysconfig/network，修改 HOSTNAME 后面的主机名为 HOSTNAME=hadoop-xx
vi /etc/sysconfig/network

#### 2、配置 host

修改/etc/hosts，添加

```bash
vi /etc/hosts
192.168.61.133   hadoop-master-001
192.168.61.134   hadoop-master-002
192.168.61.135   hadoop-slave-001
192.168.61.136   hadoop-slave-002
192.168.61.132   hadoop-bigdata-001
192.168.61.138   hadoop-bigdata-002
```

#### 3、设置时区并同步时间（可选）

修改 /etc/profile 在最后添加
export TZ="Asia/Shanghai"
保存并让配置生效 . /etc/profile (注意点后面有空格)
输入 ntpdate time.nist.gov 同步网络时间（时间服务器可网上搜索）

#### 4、重启系统

```bash
reboot
```

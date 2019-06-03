---
title: Hadoop生态系统安装 Step2：创建HADOOP用户，用户组及赋权（每台机器）
date: 2018/11/27 13:00:00
categories:
  - Hadoop
tags:
  - Hadoop
  - CentOS
---

<!--more-->

### 用户：root

### 说明：

    增加大数据专用用户，增加安全性

### 配置方式：

#### 1、创建用户及用户组

```bash
groupadd hadoop
useradd -d /home/hadoop -g hadoop hadoop
passwd hadoop
（会要求重复输入密码）
```

#### 2、配置权限

```bash
vi /etc/sudoers
hadoop ALL=(ALL) ALL
```

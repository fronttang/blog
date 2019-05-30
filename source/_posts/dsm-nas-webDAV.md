---
title: 开启群晖NAS的WebDAV服务，让文件操作变得更简单
date: 2019-05-30 16:00:35
categories:
  - dsm
  - ros
  - WebDAV
tags:
  - dsm
  - ros
  - WebDAV
---

<!--more-->

### 群晖 NAS 里安装 WebDAV server

在群晖的套件中心找到 WebDAV Server 并安装
![image 1](1.png)

安装完后打开，然后启用 HTTP 或 HTTPS 端口
![image 2](2.png)

这样群晖的 WebDAV Server 就配置好了

### 路由器端口映射让外网可以访问 WebDAV

如果想要让外网能够操作 NAS 的文件，则需要在主路由里配置端口映射，将刚才设置的 5005 或 5006 映射到外网
这里以 ROS 为例将 5005 映射到外网的 15675 端口
![image 3](3.png)
![image 4](4.png)

### 使用客户端工具映射 NAS 到本地磁盘

使用客户端口工具[NetDrive](http://www.netdrive.net/)映射 NAS 到本地
NetDrive 支持多个网盘，例如 Google Drive ,OneDrive 等等

#### 下载安装 NetDrive

网址 http://www.netdrive.net/

#### 打开 NetDrive 客户端并登录

先注册一个账号或使用 Facebook、Twitter、Google 账号登录
![image 5](5.png)

#### 添加并映射磁盘

![image 6](6.png)
![image 7](7.png)
![image 8](8.png)
![image 9](9.png)
![image 10](10.png)
![image 11](11.png)

---
title: OpenWRT/LEDE软路由下利用docker安装nginx实现反向代理（一）
date: 2019-04-07 15:35:55
categories:
  - lede
  - dsm
  - nginx
  - openwrt
  - docker
tags:
  - lede
  - dsm
  - nginx
  - openwrt
  - ros
  - docker
  - ajenti
  - proxy
---

<!--more-->

上一篇文章 [利用群晖的反向代理服务器转发内网服务,实现外网免端口访问内网服务](https://blog.open4j.com/2019/04/07/use-dsm-nginx-reverse-proxy/) 讲了利用利用群晖的反向代理服务器转发内网服务，有人可能没有群晖NAS，本文将介绍在软路由LEDE下安装docker，用docker的nginx容器来配置和群晖反向代理一样的功能。

前期一些配置就不再多介绍了，下面从上一篇[文章](https://blog.open4j.com/2019/04/07/use-dsm-nginx-reverse-proxy/)的第四点开始配置

### 一、OpenWRT/LEDE软路由下安装docker
\* 本文是以koolshare论坛的LEDE x86 为例进行配置

#### 1. 安装docker插件
安装docker之前，先给lede加一块硬盘，如果lede是安装在物理机可以不加磁盘

1. 在ESXI下给lede添加硬盘
![图片 1](1.jpg)
![图片 2](2.jpg)

2. 用SSH登录lede给硬盘进行分区并格式化
![图片 3](3.jpg)
![图片 4](4.jpg)
![图片 5](5.jpg)
![图片 6](6.jpg)
![图片 7](7.jpg)

3. 在LEDE界面挂载分区
![图片 8](8.jpg)
![图片 9](9.jpg)
![图片 10](10.jpg)
![图片 11](11.jpg)

4. 安装docker
![图片 12](12.jpg)
![图片 13](13.jpg)

未完待续......

---
title: OpenWRT/LEDE下安裝配置SoftEther VPN
date: 2019-06-26 16:39:23
categories:
  - Router
tags:
  - Router
  - OpenWRT
  - LEDE
  - VPN
  - softether_vpn
---

<!--more-->

### 一、安裝

以 koolshare 的 lede 为例，在酷软里找到 softether_vpn 插件并安装
![图片 1](1.png)

### 二、配置

#### 1. 启动 SoftEther VPN 服务

![图片 2](2.png)

#### 2. 配置 SoftEther VPN

#### 1) 安装 SoftEther VPN Server Manager

在[官网](https://www.softether.org/5-download)下载并安装 softether vpn 服务管理工具：SoftEther VPN Server Manager

![图片 3](3.png)
这里以 MacOS 为例：
![图片 4](4.png)

#### 2) 添加新设置连接到 lede 的 SoftEther VPN 服务

![图片 5](5.png)

点击连接
![图片 7](7.png)

第一连接会要求设置管理密码
![图片 6](6.png)

#### 3) 进行配置

（借 koolshare 论坛的图）

![图片 8](8.png)
![图片 9](9.png)
![图片 10](10.png)

#### 4）本地网桥设置

![图片 11](11.png)
![图片 13](13.png)
![图片 24](24.png)

#### 5）添加用户

![图片 14](14.png)
![图片 15](15.png)
![图片 16](16.png)
![图片 17](17.png)
![图片 18](18.png)

#### 6）关闭日志

![图片 19](19.png)
![图片 20](20.png)

#### 7）改加密方式

![图片 21](21.png)
![图片 22](22.png)

#### 8) 关闭 Virtual NET

![图片 23](23.png)

### 三、客户端连接

以 MacOS 下 Shimo 客户端为例
![图片 25](25.png)
![图片 26](26.png)
![图片 27](27.png)

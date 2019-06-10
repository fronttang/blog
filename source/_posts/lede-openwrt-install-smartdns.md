---
title: lede/openwrt 安装配置 SmartDNS 插件
date: 2019-06-10 16:59:44
categories:
  - Router
tags:
  - LEDE
  - OpenWRT
  - SmartDNS
---

<!--more-->

### 一、简介

官网地址：https://pymumu.github.io/smartdns/
下载地址：https://github.com/pymumu/smartdns/releases
SmartDNS 是一个运行在本地的 DNS 服务器，SmartDNS 接受本地客户端的 DNS 查询请求，从多个上游 DNS 服务器获取 DNS 查询结果，并将访问速度最快的结果返回给客户端，避免 DNS 污染，提高网络访问速度。 同时支持指定特定域名 IP 地址，并高性匹配，达到过滤广告的效果。
与 dnsmasq 的 all-servers 不同，smartdns 返回的是访问速度最快的解析结果。

### 二、安装

#### 下载安装包

直接在 [官方 Github 发布地址](https://github.com/pymumu/smartdns/releases) 下载最新版本的安装包上传到 lede/openwrt 的/tmp 目录下
也可以 copy 下载地址直接在 lede/openwrt 里用 wget 命令下载
需要下载这两个：
[smartdns.1.2019.05.21-2250.x86_64.ipk](https://github.com/pymumu/smartdns/releases/download/Release25/smartdns.1.2019.05.21-2250.x86_64.ipk)
[luci-app-smartdns.1.2019.05.21-2250.all.ipk](https://github.com/pymumu/smartdns/releases/download/Release25/luci-app-smartdns.1.2019.05.21-2250.all.ipk)
一个是程序，一个是界面

```
cd /tmp
wget https://github.com/pymumu/smartdns/releases/download/Release25/smartdns.1.2019.05.21-2250.x86_64.ipk
wget https://github.com/pymumu/smartdns/releases/download/Release25/luci-app-smartdns.1.2019.05.21-2250.all.ipk
```

![图片 1](1.png)
![图片 2](2.png)

#### 安装 SmartDNS

直接用 opkg install xxx.ipk 进行安装

```
opkg install smartdns.1.2019.05.21-2250.x86_64.ipk
opkg install luci-app-smartdns.1.2019.05.21-2250.all.ipk
```

![图片 3](3.png)

注意：如使用 Koolshare Lede 2.3.0 及之后版本，请安装 openssl1.0.0 系统库，安装文件从下面页面中获取：
https://downloads.openwrt.org/releases/18.06.2/packages/x86_64/base/
找到 libopenssl_1.0.2XXXX_x86_64.ipk 并安装下载，XXXX 为版本号。

### 三、配置 SmartDNS

#### 開啟 SmartDNS

![图片 4](4.png)
![图片 5](5.png)

#### 其他一些配置

國內的 DNS 交給 SmartDNS,國外默認。
![图片 6](6.png)

#### 检测转发服务是否配置成功

使用 nslookup -querytype=ptr 0.0.0.0 查询域名
看命令结果中的 name 项目是否显示为 smartdns 或主机名，如 smartdns 则表示生效

![图片 7](7.png)

其他使用方法請參考官網

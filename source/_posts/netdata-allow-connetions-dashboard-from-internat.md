---
title: 允许netdata外网访问
date: 2019-04-07 11:45:56
categories:
  - Router
tags:
  - netdata
  - Openwrt
---

<!--more-->

当我们需要外网访问 netdata 的时候，在路由器里做了端口映射还不够，还要修改 netdata 的配置文件 /etc/netdata/netdata.conf, 配置 netdata 允许访问的来源 IP。因为 netdata 默认配置是只允许内网的一些 IP 才能访问。

### 一、修改 netdata 配置

```bash
$vi /etc/netdata/netdata.conf
```

修改[web]下的 allow connections from 和 allow dashboard from

```
allow connections from = *
allow dashboard from = *
```

![图片 1](1554609011349.jpg)

### 二、路由器里增加端口映射

以 ROS 路由器为例：
用 winbox 登录 ROS ,打开 ip->firewall,切换到 NET 页,点击新增按钮

![图片 1](1554610449677.jpg)
![图片 2](1554610422433.jpg)

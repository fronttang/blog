---
title: 允许netdata外网访问
date: 2019-04-07 11:45:56
categories:
  - netdata
  - openwrt
tags:
  - netdata
  - openwrt
---

<!--more-->

当我们需要外网访问netdata的时候，在路由器里做了端口映射还不够，还要修改netdata的配置文件 /etc/netdata/netdata.conf, 配置netdata允许访问的来源IP。因为netdata默认配置是只允许内网的一些IP才能访问。

### 一、修改netdata配置

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

以ROS路由器为例：
用winbox登录ROS ,打开 ip->firewall,切换到NET页,点击新增按钮

![图片 1](1554610449677.jpg)
![图片 1](1554610422433.jpg)

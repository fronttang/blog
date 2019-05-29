---
title: ROS端口映射动态IP完美解决回流问题
date: 2019-05-29 21:19:51
categories:
  - ROS
  - NET
  - FIREWALL
tags:
  - ROS
  - NET
  - FIREWALL
---

<!--more-->

网上很多关于动态IP下ROS配置NET端口映射，关于回流问题的解决方案是设置脚本：IP更新后更新NET规则的Dst.Address.
这样的话如果有多个端口映射,那就要配置多个脚本。下面介绍一个完美解决NET回流,不需要配置脚本的方法.


### 一、找到IP->Cloud,把里面的DDNS功能启用，时间更新启用，并复制一下生成出来的域名。
如果不想用ROS的DDNS域名，也可以用自己的域名，如阿里云域名，在LEDE或群晖中做好DDNS.
![image 1](1.png)
### 二、IP -> Firewall 添加一個 address
![image 2](2.png)
### 三、设置端口映射
![image 3](3.png)
![image 4](4.png)
![image 5](5.png)
这样设置完成后 我们就可以在动态IP下实时更新DDNS 同时也可以回流，重要的是，我们依然可以继续使用群晖DDNS或阿里云DDNS给的短域名。

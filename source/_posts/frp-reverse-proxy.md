---
title: LEDE路由下frp内网穿透教程
date: 2019-06-01 14:12:52
categories:
  - lede
  - vps
  - frp
tags:
  - lede
  - dsm
  - nginx
  - openwrt
  - vps
  - docker
  - frp
  - proxy
  - ssh
---

<!--more-->


### 一、准备工作

#### 准备一台VPS
有公网IP，腾迅云、阿里云、谷歌云都可以，这里以谷歌云为例
#### 准备一个域名
可以自己买或使用一些免费域名，这里以阿里云域名为例
在阿里云域名控制台解析域名到谷歌云VPS实例的IP
在解析列表里添加一条A记录
![image 2](2.png)

### 二、在谷歌云实例里安装frps
frps 就是 frp 的服务器端

#### SSH进入谷歌云实例
这里使用谷歌强大的网页版SSH
![image 1](1.png)

#### 安装frps
在 [官方Github版本发布地址](https://github.com/fatedier/frp/releases) 下载最新的源码包
我谷歌云实例是CentOS x64系统, 所以下载的是 [frp_0.27.0_linux_amd64.tar.gz](https://github.com/fatedier/frp/releases/download/v0.27.0/frp_0.27.0_linux_amd64.tar.gz)

在网页SSH执行命令
```
sudo -i    # 先到root用户
cd /home   # 我喜欢先在home目录下操作
# 下载 frp
wget https://github.com/fatedier/frp/releases/download/v0.27.0/frp_0.27.0_linux_amd64.tar.gz
```
![image 3](3.png)

```
tar zxvf frp_0.27.0_linux_amd64.tar.gz  # 解压下载的文件
mv frp_0.27.0_linux_amd64 frp           # 文件夹名太长，换个名字
```
![image 4](4.png)

```
cd frp
vi frps.ini  # 进到frp目录，修改 frps.ini 文件
[common]
bind_addr = 0.0.0.0
bind_port = 7000
vhost_http_port = 80
vhost_https_port = 443
dashboard_addr = 0.0.0.0
dashboard_port = 7500
dashboard_user = admin
dashboard_pwd = admin
log_file = ./frps.log
log_level = info
log_max_days = 3
token = YWxkamZhaWV1b2FkdmZydGZyb250dGF

# :wq保存后启动
./frps -c ./frps.ini   
# 后台运行使用这个
nohup ./frps -c ./frps.ini &
tail -n 100 -f frps.log  # 查看日志
```
![image 5](5.png)
![image 6](6.png)

进到frps 控制台看看
![image 9](9.png)
![image 10](10.png)

关于frp的使用 [这里](https://github.com/fatedier/frp/blob/master/README_zh.md) 有官方的中方说明

### 三、LEDE下frp客户端配置

#### 安装frp客户端插件
![image 7](7.png)

#### 开启 frpc 并配置 frps 信息
![image 8](8.png)

#### 服务穿透配置
![image 11](11.png)

保存后访问域名试试
![image 12](12.png)
![image 13](13.png)

进管理台可以看到一条http的记录
![image 14](14.png)
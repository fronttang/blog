---
title: LEDE路由下frp内网穿透教程
date: 2019-06-01 14:12:52
categories:
  - Router
tags:
  - LEDE
  - DSM
  - nginx
  - Openwrt
  - vps
  - docker
  - frp
  - proxy
  - ssh
---

<!--more-->

### 一、准备工作

#### 准备一台 VPS

有公网 IP，腾迅云、阿里云、谷歌云都可以，这里以谷歌云为例

#### 准备一个域名

可以自己买或使用一些免费域名，这里以阿里云域名为例
在阿里云域名控制台解析域名到谷歌云 VPS 实例的 IP
在解析列表里添加一条 A 记录
![image 2](2.png)

### 二、安装 frps

frps 就是 frp 的服务器端

#### SSH 进入谷歌云实例

这里使用谷歌强大的网页版 SSH
![image 1](1.png)

#### 安装 frps

在 [官方 Github 版本发布地址](https://github.com/fatedier/frp/releases) 下载最新的程序包
我谷歌云实例是 CentOS x64 系统, 所以下载的是 [frp_0.27.0_linux_amd64.tar.gz](https://github.com/fatedier/frp/releases/download/v0.27.0/frp_0.27.0_linux_amd64.tar.gz)

在网页 SSH 执行命令

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

进到 frps 控制台看看
![image 9](9.png)
![image 10](10.png)

关于 frp 的使用 [这里](https://github.com/fatedier/frp/blob/master/README_zh.md) 有官方的中文说明

### 三、配置 frpc

#### 安装 frp 客户端插件

![image 7](7.png)

#### 开启 frpc 并配置 frps 信息

![image 8](8.png)

#### 服务穿透配置

![image 11](11.png)

保存后访问域名试试
![image 12](12.png)
![image 13](13.png)

进管理台可以看到一条 http 的记录
![image 14](14.png)

### 四、穿透 https 服务

如果要穿透 https 服务则要为 https 服务设置证书，先按 [申请 Let's Encrypt 免费 SSL 证书](https://blog.open4j.com/2019/06/09/apply-lets-encrypt-free-ssl/) 文章申请域名 SSL 证书

下面以配置 lede https 服务为例
将下载来的证书文件上传到 lede 的 /etc/ssl 目录下，目录可以随意，我这里上传到 lede 的 /etc/ssl/open4j 目录
然后 SSH 进到 lede 修改 /etc/config/uhttpd 配置文件

```
vi /etc/config/uhttpd

# 修改下面这两个option
option cert '/etc/ssl/open4j/certificate.crt'
option key '/etc/ssl/open4j/private.key'

# cert 为下载来的certificate.crt文件路径
# key 为下载来的private.key文件路径

# 保存后重启 uhttpd
service uhttpd restart
```

最后修改 lede frpc 插件配置
![image 15](15.png)
![image 16](16.png)

用 https 访问 esxi、群晖，只有配置好证书就可以了，具体配置方法这里不一一介绍了，善用搜索引擎。

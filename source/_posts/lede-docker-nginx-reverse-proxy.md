---
title: OpenWRT/LEDE软路由下利用docker安装nginx实现反向代理
date: 2019-04-07 15:35:55
categories:
  - Router
tags:
  - LEDE
  - DSM
  - nginx
  - Openwrt
  - ROS
  - docker
  - ajenti
  - proxy
---

<!--more-->

上一篇文章 [利用群晖的反向代理服务器转发内网服务,实现外网免端口访问内网服务](https://blog.open4j.com/2019/04/07/use-dsm-nginx-reverse-proxy/) 讲了利用利用群晖的反向代理服务器转发内网服务，有人可能没有群晖 NAS，本文将介绍在软路由 LEDE 下安装 docker，用 docker 的 nginx 容器来配置和群晖反向代理一样的功能。

前期一些配置就不再多介绍了，下面从上一篇[文章](https://blog.open4j.com/2019/04/07/use-dsm-nginx-reverse-proxy/)的第四点开始配置

### 一、OpenWRT/LEDE 添加磁盘

\* 本文是以 koolshare 论坛的 LEDE x86 为例进行配置

#### 1. 在 ESXI 下给 lede 添加硬盘

![图片 1](1.jpg)
![图片 2](2.jpg)

#### 2. 用 SSH 登录 lede 给硬盘进行分区并格式化

![图片 3](3.jpg)
![图片 4](4.jpg)
![图片 5](5.jpg)
![图片 6](6.jpg)
![图片 7](7.jpg)

#### 3. 在 LEDE 界面挂载分区

![图片 8](8.jpg)
![图片 9](9.jpg)
![图片 10](10.jpg)
![图片 11](11.jpg)

### 二、 安装 docker 插件

安装 docker 之前，先给 lede 加一块硬盘，如果 lede 是安装在物理机可以不加磁盘

#### 安装 docker

![图片 12](12.jpg)
![图片 13](13.jpg)

### 三、 下载 nginx docker 镜像

![图片 14](14.png)
![图片 15](15.png)
![图片 16](16.png)

### 四、 创建并启动 nginx 容器

先在 /mnt/docker 目录下创建文件夹

```
cd /mnt/docker
mkdir nginx
mkdir nginx/conf
mkdir nginx/conf.d
cd nginx
```

创建 nginx.conf,内容如下:

```
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

![图片 18](18.png)
![图片 19](19.png)

启动参数如下

```
-p 88:80
-p 8443:443
-v /mnt/docker/nginx/nginx.conf:/etc/nginx/nginx.conf
-v /mnt/docker/nginx/proxy_params:/etc/nginx/proxy_params
-v /mnt/docker/nginx/conf/:/etc/nginx/sites-enabled
-v /mnt/docker/nginx/conf.d/:/etc/nginx/conf.d
--network host
```

![图片 21](21.png)

浏览器访问 http://ledeip:88 就能访问到 Nginx
![图片 29](29.png)

### 五、配置 nginx 虚拟主机(域名)反向代理

#### 增加虚拟主机配置文件

以反向代理群晖 NAS 服务为例
在 /mnt/docker/nginx/conf 文件夹增加 dsm.open4j.com 配置文件：
配置文件名为二级域名
server_name 也为二级域名

```
cd /mnt/docker/nginx/conf
vi dsm.open4j.com
server {
    listen 88;
    listen [::]:88;

    server_name dsm.open4j.com;

    location / {
        proxy_set_header        Host                $http_host;
        proxy_set_header        X-Real-IP           $remote_addr;
        proxy_set_header        X-Forwarded-For     $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto   $scheme;
        proxy_intercept_errors  on;
        proxy_http_version      1.1;

        proxy_pass http://192.168.1.252:5000;
    }
}
```

#### 重启 nginx 容器

```
docker restart nginx
```

#### 在主路由中配置端口映射

以 ROS 为例
![图片 25](25.png)
![图片 26](26.png)

输入 http://dsm.open4j.com:88 就能访问到群晖 NAS 了
![图片 27](27.png)

#### 转发其他服务

转发其他服务和转发 NAS 一样在 /mnt/docker/nginx/conf/ 目录下添加一个配置文件
修改 server_name 和 proxy_pass 地址
然后重启 nginx 容器

```
docker restart nginx
```

输入 配置的 server_name 对应的域名就能访问了
也可以 將 lede 的 88 端口映射到外網 80 端口，這樣就可以不帶端口訪問了。
如果有 https 訪問需要配置證書，原理是一樣的，大家自行找相關資料吧。

![图片 30](30.png)

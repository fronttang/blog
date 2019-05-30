---
title: OpenWRT/LEDE软路由下利用docker安装nginx实现反向代理
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

### 一、OpenWRT/LEDE添加磁盘
\* 本文是以koolshare论坛的LEDE x86 为例进行配置

#### 1. 在ESXI下给lede添加硬盘
![图片 1](1.jpg)
![图片 2](2.jpg)

#### 2. 用SSH登录lede给硬盘进行分区并格式化
![图片 3](3.jpg)
![图片 4](4.jpg)
![图片 5](5.jpg)
![图片 6](6.jpg)
![图片 7](7.jpg)

#### 3. 在LEDE界面挂载分区
![图片 8](8.jpg)
![图片 9](9.jpg)
![图片 10](10.jpg)
![图片 11](11.jpg)

### 二、 安装docker插件
安装docker之前，先给lede加一块硬盘，如果lede是安装在物理机可以不加磁盘

#### 安装docker
![图片 12](12.jpg)
![图片 13](13.jpg)

### 三、 下载nginx docker镜像

![图片 14](14.jpg)
![图片 15](15.jpg)
![图片 16](16.jpg)

### 四、 创建并启动nginx容器

![图片 17](17.jpg)
![图片 18](18.jpg)
![图片 19](19.jpg)

启动参数如下
```
-p 88:80
-p 8443:443
-v /mnt/docker/nginx/conf.d/:/etc/nginx/conf.d
--network bridge
```

![图片 20](20.jpg)
![图片 21](21.jpg)

### 五、测试nginx

先测试转发群晖服务检查nginx反向代理功能是否正常

在 /mnt/docker/nginx/conf.d 目录创建 default.conf 配置文件
![图片 24](24.jpg)

default.conf 内容如下
```
server {
    listen 80;
    listen [::]:80;

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
![图片 23](23.jpg)

重启nginx容器后用浏览器访问 http://ledeip:88 看是否进入到群辉的界面
```
docker restart nginx
```
![图片 22](22.jpg)

### 六、配置nginx虚拟主机(域名)反向代理

将刚才的default.conf配置文件增加 server_name dsm.yudomain.com;

```
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

重启nginx容器
```
docker restart nginx
```

在主路由中配置端口映射
心ROS为例
![图片 25](25.jpg)
![图片 26](26.jpg)

输入 http://dsm.open4j.com:88 就能访问到群晖NAS了
![图片 27](27.jpg)

转发LEDE服务
在 /mnt/docker/nginx/conf.d/ 目录下添加一个配置文件 lede.conf

```
cd /mnt/docker/nginx/conf.d
vi lede.conf
server {
    listen 88;
    listen [::]:88;

    server_name lede.open4j.com;

    location / {
        proxy_set_header        Host                $http_host;
        proxy_set_header        X-Real-IP           $remote_addr;
        proxy_set_header        X-Forwarded-For     $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto   $scheme;
        proxy_intercept_errors  on;
        proxy_http_version      1.1;

        proxy_pass http://192.168.1.22;
    }
}
```

这里与上面的default.conf的区别就是server_name 和 proxy_pass 不一样。

重启nginx容器
```
docker restart nginx
```
输入 http://lede.open4j.com:88 就能访问lede的web了

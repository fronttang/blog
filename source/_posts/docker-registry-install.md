---
title: 教你分分钟搞定Docker私有仓库Registry
date: 2018-12-21 14:18:04
categories:
  - Docker
tags:
  - CentOS
  - Docker
---

<!--more-->

### 一、什么是 Docker 私有仓库 Registry

官方的 Docker hub 是一个用于管理公共镜像的好地方，我们可以在上面找到我们想要的镜像，也可以把我们自己的镜像推送上去。但是，有时候我们的服务器无法访问互联网，或者你不希望将自己的镜像放到公网当中，那么你就需要 Docker Registry，它可以用来存储和管理自己的镜像。

### 二、安装 Docker 及 Registry

#### 安装 Docker

见之前博文：

https://blog.open4j.com/2018/12/17/centos7-install-docker/

#### 安装 Registry：

很简单，只需要运行一个 Registry 容器即可（包括下载镜像和启动容器、服务）

```
docker run -d -p 5000:5000 -v /data/registry:/var/lib/registry --name registry --restart=always registry
```

### 三、如何使用 Registry

我也看过其他博文，经常报的一个错误就是：

unable to ping registry endpoint https://172.18.3.22:5000/v0/
v2 ping attempt failed with error: Get https://172.18.3.22:5000/v2/: http: server gave HTTP response to HTTPS client
这是由于 Registry 为了安全性考虑，默认是需要 https 证书支持的.

但是我们可以通过一个简单的办法解决：

修改/etc/docker/daemon.json 文件

```
#vi /etc/docker/daemon.json
{
"insecure-registries": ["<ip>:5000"]
}
#systemctl daemon-reload
#systemctl restart docker
```

注：<ip>：Registry 的机器 ip 地址，在安装 registry 的节点和客户端需要访问私有 Registry 的节点都需要执行此步操作。

### 四、通过 docker tag 重命名镜像，使之与 registry 匹配

```
docker tag inits/nginx1.8 <ip>:5000/nginx1.8:latest
```

### 五、上传镜像到 Registry

```
docker push <ip>:5000/nginx1.8:latest
```

### 六、查看 Registry 中所有镜像信息

```
curl http://<ip>:5000/v2/\_catalog
返回：
{"repositories":["centos6.8","jenkins1.638","nginx","redis3.0","source2.0.3","zkdubbo"]}
```

### 七、其他 Docker 服务器下载镜像

```
docker pull <ip>:5000/nginx1.8:latest
```

### 八、启动镜像

```
docker run -it <ip>:5000/nginx1.8:latest /bin/bash
```

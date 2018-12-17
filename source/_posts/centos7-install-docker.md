---
title: Centos7上安装docker
date: 2018-12-17 15:17:14
categories:
  - docker
  - CentOS
tags:
  - CentOS
  - docker
---

<!--more-->

Docker 从 1.13 版本之后采用时间线的方式作为版本号，分为社区版 CE 和企业版 EE。

社区版是免费提供给个人开发者和小型团体使用的，企业版会提供额外的收费服务，比如经过官方测试认证过的基础设施、容器、插件等。

社区版按照 stable 和 edge 两种方式发布，每个季度更新 stable 版本，如 17.06，17.09；每个月份更新 edge 版本，如 17.09，17.10。

### 一、安装 docker

#### 1、Docker 要求 CentOS 系统的内核版本高于 3.10 ，查看本页面的前提条件来验证你的 CentOS 版本是否支持 Docker 。

通过 uname -r 命令查看你当前的内核版本

```bash
$ uname -r
```

#### 2、使用 root 权限登录 Centos。确保 yum 包更新到最新。

```bash
$ sudo yum update
```

#### 3、卸载旧版本(如果安装过旧版本的话)

```bash
$ sudo yum remove docker docker-common docker-selinux docker-engine
```

#### 4、安装需要的软件包， yum-util 提供 yum-config-manager 功能，另外两个是 devicemapper 驱动依赖的

```bash
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

#### 5、设置 yum 源

```bash
$ sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

![图片 1](1.png)

#### 6、可以查看所有仓库中所有 docker 版本，并选择特定版本安装

```bash
$ yum list docker-ce --showduplicates | sort -r
```

![图片 2](2.png)

#### 7、安装 docker

```bash
$ sudo yum install docker-ce  #由于repo中默认只开启stable仓库，故这里安装的是最新稳定版17.12.0$ sudo yum install <FQPN> # 例如：sudo yum install docker-ce-17.12.0.ce
```

![图片 3](3.png)

#### 8、启动并加入开机启动

```bash
$ sudo systemctl start docker
$ sudo systemctl enable docker
```

#### 9、验证安装是否成功(有 client 和 service 两部分表示 docker 安装启动都成功了)

```bash
$ docker version
```

![图片 4](4.png)

### 二、问题

#### 1、因为之前已经安装过旧版本的 docker，在安装的时候报错如下：

```bash
Transaction check error:
file /usr/bin/docker from install of docker-ce-17.12.0.ce-1.el7.centos.x86_64 conflicts with file from package docker-common-2:1.12.6-68.gitec8512b.el7.centos.x86_64
file /usr/bin/docker-containerd from install of docker-ce-17.12.0.ce-1.el7.centos.x86_64 conflicts with file from package docker-common-2:1.12.6-68.gitec8512b.el7.centos.x86_64
file /usr/bin/docker-containerd-shim from install of docker-ce-17.12.0.ce-1.el7.centos.x86_64 conflicts with file from package docker-common-2:1.12.6-68.gitec8512b.el7.centos.x86_64
file /usr/bin/dockerd from install of docker-ce-17.12.0.ce-1.el7.centos.x86_64 conflicts with file from package docker-common-2:1.12.6-68.gitec8512b.el7.centos.x86_64
```

#### 2、卸载旧版本的包

```bash
$ sudo yum erase docker-common-2:1.12.6-68.gitec8512b.el7.centos.x86_64
```

![图片 5](5.png)

#### 3、再次安装 docker

```bash
$ sudo yum install docker-ce
```

### 三、常用命令

爬一些常用 Docker 命令，更多命令详解，请访问：http://www.docker.org.cn/dockerppt/106.html:

```
docker ps # 查看当前正在运行的容器
docker ps -a # 查看所有容器的状态
docker start/stop id/name # 启动/停止某个容器
docker attach id # 进入某个容器(使用 exit 退出后容器也跟着停止运行)
docker exec -ti id # 启动一个伪终端以交互式的方式进入某个容器（使用 exit 退出后容器不停止运行）
docker images # 查看本地镜像
docker rm id/name # 删除某个容器
docker rmi id/name # 删除某个镜像
docker run --name test -ti ubuntu /bin/bash # 复制 ubuntu 容器并且重命名为 test 且运行，然后以伪终端交互式方式进入容器，运行 bash
docker build -t soar/centos:7.1 . # 通过当前目录下的 Dockerfile 创建一个名为 soar/centos:7.1 的镜像
docker run -d -p 2222:22 --name test soar/centos:7.1 # 以镜像 soar/centos:7.1 创建名为 test 的容器，并以后台模式运行，并做端口映射到宿主机 2222 端口，P 参数重启容器宿主机端口会发生改变
```

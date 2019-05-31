---
title: 用ipxe网络启动打造无盘ESXi系统
date: 2019-05-29 22:35:09
categories:
  - IPXE
  - ESXi
  - CentOS
  - iSCSI
tags:
  - IPXE
  - NETBOOT
  - ESXi
  - iSCSI
  - NAS
  - TFTP
  - DHCP
---

<!--more-->

### 一、源码与链接

#### 几个相关链接

1. 同胞网友写的教程共 3 篇，基本上我都是按他的教程来的
   https://t17.techbang.com/topics/50737-build-a-remote-boot-system-using-synology-nas-ipxe-part-i-compact-remote-boot-system-management-tool
   https://t17.techbang.com/topics/50767-build-a-remote-boot-system-using-synology-nas-ipxe-part-ii-install-and-start-ubuntu-linux-on-an-iscsi-disk
   https://t17.techbang.com/topics/50776-establish-a-remote-boot-system-using-synology-nas-ipxe-part-iii-install-and-start-ms-windows-on-an-iscsi-disk
2. 外国友人博客
   https://www.reversengineered.com/2016/01/07/booting-linux-isos-with-memdisk-and-ipxe/
   https://www.reversengineered.com/2015/11/25/netboot-xyz/
   https://www.reversengineered.com/2015/02/11/booting-vmware-esxi-in-ipxe/
3. ipxe
   ipxe 论坛关于 ESXi 的
   http://forum.ipxe.org/showthread.php?tid=1123&highlight=esxi
   ipxe 官网
   http://ipxe.org

#### 相关源码

1. ipxe 源码
   https://github.com/ipxe/ipxe
2. netboot.xyz 源码，供学习
   https://github.com/antonym/netboot.xyz
3. 我自己编译配置好的 kpxe 及一些启动菜单配置
   https://github.com/fronttang/netboot-tftp

### 二、编译一个带 iSCSI 和 COMBOOT 功能的 iPXE 固件

这个参考 ipxe 官网或 [iPXE 编译增加功能与自定义脚本](https://blog.open4j.com/2019/05/30/ipxe-build-embedded-script/) 进行编译，在我的源码 netboot-tftp 中有编译好可用的 kpxe 文件

### 三、群晖 NAS 里配置 DCHP、TFTP 和 WEB 服务器

先按同胞网友写的教程 Part 1 配置好群晖的 iSCSI、DCHP、TFTP 和 WEB 服务器

#### 开启 TFTP 服务

![image 1](1.png)

将 netboot-tftp 源码里全部文件上传到 /PXE/Grub 文件夹下
![image 2](2.png)

#### 开启 DHCP 服务

![image 3](3.png)
![image 4](4.png)

#### 开启 PXE 并设置启动文件

![image 5](5.png)

#### 网络启动测试

![image 6](6.png)
![image 7](7.png)

#### 开启 WEB 服务

开启群晖 web station 并设置虚拟主机用来加载一些系统的引导文件
![image 8](8.png)
![image 9](9.png)

### 四、在群晖配置 iSCSI target 和 iSCSI LUN

![image 10](10.png)
![image 11](11.png)
![image 12](12.png)

### 五、修改 tftp 根目录中的文件

![image 13](13.png)
![image 14](14.png)

### 六、通过网卡 DHCP 启动机器安装系统

![image 6](6.png)
![image 15](15.png)
![image 16](16.png)

在 menu.ipxe 的一些网络地址没问题的话，就能进入 ESXi 的安装界面了

![image 22](22.png)

这里安装的时候硬盘选择界面会出现 iSCSI 的硬盘，如果有其他硬盘的话别选错了
如果没有出现 iSCSI 硬盘，那肯定是加载出错了。（图片下次补上）

### 七、安装完成启动系统

![image 17](17.png)
![image 23](23.png)

### 八、关于 DHCP 与 TFTP 服务器

按照上面的教程是在内网开启了两个 DHCP 服务器，一个是主路由的，我这里是 ROS，一个是群晖的。
这样会导致有些时候网络启动后 iPXE DHCP 获取到的结果不是想要的结果，比如 next-server 地址错误
会导致加载不到启动脚本而进不了菜单，这里建议内网只有一个 DHCP 服务器，这样就会有 DHCP 服务干扰了
下面介绍使用 ROS、LEDE 的 DHCP 和 TFTP 服务器

#### ROS DHCP 与 TFTP 设置

将 netboot-tftp 源码上传到 ROS 的 files，然后 ip -> TFTP 开启 ROS 的 TFTP 服务
![image 18](18.png)
![image 21](21.png)

DHCP server 里配置 next server 和 boot file server
![image 19](19.png)

#### LEDE 的 DHCP 与 TFTP 设置

如果是使用 LEDE 的 DHCP 和 TFTP 服务器，则将 netboot-tftp 源码上传到 lede 路由上
然后在 网络 -> DHCP/DNS 下进行配置 TFTP 服务
![image 20](20.png)

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

### 一、知识点太多，先简单介绍。

#### 几个相关连接

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
3. 我自己编译配置好的 ipxe 及一些启动菜单配置
   https://github.com/fronttang/netboot-tftp

### 二、编译一个带 iSCSI 和 COMBOOT 功能的 iPXE 固件

这个参考 ipxe 官网或 [iPXE 编译增加功能与自定义脚本](https://blog.open4j.com/2019/05/30/ipxe-build-embedded-script/) 进行编译，在我的源码 netboot-tftp 中有编译好可用的 kpxe 文件

### 三、群晖 NAS 里配置 iSCSI、DCHP、TFTP 和 WEB 服务器

先按同胞网友写的教程 Part 1 配置好群晖的 iSCSI、DCHP、TFTP 和 WEB 服务器
![image 1](1.png)
![image 2](2.png)
![image 3](3.png)
![image 4](4.png)
![image 5](5.png)
![image 6](6.png)
![image 7](7.png)
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
在 menu.ipxe 的一些网络地址没问题的话，就能进入 ESXi 的安装界面了。这里就暂时不贴图了

### 七、安装完成启动系统

![image 17](17.png)

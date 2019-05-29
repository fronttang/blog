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

### 知识点太多，先简单介绍。
#### 几个相关连接
1. 同胞网友写的教程共3篇，基本上我都是按他的教程来的
 https://t17.techbang.com/topics/50737-build-a-remote-boot-system-using-synology-nas-ipxe-part-i-compact-remote-boot-system-management-tool
 https://t17.techbang.com/topics/50767-build-a-remote-boot-system-using-synology-nas-ipxe-part-ii-install-and-start-ubuntu-linux-on-an-iscsi-disk
 https://t17.techbang.com/topics/50776-establish-a-remote-boot-system-using-synology-nas-ipxe-part-iii-install-and-start-ms-windows-on-an-iscsi-disk
2. 外国友人博客
https://www.reversengineered.com/2016/01/07/booting-linux-isos-with-memdisk-and-ipxe/
https://www.reversengineered.com/2015/11/25/netboot-xyz/
https://www.reversengineered.com/2015/02/11/booting-vmware-esxi-in-ipxe/
3. ipxe
论坛关于ESXi的 http://forum.ipxe.org/showthread.php?tid=1123&highlight=esxi
ipxe官网 http://ipxe.org

#### 相关源码
1. ipxe源码 https://github.com/ipxe/ipxe
2. netboot.xyz源码，供学习 https://github.com/antonym/netboot.xyz
3. 我自己配置好的ipxe及一些启动菜单配置 https://github.com/fronttang/netboot-tftp

### 编译一个带iSCSI和COMBOOT功能的ipxe
这个参考ipxe官网及ipxe论坛的一些文章进行编译，这里选不展开介绍，在我的源码netboot-tftp中有编译好可用的ipxe文件

### 群晖NAS里配置iSCSI、DCHP、TFTP 和 WEB服务器
先按同胞网友写的教程Part 1配置好群晖的iSCSI、DCHP、TFTP 和 WEB服务器
![image 1](1.png)
![image 2](2.png)
![image 3](3.png)
![image 4](4.png)
![image 5](5.png)
![image 6](6.png)
![image 7](7.png)
![image 8](8.png)
![image 9](9.png)
### 在群晖配置iSCSI target和iSCSI LUN
![image 10](10.png)
![image 11](11.png)
![image 12](12.png)

### 修改 tftp 根目录中的文件
![image 13](13.png)
![image 14](14.png)

### 通过网卡DHCP启动机器安装系统
![image 6](6.png)
![image 15](15.png)
![image 16](16.png)
在menu.ipxe的一些网络地址没问题的话，就能进入ESXi的安装界面了。这里就暂时不贴图了

## 安装完成启动系统
![image 17](17.png)

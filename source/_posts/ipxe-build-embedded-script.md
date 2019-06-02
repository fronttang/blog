---
title: iPXE编译增加功能与自定义脚本
date: 2019-05-30 10:36:48
categories:
  - IPXE
  - CentOS
  - iSCSI
tags:
  - IPXE
  - NETBOOT
  - iSCSI
  - NETBOOT
---

<!--more-->

### 一、iPXE 概要

按[iPXE 官网](http://ipxe.org/start)的介绍是这样的：iPXE 是领先的开源网络启动固件。它提供了一个完整的 PXE 实现，增强了其他功能，例如通过 HTTP 从 Web 服务器启动、从 iSCSI SAN 启动 等等.
![image 1](1.png)

### 二、下载 iPXE 源码并编译(CentOS 环境)

 官方编译文档：
http://ipxe.org/download
http://ipxe.org/appnote/buildtargets#special_targets

#### git 下载 iPXE 源码

```
git clone git://git.ipxe.org/ipxe.git
```

或

```
git clone https://github.com/ipxe/ipxe.git
```

![image 2](2.png)

#### make 编译

```
cd ipxe/src
make bin/undionly.kpxe
```

编译前先安装这些依赖环境
gcc (version 3 or later)
binutils (version 2.18 or later)
make
perl
liblzma or xz header files
mtools
mkisofs (needed only for building .iso images)
syslinux (for isolinux, needed only for building .iso images)

编译后会在 bin 目录下生成 undionly.kpxe 文件，这个就是 iPXE 网络启动固件
![image 3](3.png)

 如果要编译 64 位 pcbios 或 efi 固件请参考 [官网文档](http://ipxe.org/appnote/buildtargets#special_targets)

通过网络启动后是这样的界面(命令模式)
![image 4](4.png)
关于网络启动请参考[用 ipxe 网络启动打造无盘 ESXi 系统](https://blog.open4j.com/2019/05/29/net-boot-ipxe-esxi-centos-windows-etc-from-iscsi-lun/)

### 三、开启其他功能

编译好以后默认开启的功能有
DNS、HTTP、iSCSI、TFTP、AoE、ELF、MBOOT、PXE、bzImage、Menu、PXEXT
在上图的启动界面可以看到。

 如果要加载 HTTPS web 的内容，那就要开启 HTTPS
还有一些系统启动需要开启 COMBOOT 功能
下面以开启 HTTPS 和 COMBOOT 功能为例进行编译
 修改源码下 src/config/general.h 文件

```
vi config/general.h
```

找到 DOWNLOAD_PROTO_HTTPS，将 DOWNLOAD_PROTO_HTTPS 前面有#undef 改成 #define
找到 IMAGE_COMBOOT 将前面的注释去掉

```
#define DOWNLOAD_PROTO_HTTPS    /* Secure Hypertext Transfer Protocol */
#define IMAGE_COMBOOT           /* SYSLINUX COMBOOT image support */
```

或者将上面的代码添加到源码目录 src/config/local/general.h 文件里

修改完用前面的 make bin/undionly.kpxe 重新编译即可

现在用新生成的 undionly.kpxe 固件网络启动后就多了 HTTPS 和 COMBOOT
![image 5](5.png)

### 四、添加自定义脚本

官方文档：http://ipxe.org/embed

默认编译启动后按 Ctrl+B 进入命令模式
可以输入下面的命令进入到外国友人做的 menu 界面
注：首先你网络启动的 DHCP 服务器设置的 DNS 能访问网络

```
dhcp
chain --autofree https://boot.netboot.xyz
```

进入后如图
![image 6](6.png)

如果想网络启动后直接进入 menu 界面，而不通过命令行输入命令，那就需要编译的时候加入自定义脚本
我们把上面的进入 menu 的代码编译进固件

在源码 src 目录下新建脚本文件 script.ipxe，将上面的命令 copy 到文件

```
vi script.ipxe
#!ipxe
dhcp
chain --autofree https://boot.netboot.xyz
```

重新编译增加参数 EMBED=script.ipxe

```
make bin/undionly.kpxe EMBED=script.ipxe
```

![image 7](7.png)

使用新的 undionly.kpxe 网络引导，直接会进入 netboot.xyz 的 menu 界面

![image 8](8.png)

也可以使用自己的菜单界面
[这里](https://github.com/fronttang/netboot-tftp)有我使用的菜单界面源码，只要将源码放到 TFTP 根目录，然后在编译的时候加入下面的自定义脚本

```
vi script.ipxe
#!ipxe
dhcp
chain --autofree tftp://${next-server}/boot.ipxe
```

网络启动后就能进入自己的菜单了
![image 9](9.png)

#### 开启debug模式

有时候会遇到一些奇葩问题不知道如果解决，这时候可以开启debug模式，这里以开启iSCSI的debug为例

在编译的时候增加 DEBUG=iscsi 参数
```
make bin/undionly.kpxe EMBED=script.ipxe DEBUG=iscsi
```

编译后用新固件引导启动，在sanhook iscsi命令的时候就会出现debug日志信息
![image 11](11.png)

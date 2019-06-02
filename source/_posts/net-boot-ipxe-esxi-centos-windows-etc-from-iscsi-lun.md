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
如果没有出现 iSCSI 硬盘，那肯定是加载出错了。
![image 28](28.png)
![image 29](29.png)

### 七、安装完成启动系统

![image 17](17.png)
![image 23](23.png)

### 八、关于 DHCP 与 TFTP 服务器

按照上面的教程是在内网开启了两个 DHCP 服务器，一个是主路由的，我这里是 ROS，一个是群晖的。
这样会导致有些时候网络启动后 iPXE DHCP 获取到的结果不是想要的结果，比如 next-server 地址错误
会导致加载不到启动脚本而进不了菜单，这里建议内网只有一个 DHCP 服务器，这样就不会有 DHCP 服务干扰了
下面介绍使用 ROS、LEDE 的 DHCP 和 TFTP 服务器

#### ROS 的 DHCP 与 TFTP 设置

将 netboot-tftp 源码上传到 ROS 的 files，然后 ip -> TFTP 开启 ROS 的 TFTP 服务
![image 18](18.png)
![image 21](21.png)

DHCP server 里配置 next server 和 boot file name
![image 19](19.png)

#### LEDE 的 DHCP 与 TFTP 设置

如果是使用 LEDE 的 DHCP 和 TFTP 服务器，则将 netboot-tftp 源码上传到 lede 路由上
然后在 网络 -> DHCP/DNS 下进行配置 TFTP 服务
![image 20](20.png)

### 九、对特殊电脑做特别设置

脚本是支持多个电脑启动不同的系统到电脑对应系统的iSCSI LUN
这就是上面创建 iSCSI target的时候target名称为什么要用 主机名.系统名
![image 10](10.png)

\* 设置电脑网卡mac地址脚本
比如要让电脑A(网卡MAC地址为 00:12:34:56:78:90) 启动到 mini.系统名 的iSCSI
那就是设置电脑A的主机名为 mini
如果使用群晖的DHCP，则可以在群群晖DHCP客户端列表里给MAC地址设置主机名
![image 4](4.png)

如果一些不能设置主机名的DHCP服务器，如ROS，如果不用做特殊设置，则hostname 为空
这样脚本会找 mac地址.系统名 的iSCSI, 这样就会取不到iSCSI, 除非你iSCSI target用 mac地址.系统名 命名

在 netboot-tftp 源码目录下有一个boot文件夹，这个文件夹就是放置对应主机或MAC地址特殊脚本的目录
在boot目录下创建文件, 文件的命名格式为 mac-mac地址去掉冒号字每小写.ipxe
例如 mac-001234567890.ipxe
在文件里添加脚本如下：
```
#!ipxe
echo
# 设置这个mac地址的主机名
set hostname mini
set initiator-iqn ${base-iqn}:${hostname}
echo Booting ${hostname}

# 这里还可以设置默认进入的菜单和在菜单上的等待时间
# 比如装好系统后设置 default 为 esxi ,timeout 为1秒或更短
# 这样就可以直接进入esxi系统，省去选择菜单步骤。在装好系统不要用菜单的时候很有用
set menu-default esxi
set menu-timeout 10000

chain --replace --autofree ${menu-url}
```

### 十、折腾过程中遇到的坑
#### 关于iscsi 的 sanuri 坑
仔细看 netboot-tftp 里菜单命令会发现有一条命令 sanhook ${root-path}
是扫描加载 iSCSI的
全路径是这样的
sanhook iscsi:192.168.1.252::::iqn.iqn.2000-01.com.synology:mini.ESXi

[iPXE官方文档](http://ipxe.org/sanuri)有对这个进行说明:
![image 44](44.png)

```
iscsi:<servername>:<protocol>:<port>:<LUN>:<targetname>
```

我们把其中的 protocol、prot、LUN 都省略了，所以成了::::
其中LUN是一个坑，官方文档中有对LUN的介绍是这个样的
```
<LUN> is the SCSI LUN of the boot disk, in hexadecimal. It can be left empty, in which case the default LUN (0) will be used.
```
LUN 是指要加载 iSCSI target 中哪个LUN，值是LUN的编号 ,关键信息是 默认值 为 0。
使用我的脚本加载 DS3617xs 中的 iSCSI 一切正常
但是用这个脚本加载DS918+ 的中 iSCSI 就会加载不到
研究了几个小才发现
在我在 DS3617xs 中 iSCSI target 第一个LUN 的编号为 0
![image 45](45.png)

而DS918+ 中 iSCSI target 第一个LUN 的编号为 1
![image 46](46.png)

所以如果发现自己 iSCSI target 第一个LUN 的编号为 1 的，请修改 netboot-tftp 源码中的 boot.ipxe.cfg 文件

![image 47](47.png)

将
```
set base-iscsi iscsi:${iscsi-server}::::${base-iqn}
```
改成
```
set base-iscsi iscsi:${iscsi-server}:::1:${base-iqn}
```

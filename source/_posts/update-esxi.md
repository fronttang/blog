---
title: 用命令升级ESXi6.7到ESXi6.7u2
date: 2019-06-02 13:00:18
categories:
  - ESXi
tags:
  - ESXi
  - SSH
---

<!--more-->

### 一、下载 ESXi 升级文件

在 [官网](https://my.vmware.com/group/vmware/patch#search) 下载升级文件 update-from-esxi6.7-6.7_update02

![image 1](1.png)

### 二、将文件上传到 ESXi

可以直接通过 ESXi 的 web 界面将下载的升级文件上传到 datastore

![image 2](2.png)
![image 3](3.png)

### 三、开启 SSH,关闭虚拟机

1. 开启 SSH
   ![image 4](4.png)

2. 关闭虚拟机
   ![image 5](5.png)

3. 进入维护模式
   ![image 7](7.png)

### 四、安装更新

1. 用 SSH 工具进入 ESXi
   ![image 6](6.png)

2. 执行安装

输入命令进行安装, 这里要输入升级包的全路径

```
esxcli software vib update -d /vmfs/volumes/5bf02f7f-4ff1fc33-27e0-0c54a5521b94/update-from-esxi6.7-6.7_update02.zip
reboot
```

![image 8](8.png)

如果显示依赖错误，请先升级更老的 build 版本,比如 U1 等等
参考：https://communities.vmware.com/message/2810545

3. 重启完关闭维护模式并开启虚拟机
   ![image 9](9.png)

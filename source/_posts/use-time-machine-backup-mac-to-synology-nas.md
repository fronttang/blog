---
title: [转]使用 Time Machine 将文件从 Mac 备份至 Synology NAS
date: 2019-06-01 20:20:41
categories:
  - DMS
  - MacOS
tags:
  - NAS
  - MacOS
  - Time Machine
  - backup
---

<!--more-->

原文地址：http://www.cdaten.com/news/html/?778.html

![image 1](1.png)
### 总览
本文将引导您使用 Apple Time Machine Mac OS X 10.5 和更高版本随附的备份实用程序），将数据从 Mac OS X 计算机备份至 Synology DiskStation。

### 1.设置 DiskStation 以支持 Time Machine
将 DiskStation 设置为 Time Machine 的目的地之前，您需要先登录 DSM 并更改部分设置。
#### 1.1 为 Time Machine 备份创建共享文件夹
1. 使用属于 administrators 群组的帐户登录 DSM。
2. 前往控制面板 > 共享文件夹，然后单击创建以创建共享文件夹。
![image 2](2.png)
3. 为该共享文件夹输入名称（如“Time Machine Folder”）并选择位置（如果存在多个卷）。在此示例中，我们将选择卷 1。
![image 3](3.png)
4. 如果要对共享文件夹 Time Machine Folder 进行加密，请选中加密此共享文件夹框并输入加密密钥，然后单击下一步。
![image 4](4.png)
5. 按需要为共享文件夹配置高级设置，然后单击下一步。
![image 5](5.png)
6. 单击应用。
![image 6](6.png)
7. 单击确定。
![image 7](7.png)
8. 您现在应看到新创建的共享文件夹。
![image 8](8.png)

#### 1.2 为 Time Machine 创建用户并设置配额限制
1. 前往控制面板 > 用户，然后单击创建。
![image 9](9.png)
2. 输入用户名（如“Time Machine User”）并指定密码。然后单击下一步。
![image 10](10.png)
3. 单击下一步。
![image 11](11.png)
4. 确保向此用户分配对 Time Machine Folder 的读取/写入权限，然后单击确定。
![image 12](12.png)
5. 在此示例中，我们要将数据备份至 Time Machine Folder。但是，我们不希望备份用尽空间，因此我们将指定使用配额。在用户配额设置页面上，在配额栏中输入偏好值，然后从下拉菜单中选择单位。例如，我们将 Time Machine Folder 中的配额设置为 200 GB。指定配额之后，单击下一步。
![image 13](13.png)

注：
我们建议您设置配额以避免 Time Machine 占用您的整个存储空间。一般而言，配额应至少为 Mac 硬盘大小或要备份数据量的两倍或三倍。
用户只能在支持 Btrfs 文件系统的型号上为单个文件夹设置使用配额。如果 NAS 服务器仅支持 EXT4 系统，则只能为整个卷设置使用配额。

6. 单击下一步。
![image 14](14.png)
7. 单击下一步。
![image 15](15.png)
8. 单击应用。
![image 16](16.png)
9. 现在我们应有一个名为 Time Machine User 的用户。
![image 17](17.png)

#### 1.3 将共享文件夹设置为 Time Machine 的备份目的地
1. 前往控制面板 > 文件服务。
![image 18](18.png)
2. 在 SMB/AFP/NFS 选项卡上找到 AFP 部分，然后选中启用 AFP 服务框。
![image 19](19.png)

注：
Time Machine 同时支持 SMB 和 AFP。对于 macOS Sierra 和更高版本，Time Machine 使用 SMB 代替 AFP 作为默认协议。
如果您想要通过 SMB 备份文件，请前往同一选项卡的 SMB 部分，然后选中启用 SMB 服务框。

3. 前往高级选项卡，选中启用通过 AFP 进行 Bonjour Time Machine 播送框，然后单击设置 Time Machine 文件夹按钮。
![image 20](20.png)
4. 选择您刚刚从 Time Machine 菜单创建的共享文件夹，然后单击应用以保存设置。
![image 21](21.png)

注：如果您在步骤 1.3.2 中选择使用 SMB，则改为选中启用通过 SMB 进行 Bonjour Time Machine 播送框。选择您刚创建的共享文件夹，然后单击应用。然后，在弹出窗口中单击是以确认并保存您的设置。

### 2.执行 Time Machine 备份至 DiskStation
本节将介绍如何配置 Time Machine，使其将 DiskStation 的共享文件夹设置为备份目的地。此过程可让 Time Machine 在局域网上轻易地找到您的 DiskStation，并将其视为备份硬盘。设置完成后，Time Machine 就能够开始将数据备份到 DiskStation。

#### 2.1 连接到您的 NAS 服务器
1. 在 Mac 上，单击顶部菜单栏中的前往，然后选择连接到服务器。
![image 22](22.png)
2. 输入 NAS 服务器的地址。根据步骤 1.3.2 中的设置使用 AFP 或 SMB。指定地址之后，单击连接。
![image 23](23.png)
3. 输入您的帐户凭据，然后单击连接。
![image 24](24.png)
4. 从列表中选择 Time Machine Folder，然后单击确定。
![image 25](25.png)

#### 2.2 配置 Time Machine 以将 DiskStation 设置为其备份硬盘
1. 在 Mac 上，从 Dock 打开系统偏好设置，然后单击 Time Machine。
2. 选中自动备份框，然后单击选择硬盘。
![image 26](26.png)
3. 选择您创建的共享文件夹（在此例中为 Time Machine Folder），然后单击使用硬盘。
![image 27](27.png)
4. 系统将提示您提供您的帐户凭据。输入您刚创建的用户的用户名和密码，然后单击连接。
![image 28](28.png)
5. Time Machine 将立即开始备份数据。

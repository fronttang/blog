---
title: Mac终端神器zsh
date: 2019-06-26 13:50:06
categories:
  - MacOS
tags:
  - MacOS
  - Shell
  - Terminal
  - git
  - docker
---

<!--more-->

先上一张图

![图片 1](1.png)

### 一、背景介绍

在 unix 内核的操作系统中,当然现在衍生出好多分支,linux ,OS X 都算.

shell 就算和上面这些系统内核指令打交道的一座桥梁,我们通过键盘输入一种自己容易记忆识别的符号标识(shell 命令)

然后 shell 解析这种命令再反馈给内核去执行一系列操作.

zsh 和 shell 有什么关系呢?

其实 zsh 也是一种 shell ,但是并不是我们系统默认的 shell ,unix 衍生系统的默认 shell 都是 bash。

#### 1. 查看已安装 shell

查看 Mac 上已有的 shell,一共有 6 种

```
cat /etc/shells

/bin/bash
/bin/csh
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh
```

#### 2. 将默认 shell 改成 zsh

```
$ chsh -s /bin/zsh
```

#### 3. 安装“oh my zsh”

手动安装：

```
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

PS：详细信息可以参考 [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) 的 GitHub 页面

### 二、 配置 zsh

```
vi ~/.zshrc
```

设置别名

```
alias zshconfig='vi ~/.zshrc'
alias vimconfig='vi ~/.vimrc'
alias ll='ls -l'
alias vi='vim'
alias atom='open -a "Atom"'
```

启用命令纠错功能

```
# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"
```

### 三、插件

git
osx
autojump
只需要在.zshrc 中启用

```
plugins=(git osx autojump)
```

关于 oh-my-zsh 的 git 插件 ，已经设置了很多 git 命令的 alias 别名，这样我们可以使用别名来执行命令，这样也可以提高一下效率
例如输入 gl 等同于 git pull

```
alias gl='git pull'
alias gm='git merge'
alias gp='git push'
alias gr='git remote
alias grb='git rebase'
alias grh='git reset'
alias grm='git rm
alias grmv='git remote rename'
alias grrm='git remote remove
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v
alias gts='git tag -s'
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias glum='git pull upstream master'
# .... 还有很多方便使用的别名
```

还有[docker 别名](https://github.com/akarzim/zsh-docker-aliases)插件

```
dk is short for docker
dka Attach to a running container
dka! Attach to a running container by name
dkb Build an image from a Dockerfile
dkd Inspect changes on a container's filesystem
dkdf Show docker filesystem usage
dke Run a command in a running container
dkE Run an interactive command in a running container
dkE! Run an interactive command in a running container by name
dkh Show the history of an image
# .... 还有很多方便使用的别名
```

### 四、shell 的配色

git 搜索[solarized](https://github.com/altercation/solarized) clone 到本地

```
git clone https://github.com/altercation/solarized
```

然后执行

```
solarized/osx-terminal.app-colors-solarized/Solarized Dark ansi.terminal
```

这时候在 mac 的偏好设置中就可以看到已导入的配置了
![图片 2](2.png)

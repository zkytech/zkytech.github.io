---
title:
  - Snort安装教程 以及 DARPA1999、DARPA2000数据处理方法
date:
  - 2020-01-04 21:34:00
tags:
  - Snort
  - DARPA
categories:
  - 其它
---

#### 参考：

- [centOS snort 安装](https://upcloud.com/community/tutorials/installing-snort-on-centos/)

- [windows snort 安装（视频）](https://www.youtube.com/watch?v=RwWM0srLSg0)

- [使用 snort 分析 DARPA 数据（视频）](https://www.youtube.com/watch?v=OA4hSFxyXXU)

&emsp;&emsp;因为毕业论文涉及到网络安全，需要对 DARPA 1999 这类数据进行分析，过程中发现`Snort`安装、使用相关的中文教程实在罕见，且安装配置过程较复杂，自己也踩了不少坑，为了以后方便，在这里对国外的一些实用教程进行汇总。

&emsp;&emsp;如果觉得文字不好理解可直接看参考中的视频教程。

### `Snort`在`Windows`上的安装过程

&emsp;&emsp;这里仅介绍在 Windows 上的安装教程，centOS 教程在参考中列出了

#### 下载

[官网](https://www.snort.org/#get-started)下载两个文件：

- snort 安装文件`Snort_x_x_x_Installer.exe`
- 版本号对应的规则文件`snortrules-snapshot-xxxxx.tar.gz`(注意检查版本号，要与安装文件匹配)

#### 安装

&emsp;&emsp;安装`snort`后，将`snortrules-snapshot-xxxxx.tar.gz`中的`rules`和`preproc_rules`文件夹解压并覆盖到`snort`安装根目录

#### 编辑`snort.conf`文件

&emsp;&emsp;由于简书不支持 diff 语法，不在这里贴出修改后的文件了，请移步 github 参考[diff 示例](https://github.com/zkytech/documents/issues/1)对`Snort\etc\snort.conf`进行修改。

#### 规则文件

&emsp;&emsp;`Snort`官网免费提供的规则文件对于 DARPA2000 这类比较久远的数据集而言十分鸡肋（比如针对`DDoS`的规则文件直接就是一个空文件，而`DARPA2000`的主要内容就是`DDoS`）。原因很简单，时代变了，很多在十几年前有效的规则不再适用于当前的网络环境，所以被删除了。即使你去使用付费订阅的规则集也未必对 DARPA 数据集有效。
&emsp;&emsp;snort 在版本迭代过程中删除的所有规则都可以在官网规则中的`deleted.rules`里面找到。但可惜的是，我找不到一个完整的修改日志，也就是说无法通过`deleted.rules`将规则还原到指定年代。我们用 DARPA2000 做研究又必须依赖那些比较老的规则集，而`Snort`官网已经不再提供这些老版本的下载途径。下面给出我自己搜集的`Snort老版本规则`以及一些`第三方规则`资源。

snort 老版本规则：
链接: https://pan.baidu.com/s/1IhN7fxq6Zjo0qGRKU2Urvw 提取码: qw1q

- [针对 DDoS 规则文件](https://github.com/RajkumarShah/Snort-for-DDoS-)
- [综合性规则文件(缺少 DDoS 检测)](https://github.com/codecat007/snort-rules)
- [Emerging Threats rule](https://rules.emergingthreats.net/open/snort-2.9.0/) (这个规则集亲测有效，但也不全面)

##### 关于`DARPA2000`

&emsp;&emsp;针对`DARPA2000`需要特别说明一下，这个数据集的`DDoS`攻击是内网主机被黑客控制向外网地址发出攻击，并且攻击过程中会随机地生成 IP 地址来隐藏源 IP。要想检测到这个 DDoS 攻击，规则中的 ip 和端口必须是`any any -> any any`，而不是`$EXTERNAL_NET any -> $HOME_NET any`。

#### 修改告警存储方式

&emsp;&emsp;默认存储的`xxx.ids`文件便于阅读，但不便于用程序分析。通过修改`snort.conf`可以将`Snort`告警的存储格式修改为`csv`，添加如下配置：

```
output alert_csv: alert.csv default
```

详细配置参数说明参照[文档](http://manual-snort-org.s3-website-us-east-1.amazonaws.com/node21.html)

需要注意：当配置了 csv 输出时，不会输出威胁等级。目前没有找到解决方法

### DARPA 数据处理

#### 错误示例

&emsp;&emsp;在很多文献中，使用`Snort`进行实验的步骤是

1. 以 IDS 模式运行`Snort`:

```
  snort -x 100 -i ens33 -c D:\Snort\etc\snort.conf -l D:\Snort\log -A full
```

2. 使用`tcpreplay`对数据进行重放

3. `Snort`检测到攻击并生成日志

4. 由于在重播时使用了倍速重播，还要解决时间间隔与原始数据不一致的问题。

#### 正确的做法

&emsp;&emsp;上面这种做法在你确实需要仿真环境做其它一些事情的时候，可能是一个很好的方案。但大多数情况下我们只是想要**获取`Snort`的告警日志**，其实用下面这一行代码就够了：

```
  snort -c D:\Snort\etc\snort.conf -r D:\data\DARPA1999\inside.tcpdump -l D:\Snort\log
```

&emsp;&emsp;`Snort`会自动地处理所有数据并生成告警日志，这种方式可以节省很多时间。生成的日志文件位于`D:\Snort\log`，且时间与`inside.tcpdump`完全一致。

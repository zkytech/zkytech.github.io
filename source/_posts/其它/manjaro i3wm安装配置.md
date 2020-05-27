
---
title:
  - manjaro i3wm安装配置 
date:
  - 2020-05-27 12:11:00
tags:
  - manjaro
  - i3wm
categories:
  - 其它
---
### 切换到国内源
shell运行
```bash
# 运行后选择一个即可
sudo pacman-mirrors -i -c China -m rank
# 更新数据源
sudo pacman -Syy
```
<!-- more -->
修改`/etc/pacman.conf`，在其末尾添加
```conf
[archlinuxcn]
SigLevel = Optional TrustedOnly
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```
继续在shell中运行
```bash
# 更新源列表
sudo pacman-mirrors -g
# 全面更新系统
sudo pacman -Syyu
# 防止签名错误
sudo pacman -S archlinuxcn-keyring
```

### 修正桌面显示日期方块的问题 
```bash
# 备份
cp /usr/share/conky/conky_maia /usr/share/conky/conky_maia.bak
vim /usr/share/conky/conky_maia
```
之后将文件中的所有`Bitstream Vera`替换为`anti`即可。

### 中文字体
```bash
sudo pacman -S ttf-roboto noto-fonts ttf-dejavu
# 文泉驿
sudo pacman -S wqy-bitmapfont wqy-microhei wqy-microhei-lite wqy-zenhei
# 思源字体
sudo pacman -S noto-fonts-cjk adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
```

### 中文输入法
这里只是中文输入法，不是搜狗输入法

参考[ArchWiki](https://wiki.archlinux.org/index.php/Fcitx_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

安装fcitx
```
# 一路回车即可
sudo pacman -S fcitx fcitx-im
```
在文件`~/.pam_environment`中添加以下内容
```
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
```
设置fcitx开机启动
编辑i3配置文件`~/.i3/config`，添加以下内容
```
exec_always --no-startup-id fcitx-autostart
```
配置fcitx
```bash
sudo pacman -S fcitx-configtool
fcitx-config-gtk3
```
### home目录下文件夹改为英文命名
```bash 
sudo pacman -S xdg-user-dirs-gtk
export LANG=en_US
xdg-user-dirs-gtk-update
# 选择更新名称
export LANG=zh_CN.UTF-8
xdg-user-dirs-gtk-update
# 选择不更新名称
```

### 软件启动器rofi
```bash
sudo pacman -S rofi
```
修改`~/.i3/config` 使用`rofi`替代`dmenu`
```
bindsym $mod+d exec --no-startup-id rofi -show combi 
```

### 科学上网qv2ray
```bash
sudo pacman -S v2ray qv2ray
```
#### 浏览器

i3wm环境下，代理的配置并不像KDE那么简单，经测试，以下方法可行：
1. chromium通过命令`chromium --proxy-server="socks://localhost:1088"`启动即可
2. firefox直接安装插件`switch omega`，配置好proxy并在autoswitch中添加autoproxy规则文件`https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt`
> 经测试google-chrome无法通过代理上网

#### 终端

`export ALL_PROXY=socks5://127.0.0.1:1088`

> 测试:`curl https://www.google.com`

### github加速
编辑`/etc/hosts`，添加以下解析记录
```
199.232.28.133  raw.githubusercontent.com
192.30.253.112  github.com
151.101.184.133  assets-cdn.github.com
151.101.185.194  github.global.ssl.fastly.net
```

### 常用软件及配置

#### nodejs yarn npm
一方面是开发需要，另一方面 后面安装的部分插件也依赖这个环境
```bash
sudo pacman -S nodejs npm yarn
# 设置淘宝源
npm config set registry https://registry.npm.taobao.org
yarn config set registry https://registry.npm.taobao.org
```

#### zsh
```bash
# 安装zsh
sudo pacman -S zsh
# 安装oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 恢复配置文件
# 这里是我个人的配置文件，谨慎使用
curl -fLo ~/.zshrc https://raw.githubusercontent.com/zkytech/linux_config_files/master/~/.zshrc
# 安装插件
# autojump
sudo pacman -S autojump
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

#### vim neovim
```
sudo pacman -S neovim gvim
# 安装vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# 恢复配置文件
git clone https://github.com.cnpmjs.org/https://github.com/zkytech/linux_config_files.git ~/Downloads/zkytech_linux_config
# 创建软链接
cp -r ~/Downloads/zkytech_linux_config/~/.config/nvim  ~/.config/nvim
```

#### compton
似乎是桌面图形渲染工具？我没有具体去了解，但后面alacritty依赖这个
```bash
# 安装compton
sudo pacman -S compton
# 创建配置文件
# 这里使用的是我自己的配置文件
curl -fLo ~/.config/compton.conf \
    https://raw.githubusercontent.com/zkytech/linux_config_files/master/~/.config/compton.conf
```

#### alacritty
告别i3丑陋的默认终端
```
# 安装alacritty
sudo pacman -S alacritty
# 恢复配置文件
# 这里使用的是我自己的配置文件
mkdir ~/.config/alacritty

curl -fLo ~/.config/alacritty/alacritty.yml --create-dirs \
    https://raw.githubusercontent.com/zkytech/linux_config_files/master/~/.config/alacritty/alacritty.yml 
```
编辑i3的配置文件`~/.i3/config`，将默认的terminal替换为alacritty

#### keepass
keepassXC与我的compton配置不兼容。因此使用keepass作为密码管理工具，keepass安装后可能会出现中文全部变成方框的情况。
进入`tools->options->select list font`选择一个中文字体即可，一般是“文泉驿XXX”

##### chrome插件
参照[ArchWiki](https://wiki.archlinux.org/index.php/KeePass#KeePass)
插件[下载地址](https://github.com/zkytech/linux_config_files/raw/master/KeePassRPC.plgx)

将插件放到`/usr/share/keepass/plugins`再启动keepass即可

配合chrome插件`Kee`使用

#### 其它
```
# 坚果云，chromium, firefox, variety（壁纸软件）, code，tldr-太长不看
sudo pacman -S nutstore chromium firefox variety tldr
```

#### 我的配置文件
[Github](https://github.com/zkytech/linux_config_files/)



---
title:
  - Threejs + wepack externals踩坑
date:
  - 2019-08-27 19:24:00
tags:
  - Threejs
categories:
  - 前端
---

&emsp;&emsp;`threejs`本身体积有 100+KB，在使用`webpack`的项目中自然会想到把它作为`external`来引入。但这种方式引入存在两个需要注意的点：
<!-- more -->
1. 在 controls 中（比如`TrackballControls`）会丢失表示按键的常量，在`TrackballControls`中是代表鼠标按键的常量，会导致无法使用鼠标进行镜头控制，而触控正常。此时只需将对应常量写入 controls 文件中即可。`TrackballControls`中加入以下常量的声明即可解决问题。

```javascript
MOUSE = {
	LEFT: 0,
	MIDDLE: 1,
	RIGHT: 2,
	ROTATE: 0,
	DOLLY: 1,
	PAN: 2,
};
```

2. 如果你使用`react`，且包含`threejs`内容的组件经常需要被加载和卸载，那么请千万不要将 threejs 放入`webpack externals`中，这会导致`threejs`无法被正常卸载，从而在后台占用大量计算资源。目前原因未知，但只要将`threejs`从`externals`中清除，问题就可以得到解决。

---
title:
  - hexo插件开发
date:
  - 2020-04-15 12:09:00
tags:
  - hexo
  - 插件
categories:
  - 前端
---

&emsp;&emsp;hexo官方文档虽然有给出api说明，但官方文档的说明太晦涩难懂。实际上最简单的方式就是去阅读github上一些hexo插件的源码。下面给出我个人觉得常用的api说明。

#### 使插件在执行`hexo generate`、`hexo deploy`时自动执行

```javascript
hexo.extend.filter.register(type, function(){}, priority);
```

参数说明：

| 参数         | required | 说明                                                         |
| ------------ | -------- | ------------------------------------------------------------ |
| type         | true     | 官网称为`过滤器类型`，我认为叫`钩子类型`或者`事件类型`更合适，这是决定后面的`function`在何时执行 |
| function(){} | true     | 需要执行的函数                                               |
| priority     | false    | 执行优先级，值越小优先级越高。默认为10                       |

事件类型：参考[hexo官方文档]([https://hexo.io/zh-cn/api/filter#%E8%BF%87%E6%BB%A4%E5%99%A8%E5%88%97%E8%A1%A8](https://hexo.io/zh-cn/api/filter#过滤器列表))

##### 实例
&emsp;&emsp;现在用一个最简单的`hello word`来说明这个api的作用。假设现在需要编写一个插件，在运行`hexo generate`时触发执行。

1. 按照[教程]([https://blog.zkytech.top/2020/04/14/%E5%89%8D%E7%AB%AF/npm%E5%8C%85%E5%BC%80%E5%8F%91%E5%92%8C%E5%8F%91%E5%B8%83/](https://blog.zkytech.top/2020/04/14/前端/npm包开发和发布/))创建一个npm包，并用`npm ln`安装到hexo项目中。
2. 在`index.js`中写入以下内容:

```javascript
hexo.extend.filter.register('before_generate', function(){
    console.log('hello word!')
});
```

3. 在hexo项目中运行`hexo generate`
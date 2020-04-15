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

&emsp;&emsp;hexo官方文档虽然有给出api说明，但官方文档的说明太晦涩难懂。实际上最简单的方式就是去阅读github上一些hexo插件的源码。下面给出我个人觉得常用的api的说明。
<!-- more -->
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
&emsp;&emsp;现在用一个最简单的`hello world`来说明这个api的作用。假设现在需要编写一个插件，在运行`hexo generate`开始前执行。

1. 按照[教程]([https://blog.zkytech.top/2020/04/14/%E5%89%8D%E7%AB%AF/npm%E5%8C%85%E5%BC%80%E5%8F%91%E5%92%8C%E5%8F%91%E5%B8%83/](https://blog.zkytech.top/2020/04/14/前端/npm包开发和发布/))创建一个npm包，并用`npm ln`安装到hexo项目中。注意：经过测试，**包名必须以`hexo-`开头**，否比如`hexo-demo-project`，否则无法使用hexo提供的api。

   > 从这点来看，hexo是通过扫描package.json中以`hexo-`开头的包名来实现这些api的。

2. 在`index.js`中写入以下内容:

```javascript
hexo.extend.filter.register('before_generate', function(){
    console.log('hello world! (before)')
});
```

3. 在hexo项目中运行`hexo generate`

![image-20200415133458381](http://qiniu.zkytech.top/image-20200415133458381.png)

#### 输入`hexo command`运行插件

&emsp;&emsp;比如我写的一个插件`hexo-localimage-to-qiniu`，在控制台运行`hexo imgtoqiniu`即可运行插件来上传markdown中的本地文件，并替换图片链接。这里要说的就是怎么注册`imgtoqiniu`这个指令。

```javascript
hexo.extend.console.register(
    // 这就是注册的command, 注册后运行hexo demo即可调用
	"demo",		
    // 对command的说明，运行hexo demo --help 会提示该信息
	"hexo console command demo",
	{
        // 使用方法说明，hexo demo --help 会提示该信息
		usage: "[action] [--date post_date]", 
        // 虽然命名为"arguments"，我觉得叫"action"更为贴切，使用示例：hexo demo layout
		arguments: [ 
			{ name: "layout", desc: "Post layout" },
			{ name: "title", desc: "Post title" },
		],
        // 这个叫arguments更合适，因为这里是可以接收参数的。比如: hexo demo -d "2020年4月15日"
		options: [{ name: "-d, --date", desc: "post date" }], 
	},
    // 主函数，args即上面接收的参数，无论参数是否输入正确都会执行。
	function (args) { 
		console.log("args:",args);
	}
);
```

运行`hexo demo --help`，得到以下提示

```shell
# 查看参数说明
>> hexo demo --help
Usage: hexo demo [action] [--date post_date]

Description:
hexo console command demo

Arguments:
  layout  Post layout
  title   Post title

Options:
  -d, --date  post date

# 测试
>> hexo demo layout -d "2020年4月15日"
args: { _: [ 'layout' ], d: '2020年4月15日' }
```


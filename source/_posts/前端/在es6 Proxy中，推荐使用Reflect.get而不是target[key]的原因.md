---
title:
  - 在es6 Proxy中，推荐使用Reflect.get而不是target[key]的原因
date:
  - 2019-10-20 12:20:00
tags:
  - es6
categories:
  - 前端
---

目前中文检索得不到这个问题的答案，大多数的博客都是直接使用了`Reflect.get`而没有给出原因。为了解释这个问题，首先还要说明另一个问题。

## `Reflect.get(target, prop, receiver)` 以及 Proxy 中的 `handler.get(target, prop, receiver)` 这当中的`receiver`是什么？

直接摘抄 MDN 的说明

> `Reflect.get(target, prop, receiver)`中的参数`receiver`：如果 target 对象中指定了 getter，receiver 则为 getter 调用时的 this 值。

> `handler.get(target, prop, receiver)`中的参数`receiver`：Proxy 或者继承 Proxy 的对象。

### 参数`receiver`存在的意义

单独来看，我很难想出`receiver`参数的使用场景，甚至会认为这个参数没有存在的意义，但既然这么设计就一定有它存在的意义。先看下面的例子：

```javascript
let People = new Proxy(
	{
		_name: "zky",
		get name() {
			return this._name;
		},
	},
	{
		get: function (target, prop, receiver) {
			return target[prop];
		},
	}
);
let Man = { _name: "zky_man" };
Man.__proto__ = People; // Man继承People
console.log(Man._name); // zky_man
console.log(Man.name); // zky
```

> 问题来了，`Man`中已经存在`_name`属性，但这里`Man.name`返回的却是原型链上的`_name`属性，
> 原因很好解释：`get name`中的`this`默认绑定为`People`。

那怎么解决这个问题呢？这里就该`receiver`上场了，修改上面的例子：

```javascript
let People = new Proxy(
	{ _name: "zky" },
	{
		get: function (target, prop, receiver) {
			// receiver指向的是get的调用者
			return Reflect.get(target, prop, receiver); // 调用get name函数时，this被绑定到receiver
		},
	}
);
let Man = {
	_name: "zky_man",
	get name() {
		return this._name;
	},
};
Man.__proto__ = People; // Man继承People
console.log(Man._name); // zky_man
console.log(Man.name); // zky_man
```

到这里问题就已经完美解决了，这也就是`Reflect.get`比`target[key]`更好的原因。

调用`Man.name`时经过了以下几步

1. 被`proxy`拦截，调用`handler.get`
2. `handler.get`中传入的`receiver`参数指向调用者--`Man`
3. 调用`Reflect.get`，由于`target`中的`name`指定了`getter`，`Reflect.get`自动将调用的`getter`函数的`this`绑定到`receiver`，也就是`Man`

如果没看懂请结合例子及上面对`receiver`参数的说明进行理解

参考文献：[https://javascript.info/proxy?tdsourcetag=s_pctim_aiomsg#proxying-a-getter](https://javascript.info/proxy?tdsourcetag=s_pctim_aiomsg#proxying-a-getter)

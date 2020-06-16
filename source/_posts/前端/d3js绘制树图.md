---
title:
  - d3js绘制树图
date:
  - 2020-06-16 18:20:00
tags:
  - d3
  - 树图
categories:
  - 前端
---

## 准备数据

既然要构建树图，那输入的数据自然也必须是树状（层次）结构的

d3 默认接受的树图数据格式如下所示：

<!-- more -->

```json
{
	"name": "Eve",
	"children": [
		{
			"name": "Cain"
		},
		{
			"name": "Seth",
			"children": [
				{
					"name": "Enos"
				},
				{
					"name": "Noam"
				}
			]
		},
		{
			"name": "Abel"
		},
		{
			"name": "Awan",
			"children": [
				{
					"name": "Enoch"
				}
			]
		},
		{
			"name": "Azura"
		}
	]
}
```

将上述数据通过`d3.hierarchy(data)`处理后生成 d3 能够处理的标准的层次结构数据。
`d3.hierarchy(data)`返回的节点（`Node`对象）和每一个后代会被附加如下属性:

- node.data - 关联的数据，由 constructor 指定.
- node.depth - 当前节点的深度, 根节点为 0.
- node.height - 当前节点的高度, 叶节点为 0.
- node.parent - 当前节点的父节点, 根节点为 null.
- node.children - 当前节点的孩子节点(如果有的话); 叶节点为 undefined.
- node.value - 当前节点以及 descendants(后代节点) 的总计值; 可以通过 node.sum 和 node.count 计算.

## 计算布局

```typescript
// 初始化一个树布局，并设定其宽高
const tree = d3.tree().size(height, width);
// 生成d3.tree能够处理的层次结构的数据
const nodes_ = d3.hierarchy(data);
// 计算树布局中各节点的位置，计算得到的默认布局是垂直的
const nodes = tree(nodes_);
```

其中 nodes 中的每个节点都会在`d3.hierarchy(data)`返回的`Node`对象的基础上附加上坐标位置属性：

- node.x - 节点的 x 坐标
- node.y - 节点的 y 坐标

## 绘制树图

```typescript
// 创建容器svg
const svg = d3
	.select("body")
	.append("svg")
	.attr("height", height)
	.attr("width", width);
// 树图容器
const g = svg.append("g");
// 标题
svg.append("text").attr("class", "title").text("Title of Tree");
// 树图节点之间的连线
const link = g
	.selectAll(".link")
	// 获取节点的连接信息，nodes.links()返回的数据类型是 {source:Node,target:Node}[]
	.data(nodes.links())
	.enter()
	.append("path")
	.attr("class", "link")
	.attr(
		"d",
		// @ts-ignore
		d3
			// 用于生成曲线连线
			.linkHorizontal()
			// 为了生成水平方向的树图，将坐标x、y对换
			.x((d) => d.y)
			.y((d) => d.x)
	);
// 树图节点
const node = g
	.selectAll(".node")
	// 获取一个包含所有节点数据的列表，nodes.descendants()返回的数据类型是 Node[]
	.data(nodes.descendants())
	.enter()
	.append("g")
	// 为了生成水平方向的树图，将坐标x、y对换
	.attr("transform", (d: any) => `translate(${d.y},${d.x})`);
// 绘制代表节点的圆形
node
	.append("circle")
	// 设置节点圆形的半径
	.attr("r", 5);
// 节点文本
node
	.append("text")
	.attr("x", (d: any) => (d.data.childern ? -15 : 10))
	.attr("y", (d: any) => (d.data.children ? -13 : 4))
	.text((d: any) => d.data.name);
```

css

```css
svg .title {
	font: 26px sans-serif;
	font-weight: 500;
	stroke: #007aa3;
	fill: #007aa3;
	letter-spacing: 2px;
}

.node circle {
	fill: #fff;
	stroke: grey;
	stroke-width: 2px;
}

.node text {
	font: 12px sans-serif;
}

.link {
	fill: none;
	stroke: #ccc;
	stroke-width: 2px;
}
```

![树图示例](http://qiniu.zkytech.top/msedge_xC1VQ9QUts.png)
当然，d3 可以绘制的不仅仅是这种树图，可以在[d3-hierarchy](https://github.com/xswei/d3-hierarchy/blob/master/README.md#tree)中找到绘制其它层次结构的图的相关方法。

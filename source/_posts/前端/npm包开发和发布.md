---
title:
  - npm包开发
date:
  - 2020-04-14 22:50:00
tags:
  - npm
categories:
  - 前端
---

#### 初始化

1. 创建项目目录`npm_demo_project`

2. `cd npm_demo_project`

3. `npm init -y`运行后会在项目根目录生成一个`package.json`，其内容如下所示

![image-20200414224357336](http://qiniu.zkytech.top/image-20200414224357336.png)

4. 创建文件`index.js`

#### 开发&测试

&emsp;&emsp;虽然可以直接在项目内做测试，但很多场景下都是因为自身项目需求去开发一个npm包，需要直接在项目里测试npm包。假设该项目为`project_a`，此时按以下步骤操作：

1. 在`npm_demo_project`的根目录下运行`npm ln`
2. 在`project_a`目录下运行`npm ln npm_demo_project`
3. 在`project_a`的`package.json`的`dependencies`中添加依赖`npm_demo_project:^1.0.0`

&emsp;&emsp;步骤2和3就相当于运行了`npm install npm_demo_project`，且此时对`npm_demo_project`的修改会直接反映到`project_a`中。

#### 发布

##### 排除文件

&emsp;&emsp;可能有部分文件不需要发布到npm包中，在根目录新建文件`.npmignore`，按照`.gitignore`的规则去填写即可排除文件。

##### publish

&emsp;&emsp;如果npm使用淘宝源：`npm publish --registry=https://registry.npmjs.org`

&emsp;&emsp;如果没有使用淘宝源：`npm publish`

#### 使用TypeScript

1. `npm install typescript -D`
2. `tsc --init`
3. 在根目录创建`index.ts`
4. 创建目录`dist`，`tsc`编译出来的文件会存储在这里
5. 修改`tsconfig.json`
```json
{
  "compilerOptions": {
    "target": "es5",                         
    "module": "commonjs",                     
    "strict": true,                           
    "esModuleInterop": true,                  
    "forceConsistentCasingInFileNames": true,  
    "outDir": "./dist"
  },
  "include": ["index.ts"]
}
```
6. 修改`package.json`
```diff
{
  "name": "npm_demo_project",
  "version": "1.0.0",
  "description": "",
- "main": "index.js",
+ "main": "./dist/index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
```

7. 实时编译：`tsc -watch`

然后就可以用`typescript`愉快地开发了。

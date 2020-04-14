---
title:
  - Java权限认证实现原理
date:
  - 2019-08-18 21:01:00
tags:
  - java
  - 权限
categories:
  - 后端
---

&emsp;&emsp;我们往往需要在很多不方便传值的地方获取用户的身份信息，此时如果通过传参的方式传递用户信息将会使代码变得十分难看。那么要怎样不通过传参直接获取用户的身份信息呢？
&emsp;&emsp;原理很简单，程序在接收用户请求时会新建一个线程专门去处理，对该请求的操作都是在这个线程上进行的，那么我们将用户信息绑定到线程的上下文，这样就可以在处理请求的任意位置直接获取到用户信息了。

&emsp;我们先新建一个表示用户信息的 bean

```java

import lombok.Builder;
import lombok.Data;


@Builder
@Data
public class AuthContext {
    private String username;
    private String role;
}

```

接下来创建一个操作线程上下文的类

```java

/**
 * 将授权信息绑定到线程上，从而实现在该线程执行的任意位置获取授权信息
 */
public class AuthContextHolder {

    private static final ThreadLocal<AuthContext> contextHolder = new ThreadLocal<>();

    /** 清空上下文 */
    public void clearContext(){contextHolder.remove();}

    public AuthContext createEmptyContext(){return AuthContext.builder().build();}

    /** 获取线程上下文 */
    public AuthContext getContext(){
        AuthContext ctx = contextHolder.get();
        if (ctx == null){
            ctx = createEmptyContext();
            contextHolder.set(ctx);
        }
        return ctx;
    }

    /** 设置上下文信息 */
    public void setContext(AuthContext authContext){ contextHolder.set(authContext); }
}

```

在密码校验或 session 校验的位置用`setContext`把用户信息保存到上下文。 然后在后续的任意位置可直接通过`AuthContextHolder`从线程上下文读取用户信息

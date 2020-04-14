---
title:
  - springboot环境下GraphQL权限认证的实现方法
date:
  - 2019-08-18 20:36:00
tags:
  - GraphQL
  - springboot
categories:
  - 后端
---

先放上 github 的链接[GraphQL demo](https://github.com/zkytech/graphql_demo)

<!-- more -->

`pom.xml`

```xml

<!--        graphQL依赖-->

        <dependency>

            <groupId>org.jetbrains.kotlin</groupId>

            <artifactId>kotlin-stdlib</artifactId>

            <version>${kotlin.version}</version>

        </dependency>

        <dependency>

            <groupId>com.graphql-java-kickstart</groupId>

            <artifactId>graphql-spring-boot-starter</artifactId>

            <version>5.10.0</version>

        </dependency>

        <dependency>

            <groupId>com.graphql-java-kickstart</groupId>

            <artifactId>altair-spring-boot-starter</artifactId>

            <version>5.10.0</version>

            <scope>test</scope>

        </dependency>

        <dependency>

            <groupId>com.graphql-java-kickstart</groupId>

            <artifactId>graphiql-spring-boot-starter</artifactId>

            <version>5.10.0</version>

            <scope>test</scope>

        </dependency>

        <dependency>

            <groupId>com.graphql-java-kickstart</groupId>

            <artifactId>playground-spring-boot-starter</artifactId>

            <version>5.10.0</version>

            <scope>test</scope>

        </dependency>

```

GraphQL 要实现权限认证主要是依靠`directive`

先创建一个`directive`

```java

public class RoleDirective implements SchemaDirectiveWiring {

    @Override

    public GraphQLFieldDefinition onField(SchemaDirectiveWiringEnvironment<GraphQLFieldDefinition> env) {

        List<String> targetRoles = (List<String>) env.getDirective().getArgument("roles").getValue();

        DataFetcher originDataFetcher = env.getFieldDataFetcher();

        env.setFieldDataFetcher(new DataFetcher() {

            @Override

            public Object get(DataFetchingEnvironment environment) throws Exception {

                // 从线程上下文中获取用户身份信息

                AuthContextHolder authContextHolder = new AuthContextHolder();

                AuthContext authContext = authContextHolder.getContext();

                // 权限认证逻辑

                if (targetRoles.contains(authContext.getRole())) {

                    // 用户身份在给定的role列表中，调用dataFetcher返回数据

                    return originDataFetcher.get(environment);

                } else {

                    // 用户身份不在role列表中，直接返回null

                    return null;

                }

            }

        });

        return env.getElement();

    }

}

```

接下来就是对`directive`进行配置

```java

    // 像这样添加roleDirective，如果要添加多个就创建多个类似的Bean

    @Bean

    public SchemaDirective myCustomDirective() {

        return new SchemaDirective("role", new RoleDirective());

    }

```

`.graphqls`文件写法

```graphql
directive @role(roles: [String!]!) on FIELD_DEFINITION

type Book {
	id: ID

	name: String

	pageNum: Int @role(roles: ["ADMIN"])

	authorId: ID @role(roles: ["ADMIN"])

	author: Author
}
```

至此，对 GraphQL 的权限认证配置就完成了。
`AuthContextHolder`的实现可以看这片文章[Java 权限认证实现原理](https://www.jianshu.com/p/8219c0b30615)

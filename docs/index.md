---
lang: zh-CN
description: 页面的描述
sidebar: false
---
# 项目简介

## wink

> wink 是一个综合项目，包含了 wink-cli 和 wink-core 两个项目

-   wink-core：一个插件系统抽象项目，可以用来快速开发插件系统
-   wink-cli：一个 cli 工具，通过插件模式进行开发，可以通过命令行快速配置项目

## wink-render

> 项目是一个移动端渲染工具，通过配置 JSON 文件能够快速渲染出页面，加速开发

## wink-vue-admin

> 项目主要功能是快速实现后台页面开发，项目分为三个子项目，分别是 api、web 和 compile

-   api：使用 nestjs 开发内置了 sqlite 数据库，为项目提供了后端数据
-   web：使用 vue3+element-plus 开发出的一个后台管理系统，方便快捷实现数据增删改查
-   compile：使用 ts 开发的 dsl 编译工具以及代码生成工具，能够快速生成 nestjs 模块和 vue 界面

## wink-script(wks)

> 一个自定义的 dsl 用来快速生成代码信息

## 开发计划
- 功能开发
  - 完成wink-compile前端页面生成功能
  - wink-web前端上传dsl文件生成代码
  - 添加wink-cli插件(vue-router,react)
  - :white_check_mark: 完成wink-render项目提取
- 文档开发
  - 添加wink-script语言说明
  - 添加wink-api使用文档

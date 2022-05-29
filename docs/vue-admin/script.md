# wink-script
> wink-script是一个用于生成wink-vue-admin模块的DSL，实现项目的快速开发
## 使用方式
```ts
import { setConfigPath, translate, analyse, nodeParser } from '@wink/compile'
import { readFileSync } from 'fs'
import { resolve } from 'path'
// 设置源文件路径
const path = resolve(__dirname, '../../../sources/model.wks')
// 设置输出路径和nestjs模块入口文件
setConfigPath({ outDir: '../api/src/', appModulePath: '../api/src/app.module.ts' })
// 读取源码
const source = readFileSync(path).toString()
// 解析tokens
const result = analyse(source)
if (!result.error) {
	// 解析为AST Node
	nodeParser(result.data).then(node => {
		// 从AST Node提取信息生成代码 
		translate(node)
	})
}
```
**model.wks**
```txt
#name: "hello"
// api or database
#way: "database"
#model {
	id: @id @number
	name: @string
	score: @number
	isMale: @boolean @nullable
}

#dto {
	name: @string
	score: @number
	isMale: @boolean
}

#api {
	@get
	@post
	@delete
	@update
	@all
}
```
## 语法说明
### 带#关键字
> 信息定义，表示为生成结果关键字
- #name
  > 生成的模块名称，类型为字符串
- #way
  > 模块获取数据的方式，类型为字符串，可设置为databases和api
- #model
  > 数据模型，为块类型，用于生成模块模型信息 
- #dto
  > 请求参数，为块类型，用于生成创建请求的DTO
- #api
  > 请求API生成，内置多个请求关键字，用于生成模块controller
### 带@关键字
- @id
  > #model下的字段内置关键字，用于生成模型主键ID
- @number
  > #model下的字段关键字，用于标记字段为数字
- @boolean
  > #model下的字段关键字，用于标记字段为布尔值
- @nullable
  > #model下的字段关键字，用于标记字段可以为空
- @string
  > #model下的字段关键字，用于标记字段为字符串
- @get
  > #api下的字段关键字，用于生成get单个数据请求
- @post
  > #api下的字段关键字，用于增加数据请求
- @delete
  > #api下的字段关键字，用于删除数据请求
- @update
  > #api下的字段关键字，用于更新数据请求
- @all
  > #api下的字段关键字，获取表中所有数据
### 赋值语句
> 赋值语句通过符号:设置，节点左侧为变量，右侧为表达式
### 块语句
> 使用大括号{}包裹，用来表示复杂信息
### 表达式语句
> 表示值字段信息

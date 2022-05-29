# wink-cli
> wink-cli使用插件方式开发，可以通过添加插件编写功能
## 运行入口函数(pkg-core)
> pkg-core是wink-cli入口,通过命令行调用run函数执行
### 执行功能
1. 插件运行前，创建项目文件夹
2. 插件运行中，创建package对象，用于添加安装依赖
3. 插件执行完成后，将依赖package信息写入项目package.json文件中
   
**代码示例**
```ts
// 创建packCore作为入口
const pkgCore = createWinkCore(async () => {
	// 创建项目文件夹
	const projectName = await createPkgDir()
	return {
		context: {
			projectName,
			// 初始化package.json信息
			pkg: createPkg({ name: projectName })
		}
	}
})
```
**package.json文件类型结构**
```ts
export interface PkgType {
	name: string
	version: string
	description: string
	main: string
	scripts?: Record<string, string>
	author: string
	devDependencies?: {
		[key: string]: string
	}
	keyword: (string | boolean | number)[]
	dependencies?: {
		[key: string]: string
	}
}
```
### 安装插件
1. 使用createWinkPlugin或者createWinkPack函数创建插件
2. pkgCore创建以后调用use函数传入插件信息
   
**代码示例**
```ts
// 创建编辑插件
const editorPlugin = createWinkPlugin()
```
```ts
// 使用插件
pkgCore.use(editorPlugin)
```
## 插件设置(editor-plugin)
> editor-plugin是一个编辑文件设置生成包括.eslintrc、.prettierc和.editorConfig文件
### 设置文件模板
- prettier模板
  ```ts
	const PrettierStr = `{
		"useTabs": true,
		"tabWidth": 4,
		"printWidth": 120,
		"semi": false,
		"singleQuote": true,
		"trailingComma": "none",
		"arrowParens": "avoid",
		"bracketSpacing": true,
		"endOfLine": "crlf",
		"vueIndentScriptAndStyle": true
	}
	`
  ```
- eslint模板
  ```ts
	const EslintStr = `{
		"env": {
			"browser": true,
			"es2021": true,
			"node": true
		},
		"extends": ["plugin:vue/vue3-essential", "standard", "plugin:prettier/recommended"],
		"parserOptions": {
			"ecmaVersion": 12,
			"parser": "@typescript-eslint/parser",
			"sourceType": "module"
		},
		"plugins": ["vue", "@typescript-eslint"],
		"rules": {
			"vue/no-multiple-template-root": "off",
			"no-unused-vars": "off",
			"camelcase": "off"
		},
		"globals": {
			"defineProps": "readonly",
			"defineEmits": "readonly",
			"defineExpose": "readonly",
			"withDefaults": "readonly"
		}
	}`
  ```
- editorConfig模板
  ```ts
  const EditStr = `[*]
	indent_style = tab
	indent_size = 4
	end_of_line = crlf
	tab_width = 4
	charset = utf-8
	trim_trailing_whitespace = false
	insert_final_newline = true
	[*.{yaml,yml}]
	tab_width = 2
	`
  ```
- 添加所需依赖信息和文件名信息
  ```ts
	export const editorTemplate: EditorFile[] = [
		{
			path: '.editorconfig',
			content: EditStr,
			name: 'editorConfig'
		},
		{
			path: '.prettierrc',
			content: PrettierStr,
			name: 'prettier',
			depends: [
				{ name: 'prettier', isDev: true },
				{
					name: 'eslint-config-prettier',
					isDev: true
				},
				{
					name: 'eslint-plugin-prettier',
					isDev: true
				}
			]
		},
		{
			path: '.eslintrc',
			content: EslintStr,
			name: 'eslint',
			depends: [
				{ name: 'eslint', isDev: true },
				{ name: 'eslint-config-standard', isDev: true },
				{ name: 'eslint-plugin-n', isDev: true },
				{ name: 'eslint-plugin-node', isDev: true },
				{ name: 'eslint-plugin-promise', isDev: true },
				{ name: 'eslint-config-standard', isDev: true },
				{ name: 'eslint-plugin-import', isDev: true },
				{ name: 'eslint-config-standard', isDev: true }
			]
		}
	]
  ```
### 设置inquirer prompt信息
```ts
export const PromptSelect = [
	{
		type: 'confirm',
		message: '是否使用editorConfig',
		name: 'editorConfig',
		default: false
	},
	{
		type: 'confirm',
		message: '是否使用prettier',
		name: 'prettier',
		default: false
	},
	{
		type: 'confirm',
		message: '是否使用eslint',
		name: 'eslint',
		default: false
	}
]
```
### 安装依赖并创建文件
> 用户选择完成后遍历配置信息生成文件同时设置依赖
**代码示例**
```ts
const editorExit = async (ctx: PkgCtx) => {
	const tasks = files
		.filter(file => selectMap[file.name])
		.map(file => {
			write2File(file.path, file.content)
			const childTasks = file.depends && file.depends.map(depend => addPkgDepend(ctx.pkg, depend))
			return childTasks ? Promise.all(childTasks) : []
		})
	await Promise.all(tasks)
}
```
## 函数说明
### render
> render是一个通用的渲染函数，通过设置模板字符串和传入参数生成解析信息
- 解析源信息，传入字符串使用%分割变量
  ```ts
  // 调用render函数
  render(`hello,%val%`,{val:'kugou'})
  ```
- 传入参数，参数通过ts类型体操提取出源字符串中%%之间的字符作为变量
	```ts
	export type RenderConfig<T extends string> = T extends `${string}%${infer U}%${infer reset}`
		? RenderConfig<reset> extends never
			? {
					[key in U]: number | string
			}
			: {
					[key in keyof RenderConfig<reset> | U]: number | string
			}
		: never
	```
- 填入参数，返回所需字符串
	```ts
	/**
	 * 模板渲染函数
	 *
	 * @param source 模板信息
	 * @param config 模板配置
	 * @returns 字符串
	 */
	export const render = <T extends string>(source: T, config: RenderConfig<T>) => {
		const len = source.length
		let i = 0
		let isKey = false
		let result = ''
		let key = ''
		while (i < len) {
			const char = source[i]
			if (char === '\n' || char === '\t' || char === '\r') {
				result += char
			} else if (char === '%') {
				if (isKey) {
					result += config[key]
					key = ''
				}
				isKey = !isKey
			} else if (isKey) {
				key += char
			} else {
				result += char
			}
			i++
		}
		return result
	}

	```
### getLatestVersion
> getLatestVersion用来获取npm包依赖最新版本
**代码示例**
```ts
import shell from 'shelljs'

export const getLatestVersion = (packageName: string) => {
	return new Promise<string>(resolve => {
		shell.exec(`npm view ${packageName} version`, { silent: true }, (code, stdout) => {
			resolve(stdout.toString().trim())
		})
	})
}
```
### jsonByOBJ
> jsonByOBJ用来将Object或者Array转换为json
> 
> JSON.stringify没有换行，所以封装了这个函数
**入口函数**
```ts
export const jsonByOBJ = <T extends object | unknown[]>(source: T, indent = 1): string => {
	if (isArray(source)) {
		return convertArray(source as unknown[], indent)
	} else {
		return convertObj(source, indent)
	}
}
```
**工具函数**
```ts
const isArray = <T>(source: T) => {
	return Object.prototype.toString.apply(source) === '[object Array]'
}

const isObject = <T>(source: T) => {
	return Object.prototype.toString.apply(source) === '[object Object]'
}
```
**数组转换**
```ts
const convertArray = (source: unknown[], indent: number): string => {
	let result = '['
	const len = source.length
	for (let i = 0; i < len; i++) {
		const item = source[i]
		const comma = i === len - 1 ? '' : ', '
		if (isObject(item) || isArray(item)) {
			result += `\n${jsonByOBJ(item as object, indent + 1)}\n`
		} else if (typeof item === 'string') {
			result += `"${item}"${comma}`
		} else {
			result += `${item}${comma}`
		}
	}
	return result + ']'
}
```
**对象转换**
```ts
const convertObj = (source: object, indent: number): string => {
	let result = '{\n'
	const keys = Object.keys(source) as (keyof typeof source)[]
	const len = keys.length
	for (let i = 0; i < len; i++) {
		const key = keys[i]
		const item = source[key]
		const tab = '\t'.repeat(indent)
		const comma = i === len - 1 ? '' : ','
		if (isArray(item) || isObject(item)) {
			result += `${tab}"${key}": ${jsonByOBJ(item as object, indent + 1)}${comma}\n`
		} else {
			result += `${tab}"${key}": "${item}"${comma}\n`
		}
	}
	return result + '\t'.repeat(indent - 1) + '}'
}
```

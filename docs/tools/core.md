# wink-core
> wink-core是一个灵活的插件系统，通过使用插件模块化的方式组织代码，降低开发难度
## plugin插件
> plugin插件模块，内置生命周期函数，通过外部调用完成函数运行
### createWinkPlugin
> 参数为对象或者异步函数

**参数信息(所有参数都为非必传)**
| **参数名称** | **作用**             | **详细说明**                             |
| ------------ | -------------------- | ---------------------------------------- |
| payload      | 用于给调用者传递信息 | 根据调用类型设置                         |
| start        | 插件开始生命周期函数 | 为异步函数并且使用多线程执行，线程不安全 |
| active       | 插件运行生命周期函数 | 为异步函数，线程安全                     |
| exit         | 插件调用结束函数     | 为异步函数并且使用多线程执行，线程不安全 |


**示例代码**
```ts
// 传入参数为对象
const plugin = createWinkPlugin({
	payload: { name: 'plugin', age: 10 },
	start: async (ctx: { name: string }) => {
		console.log(ctx)
	}
})
```
```ts
// 传入参数为函数
const plugin = createWinkPlugin(async ()=>({
	payload: { name: 'plugin', age: 10 },
	start: async (ctx: { name: string }) => {
		console.log(ctx)
	})
})
```
## pack包
> pack是一个综合模块，可以用来作为基体调用其他插件或者包，同时也是一个插件，能够更加方便划分开发模块
### createWinkPack
> 参数为对象或者异步函数

**参数信息(所有参数都为非必传)**
| **参数名称** | **作用**             | **详细说明**                             |
| ------------ | -------------------- | ---------------------------------------- |
| payload      | 用于给调用者传递信息 | 根据调用类型设置                         |
| start        | 插件开始生命周期函数 | 为异步函数并且使用多线程执行，线程不安全 |
| active       | 插件运行生命周期函数 | 为异步函数，线程安全                     |
| exit         | 插件调用结束函数     | 为异步函数并且使用多线程执行，线程不安全 |

### WinkPack
#### use
> 传入插件信息，保存至对象中
```ts
// 引入插件
pack.use(plugin,pack)
```
#### setPluginEnterHook
> 在所有插件start方法运行前调用
#### setPluginStartHook
> 在所有插件start方法运行完成后调用
#### setPluginActiveHook
> 在所有插件active方法运行完成后调用
#### setPluginExitHook
> 在所有插件exit方法运行完成后调用
#### setActivatedHook
> 在所有插件active方法完成后调用
## core运行模块
> core是一个综合模块用来调用函数，内置run执行调用其包含的所有函数信息
### createWinkCore
> 参数为对象或者异步函数

**参数信息(所有参数都为非必传)**
| **参数名称** | **作用**             | **详细说明**                             |
| ------------ | -------------------- | ---------------------------------------- |
| payload      | 用于给调用者传递信息 | 根据调用类型设置                         |
| start        | 插件开始生命周期函数 | 为异步函数并且使用多线程执行，线程不安全 |
| active       | 插件运行生命周期函数 | 为异步函数，线程安全                     |
| exit         | 插件调用结束函数     | 为异步函数并且使用多线程执行，线程不安全 |

### WinkCore
#### use
> 传入插件，执行调用
#### run
> 运行方法，传入preFunc、endFunc
- preFunc：运行前执行方法
- endFunc：运行后执行方法

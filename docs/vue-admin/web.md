# wink-admin-web
> 这是一个后台管理系统的前端页面，使用vue3+ts+element-plus+pinia开发综合后台管理系统
## 主题设置
1. scss变量设置
  ```scss
	$menuText: #bfcbd9;
	$menuActiveText: #ffffff;
	$subMenuActiveText: #f4f4f5;

	$menuBg: #304156;
	$menuHover: #263445;

	$subMenuBg: #1f2d3d;
	$subMenuHover: #001528;

	$sideBarWidth: 210px;
	$navbarHeight: 50px;
	$tagViewHeight: 34px;
	$hideSideBarWidth: 54px;
	$sideBarDuration: 0.28s;
	$tagsViewDuration: 0.3s;
	$sideBarLogoSize: 44;
  ```
2. 设置element主题
   - 选择主题颜色
   - 下载element style样式
      ```ts
		const getOriginalStyle = async () => {
			const version = dependencies['element-plus'].replace('^', '')
			const url = `https://unpkg.com/element-plus@${version}/dist/index.css`
			const { data } = await axios(url)
			return getStyleTemplate(data)
		}
	  ``` 
   - 插入style样式到html中
      ```ts
		export const writeStyle = (elNewStyle: string) => {
			const style = document.createElement('style')
			style.innerText = elNewStyle
			document.head.appendChild(style)
		}
	  ``` 	
3. 设置自定义主题，使用pinia创建store，保存选择的颜色信息，通过store获取颜色变量设置样式  
## 右侧导航
1. 获取路由信息
   ```ts
	export const filterRouters = (routes: RouteRecordRaw[]) => {
		const childrenRoutes = getChildrenRoutes(routes)
		return routes.filter(route => !childrenRoutes.find(childrenRoute => childrenRoute.path === route.path))
	}

	export function generateMenus(routes: RouteRecordRaw[]) {
		const result: AdminMenuItem[] = []
		routes.forEach(item => {
			if (!item.meta || Object.keys(item.meta).length === 0) {
				if (item.children && item.children.length > 0) {
					result.push(...generateMenus(item.children))
				}
			} else if (!item.meta.noAuth && !item.meta.hidden && !item.meta.white) {
				let route = result.find(route => route.path === item.path)
				if (!route) {
					route = {
						path: item.path,
						title: item.meta.title,
						icon: item.meta.icon,
						children: []
					}
					result.push(route)
				}

				if (item.children && route.children) {
					route.children.push(...generateMenus(item.children))
				}
			}
		})
		return result
	}
   ``` 
2. 使用组件渲染路由
   ```vue
	<script lang="ts" setup>
		import { AdminMenuItem } from '@/types'

		defineProps<{ route: AdminMenuItem }>()
	</script>
	<template>
		<el-sub-menu v-if="route.children && route.children.length > 0" :index="route.path">
			<template #title>
				<menu-item :icon="route.icon" :title="route.title"></menu-item>
			</template>
			<sidebar-item v-for="item in route.children" :key="item.path" :route="item"></sidebar-item>
		</el-sub-menu>
		<el-menu-item v-else :index="route.path">
			<menu-item :icon="route.icon" :title="route.title"></menu-item>
		</el-menu-item>
	</template>
   ``` 
## 浏览历史
通过router的beforeEach函数，获取路由跳转记录生成历史记录数据，传入封装的tag-view组件展示历史记录

**TagView**
```ts{13}
router.beforeEach(async (to, form, next) => {
  	const user = useUser()
  	const app = useApp()
  	document.title = `${to.meta.title}`
  	if (user.getToken) {
  		if (to.meta.noAuth) {
  			next('/')
  		} else {
  			if (!user.hasUserInfo) {
  				await user.fetchUserInfo()
  			}
  			if (!to.meta.noAuth) {
  				app.addTagView({ path: to.path, fullPath: to.fullPath, title: to.meta.title })
  			}
  			next()
  		}
  	} else {
  		if (to.meta.noAuth) {
  			next()
  		} else {
  			next('/login')
  		}
  	}
})
```
## SVG加载
1. 解析SVG文件
   ```ts
	const compilerIcons = async () => {
		let result = ''
		const dirs = readdirSync(opt.dir)
		for (let i = 0; i < dirs.length; i++) {
			const file = dirs[i]
			if (/.svg$/.test(file)) {
				const xmlns = `xmlns="${XMLNS}"`
				const symbolId = `icon-${file.slice(0, file.indexOf('.'))}`
				if (cache[symbolId] === undefined) {
					const svgStr = readFileSync(join(opt.dir, file), 'utf-8')
					const svgWidtReslut = / width=\"(.*?)\"/.exec(svgStr)
					const svgHightReslut = / height=\"(.*?)\"/.exec(svgStr)
					const svgViewBoxReslut = / viewBox=\"(.*?)\"/.exec(svgStr)
					const viewBox =
						svgViewBoxReslut !== null
							? svgViewBoxReslut[1]
							: `0,0,${svgWidtReslut !== null ? svgWidtReslut[1] : 128},${
									svgHightReslut !== null ? svgHightReslut[1] : 128
							  }`
					const svgPath = svgStr.replace(/<svg(S*?)[^>]*>/, '').replace('</svg>', '')
					cache[symbolId] = `<symbol ${xmlns} viewBox="${viewBox}" id="${symbolId}">${svgPath}</symbol>`
				}
				result += cache[symbolId]
			}
		}
		return `${result}`
	}
   ``` 
2. 转换为Symbol
   ```ts
	const createModuleCode = async () => {
		const html = await compilerIcons()
		const code = `if (typeof window !== 'undefined') {
			function loadSvg() {
			  var body = document.body;
			  var svgDom = document.getElementById('${opt.customDomId}');
			  if(!svgDom) {
				svgDom = document.createElementNS('${XMLNS}', 'svg');
				svgDom.style.position = 'absolute';
				svgDom.style.width = '0';
				svgDom.style.height = '0';
				svgDom.id = '${opt.customDomId}';
				svgDom.setAttribute('xmlns','${XMLNS}');
				svgDom.setAttribute('xmlns:link','${XMLNS_LINK}');
			  }
			  svgDom.innerHTML =${JSON.stringify(html)};
			  body.insertBefore(svgDom, body.lastChild);
			}
			if(document.readyState === 'loading') {
			  document.addEventListener('DOMContentLoaded', loadSvg);
			} else {
			  loadSvg()
			}
		 }
		 export default {}`
		return code
	}
   ``` 
3. 通过vite插件，插入到HTML中
   ```ts
	{
		name: 'vite-svg-icons',
		async load(id) {
			if (id.endsWith(TURGER_PATH)) {
				return await createModuleCode()
			}
		},
		configureServer: ({ middlewares }) => {
			middlewares.use(async (req, res, next) => {
				const path = normalizePath(req.url!)
				if (path.endsWith(TURGER_PATH)) {
					res.setHeader('Content-Type', 'application/javascript')
					res.setHeader('Cache-Control', 'no-cache')
					const code = await createModuleCode()
					res.statusCode = 200
					res.end(code)
				} else {
					next()
				}
			})
		}
	}
   ```
## 请求封装
1. axios请求携带token
   ```ts
   service.interceptors.request.use(config => {
		const user = useUser()
		config.headers = {
			...config.headers
		}
		if (user.getToken) {
			config.headers['Authorization'] = user.getToken
		}

		return config
   })
   ``` 
2. axios返回处理类型
   ```ts
   const request = async <T = void>(config: AxiosRequestConfig) => {
		try {
			const response = await service.request<RequestResult<T>>({ method: 'GET', ...config })
			const result = response.data
			if (result.code === 401) {
				useUser().loginout()
			}
			if (result.code === 200) {
				return result.data
			}
			ElMessage.error(result.msg)
			return Promise.reject(result.msg)
		} catch (error) {
			ElMessage.error(error instanceof Error ? error.message : '网络请求失败')
			return Promise.reject(error)
		}
   }
   ``` 
## 路由拦截
1. 路由元信息设置
  ```ts
  	interface RouteMeta {
		// 路由标题
		title: string
		// 路由图标
		icon?: string
		// 是否需要权限
		noAuth?: boolean
		// 是否展示在右侧导航栏
		hidden?: boolean
	}
  ```
2. 路由拦截跳转处理  
  ```ts
	router.beforeEach(async (to, form, next) => {
		const user = useUser()
		const app = useApp()
		document.title = `${to.meta.title}`
		if (user.getToken) {
			if (to.meta.noAuth) {
				next('/')
			} else {
				if (!user.hasUserInfo) {
					await user.fetchUserInfo()
				}
				if (!to.meta.noAuth) {
					app.addTagView({ path: to.path, fullPath: to.fullPath, title: to.meta.title })
				}
				next()
			}
		} else {
			if (to.meta.noAuth) {
				next()
			} else {
				next('/login')
			}
		}
	})
  ```

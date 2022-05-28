import { defineUserConfig } from 'vuepress'
import { searchPlugin } from '@vuepress/plugin-search'
import { defaultTheme } from '@vuepress/theme-default'

export default defineUserConfig({
	lang: 'zh-CN',
	title: 'wink',
	description: 'wink系列项目文档展示',
	plugins: [
		searchPlugin({
			locales: {
				'/': {
					placeholder: '搜索'
				}
			}
		})
	],
	theme: defaultTheme({
		navbar: [
			{
				text: 'wink-cli',
				children: [
					{
						text: 'wink-cli',
						link: '/tools/cli'
					},
					{
						text: 'wink-core',
						link: '/tools/core'
					}
				]
			},
			{
				text: 'wink-render',
				link: '/render'
			},
			{
				text: 'wink-vue-admin',
				children: [
					{
						text: 'wink-api',
						link: '/vue-admin/api'
					},
					{
						text: 'wink-web',
						link: '/vue-admin/web'
					},
					{
						text: 'wink-script',
						link: '/vue-admin/script'
					}
				]
			}
		]
	})
})

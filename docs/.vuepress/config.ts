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
				text: 'wink-core',
				link: '/wink/core'
			},
			{
				text: 'wink-vue-admin',
				link: '/vue-admin'
			},
			{
				text: 'wink-render',
				link: '/render'
			}
		]
	})
})

# wink-render
> 微信小程序渲染组件，通过设置组件数据即可渲染页面信息
## 字段配置表
| **字段名**   | **参数类型** | **详细说明**                           | **默认参数** |
| ------------ | ------------ | -------------------------------------- | ------------ |
| filed        | string       | 渲染字段信息                           | -            |
| title        | string       | 字段标题                               | -            |
| isInput      | string       | 是否为输入框                           | false        |
| isTextArea   | string       | 是否为多行文本输入框                   | false        |
| value        | string       | 字段值信息                             | -            |
| placeholder  | string       | 输入框提示语言                         | -            |
| isRequired   | boolean      | 右侧展示红色<font color="red">*</font> | false        |
| leftStyle    | string       | 左侧样式                               | -            |
| contentStyle | string       | 内容样式                               | -            |
| rightStyle   | string       | 右侧侧样式                             | -            |
| type         | enum         | [查看单元格类型](index.md/#单元格类型) | line         |
| list         | array        | type为select时内容选项                 | -            |
| child        | object       | 单元格嵌套的子元素信息                 | -            |
| canEdit      | object       | type为upload时文件是否可以被编辑       | -            |
| maxCount     | object       | type为upload时最大文件上传个数         | -            |
| fileUrl      | object       | type为upload时文件链接                 | -            |

**示例代码**
```js
export const BaseRenderList = [
  {
    field: 'name',
    title: '姓名',
    isInput: true,
    value: '',
    placeholder: '请输入姓名',
    isRequired: true,
    leftStyle: 'width:84rpx;margin-right:68rpx',
    type: 'line'
  },
  {
    field: 'age',
    title: '年龄',
    isInput: true,
    isRequired: true,
    value: '',
    placeholder: '请输入年龄',
    leftStyle: 'width:84rpx;margin-right:68rpx',
    type: 'line'
  },
  {
    field: 'country',
    title: '选择国家',
    list: ['中国', '俄罗斯', '美国', '宇宙中心'],
    type: 'select',
    child: {
      field: 'country',
      title: '国家',
      value: '',
      placeholder: '请选择国家',
      type: 'line',
      contentStyle: 'width: calc(100% - 200rpx)',
      rightStyle: 'width:32rpx;margin-left:16rpx',
      child: {
        type: 'icon',
        name: 'arrow',
        size: 16
      }
    }
  },
  {
    field: 'note',
    title: '备注',
    isTextArea: true,
    value: '',
    lineStyle: '',
    placeholder: '请输入备注',
    type: 'line'
  }
]

export const UploadRenderList = [
  {
    field: 'photo',
    title: '照片',
    type: 'upload',
    fileUrl: '',
    leftStyle: 'width:84rpx;margin-right:68rpx',
    isRequired: true,
    canEdit: true,
    maxCount: 1
  },
  {
    field: 'idNumber',
    title: '证件信息',
    type: 'upload',
    fileUrl: '',
    leftStyle: 'width:84rpx;margin-right:68rpx',
    isRequired: true,
    canEdit: true,
    maxCount: 1
  }
]
```
## 案例展示
![展示效果](/images/render-show.png)

## 渲染代码
```js
import { BankRenderList, BaseRenderList, UploadRenderList } from './data'
import { renderUtil } from '../../utils/renderUtil'

Page({
	data: {
		baseRenderInfo: [],
		uploadRenderInfo: []
	},

	async onLoad() {
		const baseRenderInfo = this.formatRender(BaseRenderList)
		const uploadRenderInfo = this.formatRender(UploadRenderList)
		this.setData({
			baseRenderInfo,
			uploadRenderInfo
		})
	},
	/**
	 * 获取字段值信息
	 **/
	setDataValue(event) {
		const { field, val } = event.detail
		console.log(`field=${field},val=${val}`)
	},
	/**
	 * 遍历节点给节点
	 * value字段赋值
	 * style字段设置样式覆盖
	 **/
	formatRender(renderAsts) {
		const resultList = []
		for (const renderAst of renderAsts) {
			resultList.push(renderUtil({ renderAst, valueMap: {} }))
		}
		return resultList
	}
})
```
```html
<view class="list-container">
	<h-card title="输入信息渲染" card-class="card-class" header-class="header-class">
		<view slot="content">
			<h-render bind:render="setDataValue" wx:for="{{baseRenderInfo}}" wx:key="field"
						renderInfo="{{item}}"></h-render>
		</view>
	</h-card>
	<h-card title="上传信息渲染" card-class="card-class" header-class="header-class" needFold>
		<view slot="content">
			<h-render bind:render="setDataValue" wx:for="{{uploadRenderInfo}}" wx:key="field"
						renderInfo="{{item}}"></h-render>
		</view>
	</h-card>
</view>
```


## 单元格类型
| **类型名** | **作用**        |
| ---------- | --------------- |
| line       | 输入框          |
| select     | 选择器          |
| upload     | 文件上传        |
| view       | 展示元素        |
| icon       | vant-ui图标展示 |

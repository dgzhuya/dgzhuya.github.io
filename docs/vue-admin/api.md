# wink-admin-api
> 是一个nestjs开发的后台管理系统
## 数据库
1. 数据库使用SQLite，主目录下使用admin.db文件作为数据库文件
   ```ts
   TypeOrmModule.forRoot({
			type: 'sqlite',
			database: 'admin.db',
			autoLoadEntities: true,
			synchronize: true
   })
   ```
2. 包含默认数据的数据库文件，点击[下载](/admin.db)
## ORM设置
使用TypeORM作为数据查询工具
## 请求参数
1. 请求参数拦截，创建ValidationPipe管道拦截请求信息
   
   **示例代码**
   ```ts
	@Injectable()
	export class ValidationPipe implements PipeTransform {
		async transform(value: any, { metatype }: ArgumentMetadata) {
			if (!metatype || ValidationPipe.toValidate(metatype)) {
				return value
			}
			const object = plainToInstance(metatype, value)
			const [error] = await validate(object)
			if (error !== undefined) {
				throw new BadRequestException(ValidationPipe.getErrorMessage(error))
			}
			return value
		}

		private static getErrorMessage(error: ValidationError): string {
			return error.constraints[Object.keys(error.constraints).pop()]
		}

		private static toValidate(metatype: Type): boolean {
			const types: Type[] = [String, Boolean, Number, Array, Object]
			return types.includes(metatype)
		}
	}
   ```
2. 请求参数校验，配置DTO的参数验证条件，使用class-transformer作为参数校验工具
   
   **示例代码(PageDto为例)**
   ```ts
	export class PageDto {
		@IsNotEmpty({ message: '页数不能为空' })
		@Matches(/^(\d*)$/, { message: '页码不是数字' })
		readonly page?: string

		@IsNotEmpty({ message: '查询数量不能为空' })
		@Matches(/^(\d*)$/, { message: '条目数不是数字' })
		readonly count?: string

		@IsOptional()
		@MaxLength(100, { message: '搜索关键字太长' })
		readonly search?: string

		static setSkipTake(pageDto: PageDto) {
			const take = pageDto.count ? +pageDto.count : 5
			const skip = pageDto.page ? (+pageDto.page - 1) * take : 0
			return {
				take,
				skip
			}
		}
	}
   ```
3. 错误信息返回，参数验证错误后，抛出BadRequestException异常，通过全局错误拦截返回错误信息
## 返回数据
创建TransformInterceptor作为请求结果返回工具
**示例代码**
```ts
@Injectable()
export class TransformInterceptor implements NestInterceptor {
	intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
		return next.handle().pipe(
			map(data => ({
				code: 200,
				data,
				msg: ''
			}))
		)
	}
}
```
## 错误拦截
1. HTTP异常拦截
   
   **示例代码**
   ```ts
	@Catch(HttpException)
	export class HttpExceptionFilter implements ExceptionFilter {
		catch(exception: HttpException, host: ArgumentsHost) {
			const ctx = host.switchToHttp()
			const response = ctx.getResponse<Response>()
			const status = exception.getStatus()
			response.json({
				code: status,
				msg: exception.message
			})
		}
	}
   ```
2. 其他异常拦截
   
   **示例代码**
   ```ts
	@Catch()
	export class ServerExceptionFilter implements ExceptionFilter {
		catch(exception: any, host: ArgumentsHost) {
			const ctx = host.switchToHttp()
			const response = ctx.getResponse<Response>()
			const request = ctx.getRequest()

			response.json({
				code: 9999,
				path: request.path,
				msg: '服务器错误'
			})
		}
	}
   ```
## 权限设置
通过解析请求接口携带的HTTP请求头中包含的token解析出token信息完成权限处理
**示例代码**
```ts
@Injectable()
export class AuthGuard implements CanActivate {
	async canActivate(context: ExecutionContext): Promise<boolean> {
		if (Reflect.getMetadata(NO_AUTH_TOKEN, context.getHandler())) return true

		const { headers, query } = context.switchToHttp().getRequest<Request>()
		if (!headers.authorization) {
			throw new BadParamsException('40008')
		}
		try {
			const payload = (await this.verifyToken(headers.authorization)) as { uid: string; rid: string }
			query[TOKEN_USER_ID] = payload.uid
			query[TOKEN_ROLE_ID] = payload.rid
			if (Reflect.getMetadata(NO_AUTH_API, context.getHandler())) return true
		} catch (e) {
			logger.error(e)
			throw new BadParamsException('401')
		}
		return true
	}

	private async verifyToken(token: string) {
		return new Promise((resolve, reject) => {
			verify(token, JwtSalt, (err, payload) => {
				if (err) {
					reject(err)
				} else {
					resolve(payload)
				}
			})
		})
	}
}
```
## 日志处理
1. 设置log4js
   
   **示例代码**
   ```ts
	log4js.configure({
		appenders: {
			cheese: {
				type: 'dateFile',
				filename: 'logs/application.log',
				encoding: 'utf-8',
				layout: {
					type: 'pattern',
					pattern: '{"date":"%d{yyyy/MM/dd-hh.mm.ss}","level":"%p","host":"%h","data":\'%m\'}'
				},
				pattern: 'yyyy-MM-dd',
				keepFileExt: true,
				alwaysIncludePattern: true
			}
		},
		categories: {
			default: {
				appenders: ['cheese'],
				level: 'debug'
			}
		},
		pm2: true
	})
   ```
2. 创建log中间件
   
   **示例代码**
   ```ts
	@Injectable()
	export class LoggerMiddleware implements NestMiddleware {
		use(req: Request, res: Response, next: () => void) {
			const { path, method, body, params, ip } = req
			const bodyStr = Object.keys(body).length > 0 ? ',body=' + JSON.stringify(body) : ''
			const paramsStr = Object.keys(params).length > 0 ? ',params=' + JSON.stringify(params) : ''
			logger.info(`ip=${ip},path=${path},method=${method}${bodyStr}${paramsStr}`)
			next()
		}
	}
   ```

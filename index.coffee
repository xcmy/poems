koa = require("koa")
app = new koa()
Router = require("koa-router")
bodyParser = require("koa-bodyparser")
global.Config = require('./config')

#koa-body-parser初始化
app.use bodyParser()

app.use (ctx,next)->
  await next()

#创建一个路由
router = new Router prefix:'/api'

#子路由
user = require("./apis/index")
#装载子路由
router.use user.routes(),user.allowedMethods()

#加载路由中间件
app.use router.routes()







file = require('./resource/authors.song')
console.log(file.length)
file1 = require('./resource/authors.tang')
console.log(file1.length)

require("./lib")

app.listen 3000,(err)->
  console.log("server start #{err or "success"}")

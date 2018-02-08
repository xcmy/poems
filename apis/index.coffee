router = require("koa-router")({prefix:""})
validator = require("validator")
db = require("../lib").db


router.get "/",(ctx)->
  ctx.body = "hhh"

module.exports = router

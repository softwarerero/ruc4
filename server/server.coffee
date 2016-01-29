express = require('express')
app = express()
serveStatic = require('serve-static')

apiRouter = express.Router()

#TODO:
# 1. encrypt response
# 2. client auth
# 3. SSL

#apiRouter.use (req, res, next) ->
#  console.log JSON.stringify req.params
#  log "requested #{req.params.query} from #{req.ip}"
#  next()

apiRouter.get '/ruc/:query', (req, res) ->
  log "requested #{req.params.query} from #{req.ip}"
  search(res, sanitizeQuery req.params.query)

app.use '/api', apiRouter
distDir = __dirname + '/../dist'
app.use serveStatic distDir

app.listen 3000

sanitizeQuery = (query) ->
  unless query.indexOf(' ') > 0
    if query.lastIndexOf('-') > 0
      query = query.substring 0, query.lastIndexOf('-')
    query += '*'
  log 'sanitizeQuery: ' + query
  query

search = (res, query) ->
  elClient = require './elClient'
  elClient.search {index: 'ruc', q: query}, (error, response) ->
    if error then return log 'error: ' + error
    ret =
      took: response.took
      total: response.hits.total
      hits: h._source for h in response.hits.hits
    console.log 'ret: ' + JSON.stringify ret
    res.send ret

log = (l) -> console.log l

#path = require('path')
#send = require 'koa-send'
#router = require('koa-router')()
#koa = require 'koa'
#app = koa()
#
#elClient = new elasticsearch.Client
#  log: 'error'
#  keepAlive: true
#
#router.get '/api/what', (next) ->
#  genify = require('thunkify-wrap').genify
#  search = genify(elClient.search)
#  res = yield search {index: 'my-index', q: 'what'}
#  this.body = {answer: "you send #{res}"}
#app.use(router.routes())
#
#distDir = __dirname + '/../client/dist'
#app.use (next) ->
#  yield send(this, this.path, {root: distDir})
#
#app.listen 3000


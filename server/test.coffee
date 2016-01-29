elastic = require('elasticsearch').Client()

go = ->
  console.log 'go'
  genify = require('thunkify-wrap').genify
  console.log 1
  search = genify(elastic.search)
  console.log 2
  res = yield search {index: 'ruc', q: 'what'}
  console.log 3
  console.log 'res: ' + res

console.log go().next()
console.log go().next()
console.log go().next()
console.log go().next()

# server here
path     = require('path')
http = require 'http'
#https = require 'https'
send = require 'koa-send'
router = require('koa-router')()
koa = require 'koa'
app = koa()

app.name = 'ruc4'

# set response-time header
app.use (next) ->
  start = new Date
  yield next
  ms = new Date - start
  this.set('X-Response-Time', ms + 'ms')

# logger
app.use (next) ->
  start = new Date
  yield next
  ms = new Date - start
  console.log('%s %s - %s', this.method, this.url, ms)

# response
#app.use (next) ->
#  yield next
#  this.body = 'Hello World'

#koa_elasticsearch = require './koa-elasticsearch'

#app.use(koa_elasticsearch())
elClient = require './elClient'
router.get '/api/ruc/:query', (next) ->
#  console.log(JSON.stringify this.request.body)
  console.log 'params: ' + JSON.stringify this.params
  #  yield next
  #  JSON.stringify search this, @params.i
  #  this.body = yield this.mongo.db('test').collection('users').findOne();
  #  console.log 'client: ' + this.elasticsearch.client
  query = @params.query
  #  this.body = yield this.elasticsearch.client.search {index: 'ruc', q: query}
  #  thunkify = require('thunkify')
  #  search = thunkify(elClient.search)
  #  thunkify = require('thunkify-wrap')
  genify = require('thunkify-wrap').genify
  search = genify(elClient.search)
  res = search {index: 'ruc', q: query}
  console.log 'res: ' + yield res
  this.body = {answer: "you send #{query}"}

app.use(router.routes())

distDir = __dirname + '/../client/dist'
app.use (next) ->
  yield send(this, this.path, {root: distDir})

app.listen 3000


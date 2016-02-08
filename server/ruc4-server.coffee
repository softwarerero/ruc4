express = require('express')
app = express()
serveStatic = require 'serve-static'
compression = require 'compression'
browserPlatform = require 'browser-platform'
Log = require '../lib/Log'

apiRouter = express.Router()
app.use(compression())
app.engine('html', require('ejs').renderFile)

distDir = __dirname + '/../dist'

app.get '/explicacion|/sobre|/calcDV|dispositivos', (request, response) ->
  response.render "#{distDir}/index.html"

apiRouter.get '/ruc/:query', (request, response) ->
  search(request, response, sanitizeQuery request.params.query)
  
app.use '/api', apiRouter
app.use serveStatic distDir

app.listen 4000

sanitizeQuery = (query) ->
  unless query.indexOf(' ') > 0
    if query.lastIndexOf('-') > 0
      query = query.substring 0, query.lastIndexOf('-')
    query += '*'
  query

search = (request, response, query) ->
  elClient = require './elClient'
  ip_addr = request.headers['x-forwarded-for'] || request.connection.remoteAddress
  platform = browserPlatform request.get 'User-Agent'
  elClient.search {index: 'ruc', q: query, defaultOperator: 'AND'}, (error, data) ->
    if error then return log 'error: ' + error
    ret =
      took: data.took
      total: data.hits.total
      hits: h._source for h in data.hits.hits
    logObj =
      q: query
      no: ret.total
      ip: ip_addr
      ms: ret.took
      ref: if 'http://ruc.sun.com.py/' isnt request.get('Referer') then request.get('Referer')
      os: platform.os + '/' + platform.osVersion 
      nav: platform.browser + '/' + platform.browserVersion
      time: Date.now()
    Log.app JSON.stringify logObj
    response.send ret

log = (l) -> console.log l


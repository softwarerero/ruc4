express = require('express')
app = express()
serveStatic = require 'serve-static'
compression = require 'compression'
Log = require '../lib/Log'

apiRouter = express.Router()
app.use(compression())
app.engine('html', require('ejs').renderFile)

distDir = __dirname + '/../dist'

app.get '/explicacion|/sobre|/calcDV', (request, response) ->
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
  log 'sanitizeQuery: ' + query
  query

search = (request, response, query) ->
  elClient = require './elClient'
  elClient.search {index: 'ruc', q: query, defaultOperator: 'AND'}, (error, data) ->
    if error then return log 'error: ' + error
    ret =
      took: data.took
      total: data.hits.total
      hits: h._source for h in data.hits.hits
    Log.app "q: #{query}, ip: #{request.ip}, total: #{ret.total}, took: #{ret.took}, referer: #{request.get('Referer')}, User-Agent: #{request.get('User-Agent')}"
    response.send ret

log = (l) -> console.log l


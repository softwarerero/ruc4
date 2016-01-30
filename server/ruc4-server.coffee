express = require('express')
app = express()
serveStatic = require('serve-static')
compression = require('compression')

apiRouter = express.Router()
app.use(compression())

#TODO:
# 0. IOS Client
# 1. Natice Client
# 2. Desktop Client


apiRouter.get '/ruc/:query', (req, res) ->
  log "requested #{req.params.query} from #{req.ip}"
  search(res, sanitizeQuery req.params.query)

app.use '/api', apiRouter
distDir = __dirname + '/../dist'
app.use serveStatic distDir

app.listen 4000

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


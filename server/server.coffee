express = require('express')
app = express()
serveStatic = require('serve-static')

apiRouter = express.Router()

#TODO:
# 1. encrypt response
# 2. client auth
# 3. SSL

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


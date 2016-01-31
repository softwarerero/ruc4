Config = require '../lib/Config'
LOG = require '../lib/Log'
Downloader = require './Downloader'

#TODO:
# 1. Check if download is necessary and only download if files on server changed.
# 2. Provide CORS headers
# 3. run this daily 

#Downloader.check()

Indexer = require './Indexer'

index = ->  
  Indexer.getStats (error, response) ->
    if error then return LOG 'stats.error', error
    oldIndex = null
    for k, v of response.indices
      if k.indexOf('ruc') is 0
        LOG 'k', k
#        LOG.j 'v', v
        oldIndex = k
    if error then return console.log error
    if oldIndex
      Indexer.oldIndex = oldIndex
    indexName = 'ruc-' + Date.now()
    Indexer.createMapping indexName, (error, response) ->
      Indexer.allIndexes 0, 9, indexName

#index()


stdCb = (error, response) ->
  if error then LOG 'error', error
  LOG.j 'response', response

#Indexer.get 'ruc', stdCb
#Indexer.deleteOldIndex 'ruc-1453917385404'
#Indexer.getStats stdCb
#Indexer.count stdCb
#Indexer.getMappings stdCb
#Indexer.getAliases stdCb

#process.exit 0 

#Indexer.getMappings (error, response) ->
#  LOG 'error', error
##  LOG.j 'response', response
#  for k, v of response
##    if k.startsWith 'ruc'
#    LOG 'k', k
#    Indexer.deleteIndex k
##    for mapping, v of v.mappings
##      LOG.j 'mapping', mapping


nextDownload = (number) -> Downloader.download number, 9, nextDownload, index
#nextDownload 0


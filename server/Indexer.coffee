Config = require '../lib/Config'
LOG = require '../lib/Log'
fs = require 'fs'
client = require './elClient'

module.exports = class Indexer
  @indexName = null
  @type = 'ruc'
  @oldIndex = null

  @getBulk: (number, index) ->
    csv = "#{Config.tmpPath}/ruc#{number}.txt"
    LOG 'csv', csv
    lines = fs.readFileSync(csv).toString().split('\n')
    line2Fields = (line) -> line.split '|'
    line2Data = (fields) ->
      ruc: fields[0]
      contribuyente: fields[1]
      dv: fields[2]
      ruc_antiguo: fields[3]
    bulk = []
    lines = (l for l in lines when (line2Fields l).length is 5)
    console.log "bulk has #{lines.length} rucs"
    for line in lines
      if line.length
        bulk.push {index: {_index: index, _type: @type}}
        bulk.push line2Data line2Fields line
    bulk

  @count: (cb) ->
    client.count {index: @indexName}, cb

  @putAliases: (name, cb) ->
    client.indices.putAliases {index: name, name: @indexName}, (error, response) ->
      cb(error, response)

  @get: (index, cb) ->
    client.indices.get {index: index, ignoreUnavailable: true}, (error, response) ->
      cb(error, response)

  @getStats: (cb) ->
    client.indices.stats {}, (error, response) ->
      cb(error, response)

  @getAliases: (cb) ->
    client.indices.getAliases {index: @indexName}, (error, response) ->
      cb(error, response)

  @getMappings: (cb) ->
    console.log 'in getmappings'
    client.indices.getMapping {index: @indexName}, (error, response) ->
      cb(error, response)

  @deleteIndex: (index) ->
    client.indices.delete {index: index}, (error, response) ->
      if error then return LOG 'deleteIndex.error', error
      
  @deleteOldIndex: (index) ->
    LOG 'deleteOldIndex', index
    client.indices.delete {index: index}, (error, response) ->
      if error then return LOG 'deleteOldIndex.error', error
      LOG.j 'response', response
    
  @createMapping: (index, cb) ->
    LOG "createMapping index: #{index}"
    body =
      mappings:
        "#{Indexer.type}":
          properties:
            ruc: {"type" : "string"}
            contribuyente: {"type" : "string"}
            dv: {"type" : "integer", "index" : "not_analyzed"}
            ruc_antiguo: {"type" : "string", "index" : "not_analyzed"}
    client.indices.create {index: index, body: body}, (error, response) ->
      if error then return LOG 'create.error', error
      cb error, response

  @allIndexes: (number, max, index) ->
    bulk = Indexer.getBulk(number, index)

    ready = -> 
      console.log 'ready'
      if number < max
        Indexer.allIndexes(number+1, max, index)
      else
        Indexer.putAlias index

    indexBulk = (start, chunkSize, index, bulk, cb) ->
      if start >= bulk.length
        return cb()
      end = Math.min start+chunkSize, bulk.length
      chunk = bulk[start...end]
      client.bulk {body: chunk}, (error, response) ->
        if error then return console.log "bulk.error: " + error
        indexBulk(start+=chunkSize, chunkSize, index, bulk, cb)

    indexBulk 0, 2000, index, bulk, ready          
    
      
  @putAlias: (index) ->
    LOG 'putAlias', index
    client.indices.putAlias {index: index, name: 'ruc'}, (error, response) ->
      if error then return LOG 'putAlias.error', error
      Indexer.deleteOldIndex Indexer.oldIndex
        
  @errorHandler = (error, response) ->
    if error
      console.log "error: " + error
#    else
#      console.log "response: " + JSON.stringify response


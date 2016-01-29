Config = require '../lib/Config'
LOG = require '../lib/Log'
fs = require 'fs'
client = require './elClient'

#client = new elasticsearch.Client
#  log: 'error'
#  keepAlive: true

module.exports = class Indexer
  @indexName = null
  @type = 'ruc'
  @oldIndex = null

  @createIndex: (number, index) ->
    csv = "#{Config.tmpPath}/ruc#{number}.txt"
    LOG 'csv', csv
    lines = fs.readFileSync(csv).toString().split('\n')
    line2Fields = (line) -> line.split '|'
    line2Data = (fields) ->
      ruc: fields[0]
      contribuyente: fields[1]
      dv: fields[2]
      ruc_antiguo: fields[3]
    bulks = []
    lines = (l for l in lines when (line2Fields l).length is 5)
    for line in lines
      if line.length
        bulks.push {index: {_index: index, _type: @type}}
        bulks.push line2Data line2Fields line
    client.bulk {body: bulks}, (error, response) ->
      if error then return console.log "error: " + error
      if number is 9
        client.indices.putAlias {index: index, name: 'ruc'}, (error, response) ->
          if error then return LOG 'error', error
          Indexer.deleteOldIndex Indexer.oldIndex

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
    client.indices.delete {index: index}, (error, response) ->
      if error then return LOG 'deleteOldIndex.error', error
      LOG.j 'response', response
    
  @createMapping: (index) ->
    LOG 'index', index
    LOG 'type', @type
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
      for i in [0..9]
        Indexer.createIndex i, index

  @errorHandler = (error, response) ->
    if error
      console.log "error: " + error
#    else
#      console.log "response: " + JSON.stringify response


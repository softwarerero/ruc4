Config = require '../lib/Config'
LOG = require '../lib/Log'
fs = require 'fs'
lunr = require 'lunr'

module.exports = class MemoryIndexer
  @idx = null
  @docCount = 0
  @docs = {}

  @indexBulk: (number) ->
    csv = "#{Config.tmpPath}/ruc#{number}.txt"
    LOG 'csv', csv
    lines = fs.readFileSync(csv).toString().split('\n')
    line2Fields = (line) -> line.split '|'
    line2Doc = (fields) ->
      ruc: fields[0]
      contribuyente: fields[1]
      dv: fields[2]
    lines = (l for l in lines when (line2Fields l).length is 5)
    for line in lines
      if line.length
        @docCount += 1
        doc = line2Doc line2Fields line
        @docs[doc.ruc] = doc
#        LOG 'doc', JSON.stringify doc
        @idx.add {id: doc.ruc, name: doc.contribuyente}


  @createIndex: =>
    @idx = lunr ->
      @field 'id' # ruc
      @field 'name' # contribuyente
      @field 'dv'
    for i in [0..9]
      @indexBulk i
    console.log 'ready'
    console.log 'docCount: ' + @docCount
#    console.log @idx.search("+DANIELI +ARCE +JULIO")
    
  @search: (query) ->
    for found in @idx.search query
      @docs[found.ref]
      

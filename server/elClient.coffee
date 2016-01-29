elasticsearch = require('elasticsearch')

module.exports = new elasticsearch.Client
  log: 'error'
  keepAlive: true

  
elClient = require './elClient'

module.exports = (options) ->
  elasticsearch = (next) ->
    this.client = yield elClient
    if(!this.client) then this.throw('Fail to acquire one elasticsearch connection')
    #    debug('Acquire one connection (min: %s, max: %s, poolSize: %s)', min, max, mongoPool.getPoolSize())

    try
#      yield* next;
      yield next
    catch e
      throw e
#    finally
#      mongoPool.release(this.mongo)
#      debug('Release one connection (min: %s, max: %s, poolSize: %s)', min, max, mongoPool.getPoolSize())

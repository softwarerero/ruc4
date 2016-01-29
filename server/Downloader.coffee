Config = require '../lib/Config'
LOG = require '../lib/Log'
fs = require 'fs'
http = require 'http'
unzip = require 'unzip'

module.exports = class Downloader

  @params =
    hostname: 'www.set.gov.py'
    headers:
      'Host': "www.set.gov.py"
      'User-Agent': "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:43.0) Gecko/20100101 Firefox/43.0"
      'Accept': "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
      'Accept-Encoding': "gzip, deflate"
      'DNT': "1"
      'Referer': "http://www.set.gov.py/portal/PARAGUAY-SET/search?q=ruc&types=all"
      'Cookie': "bbbbbbbbbbbbbbb=HCKNOHKEMLENOFDMEHCBLCKJAOBFJDODPJJKDMFEBGKDBNKAPLEDEPMNIOJAHCLCLMJJMBMKMIPCJOIDENDOPKAPJEGOFAHFOCEAOPCKCELFELHKACAAIOILMKMLEJJD; JSESSIONID=JTIheaqpZeby1ZWEnKIAhrv+.Exo0; TS019ae9d3=01d6c8dc57ba2b05ae6411b4460c9edde7af5d5071a5a7b62f85d66560f5c9de5b33bd5f34834c7b41ed57a7f696861ac5e54360944138ea3ca0095ae8d1d0b41f089d068f; TS019fe1a6=01d6c8dc57b0effda004006017130151458ef4744fe5f5588636679f3c515dac6acaab0e66d9bbcdd4c1a875b24eb6fa4a2fbaf0e4; bbbbbbbbbbbbbbb=KAAKMKIEIMMBHOODHMJFCHLPDCBKCBHFCMGMEEOPEEIDMNEIHBBHHFOHHNEADPLHGIINIGBKAMJKONJEGNDPANFFNIFPCONFBAMPDGJGGFDFMDEEFLLHFOPDOOHBOLFE"
      'Connection': "keep-alive"

  @addPath = (params, number) ->
    params.path = "/portal/rest/jcr/repository/collaboration/sites/PARAGUAY-SET/documents/informes-periodicos/ruc/ruc#{number}.zip"
      
  @download: (number, max, cb, cbFinal) ->
    LOG 'download', number
    execCallback = -> if number < max then cb number+1, max, cb else cbFinal()
#    return execCallback()
    console.log @addPath @params, number
    request = http.get @params, (response) =>
      unzipExtractor = unzip.Extract {path: Config.tmpPath}
      unzipExtractor.on 'close', execCallback
      response.pipe unzipExtractor
    request.on 'error', (err) ->
      console.log 'error: ' + err
      throw new Error err

  #TODO: 
  # 1. Check if content-length has changed and only update the index if that is the case
  # 1.1 This is based on the assumption that the file size changes when SET updates the RUC files
  # 1.2 Store the last content-length in a file or in elastic and compare
  # 1.3 Decide if it is enough to do it for ruc0 or for all files
  @check: ->
    console.log @addPath @params, 0
    request = http.get @params, (response) =>
      LOG.j 'response', response.headers['content-length']
#      unzipExtractor = unzip.Extract {path: Config.tmpPath}
#      unzipExtractor.on 'close', execCallback
#      response.pipe unzipExtractor

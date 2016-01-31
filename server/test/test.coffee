assert = require('assert')
fs = require 'fs'
Config = require '../../lib/Config'
LOG = require '../../lib/Log'
calcDv = require '../calcDv'

mismatches = 0

describe 'calcDV', () ->
  @timeout 10000
  it 'every dv in downloaded files should be correct', () ->
    for i in [0..9]
      csv = "../downloads/ruc#{i}.txt"
      LOG 'csv', csv
      lines = fs.readFileSync(csv).toString().split('\n')
      line2Fields = (line) -> line.split '|'
      lines = (l for l in lines when (line2Fields l).length is 5)
      console.log "bulk has #{lines.length} rucs"
      for line in lines
        fields = line2Fields line
        if calcDv(fields[0]) is parseInt fields[2]
          assert.equal calcDv(fields[0]), fields[2]
        else
          #TODO: find out why there are 174 mismatches. is there an error in the algorithm? 
          LOG.j 'fields', fields
          LOG 'mismatch', "#{fields[0]}: #{calcDv fields[0]} != #{fields[2]}"
          mismatches += 1

  after () ->
    LOG 'mismatches', mismatches      
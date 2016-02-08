module.exports = (name, data) -> console.log name + ': ' + data
module.exports.j = (name, data) -> console.log name + ': ' + JSON.stringify data

fs = require('fs')
console.log 'dir: ' + "#{__dirname}/../logs/app.log"
app = fs.createWriteStream "#{__dirname}/../logs/app.log", {flags: 'a'}
err = fs.createWriteStream "#{__dirname}/../logs/err.log", {flags: 'a'}

module.exports.app = (data) -> app.write data + '\n'
module.exports.err = (data) -> err.write data + '\n'

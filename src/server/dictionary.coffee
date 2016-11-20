fs = require 'fs'

dictionary = {}
files = fs.readdirSync 'dictionary'
files.forEach (file) ->
  dictionary[file] = undefined
  data = fs.readFileSync "dictionary/#{file}", "ascii"
  dictionary[file] = data.split("\n").filter (x) -> x isnt ""

module.exports = dictionary
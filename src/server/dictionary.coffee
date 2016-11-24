fs = require 'fs'

dictionary = []
files = fs.readdirSync 'dictionary'
files.forEach (category) ->
  data = fs.readFileSync "dictionary/#{category}", "ascii"
  words = data.toUpperCase().split("\n").filter (x) -> x.length >= 3
  dictionary.push { category, words }

module.exports = dictionary
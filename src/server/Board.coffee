_ = require 'lodash'
dictionary = require './dictionary'

class Board
  constructor: (@_ordo = 15, @_timeLimit = 2, @_maxloop = 5000) ->
    @_availableWords = []
    @_currentWords = []
    @_category = null
    @_grid = null
    @_ready = false

  setOrdo: (ordo) ->
    @_ordo = ordo

  getOrdo: -> @_ordo

  getCategory: -> @_category

  getAvailableWords: -> @_availableWords

  getGrid: -> @_grid

  isReady: -> @_ready

  generate: ->
    @_ready = false
    randomIndex = _.random dictionary.length - 1
    { category, words } = dictionary[randomIndex]
    @_category = category
    @_availableWords = words

    timeLimit = @_timeLimit * 1000 + new Date().getTime()
    tes = true
    while tes
    # while new Date().getTime() < timeLimit
      currentWords = []
      grid = new Grid(@_ordo)

      shuffledWords = _.shuffle @getAvailableWords()
      for word in shuffledWords
        rp = score: -1 # random position
        for i in [0..1] # [0..@_timeLimit]
          col = _.random(0, @_ordo - 1)
          row = _.random(0, @_ordo - 1)
          vertical = if _.random(0, 1) is 1 then true else false
          score = grid.checkFitScore col, row, vertical, word
          if score > rp.score
            rp = { col, row, vertical, score }
        if rp.score >= 0
          grid.fit rp.col, rp.row, rp.vertical, word

      tes = false
    console.log grid.toString()
    @_ready = true

class Coordinate
  constructor: (@x, @y, @vertical, @length) ->

class Grid
  constructor: (@_ordo = 15, @_emptyChar = '-') ->
    @_grid = null
    @_currentWords = []
    @emptyGrid()

  getOrdo: -> @_ordo

  getGrid: -> @_grid

  getCell: (col, row) -> @_grid[col][row]

  # fill the grid with predefined empty char
  emptyGrid: ->
    @_grid = []
    for i in [0..@_ordo]
      row = []
      for j in [0..@_ordo]
        row.push @_emptyChar
      @_grid.push row

  checkFitScore: (col, row, vertical, word) ->
    score = 0
    try
      for letter, i in word
        c = @getCell(col, row)
        if c is letter
          score += 1
        else if c isnt @_emptyChar
          return -1
        if vertical then col++
        else row++
    catch err
      return -1
    score

  fit: (col, row, vertical, word) ->
    for letter in word
      @_grid[col][row] = letter
      if vertical then col++
      else row++

  toString: ->
    ans = "\n"
    ans += r.join(' ') + "\n" for r in @_grid
    ans

module.exports = Board

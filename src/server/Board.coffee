_ = require 'lodash'
dictionary = require './dictionary'

class Board
  constructor: (@_ordo = 15, @_gridLoop = 64, @_wordLoop = 4) ->
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

    maxScore = 0
    for i in [1..@_gridLoop]
      currentWords = []
      grid = new Grid(@_ordo)

      shuffledWords = _.shuffle @getAvailableWords()
      currentScore = 0
      for word in shuffledWords
        rp = score: -1 # random position
        for i in [0..@_wordLoop]
          col = _.random(0, @_ordo - 1)
          row = _.random(0, @_ordo - 1)
          vertical = if _.random(0, 1) is 1 then true else false
          score = grid.checkFitScore col, row, vertical, word
          if score > rp.score
            rp = { col, row, vertical, score }
        if rp.score >= 0
          currentScore += rp.score
          grid.fit rp.col, rp.row, rp.vertical, word
      if currentScore > maxScore
        maxScore = currentScore
        @_grid = grid

    grid.fillEmptiness()
    @_grid = grid
    @_ready = true

# grid is a square matrix contains letter
class Grid
  constructor: (@_ordo = 15, @_emptyChar = ' ') ->
    @_grid = []
    @_currentWords = []
    @emptyGrid()

  getOrdo: -> @_ordo

  getGrid: -> @_grid

  cell: (col, row, letter) ->
    if letter?
      @_grid[col][row] = letter
    else
      @_grid[col][row]

  # fill the grid with predefined empty char
  emptyGrid: ->
    for i in [0..@_ordo]
      row = []
      for j in [0..@_ordo]
        row.push @_emptyChar
      @_grid.push row
    true

  # fill the empty with random letter
  fillEmptiness: ->
    for i in [0..@_ordo]
      for j in [0..@_ordo]
        if @cell(i, j) is @_emptyChar
          @cell(i, j, 'X')
    true

  checkFitScore: (col, row, vertical, word) ->
    score = 0
    try
      for letter, i in word
        c = @cell(col, row)
        if c is letter
          score++
        else if c isnt @_emptyChar
          return -1
        if vertical then col++
        else row++
    catch err
      return -1
    score

  fit: (col, row, vertical, word) ->
    for letter in word
      @cell(col, row, letter)
      if vertical then col++
      else row++
    true

  toString: ->
    ans = ""
    ans += r.join(' ') + "\n" for r in @_grid
    ans

module.exports = Board

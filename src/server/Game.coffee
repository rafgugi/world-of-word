Board = require './Board'

class Game
  constructor: (@io) ->
    @board = new Board()
    @answers = {}
    @maxTimer = 25
    @currTimer = 0
    @answered = []
    @io.on 'connection', @client
    @clients = {}
    setInterval @_gameTimer, 1000

  # keep an eye to each client
  client: (sock) =>
    console.log "a user ##{sock.id} is connected on #{@currTimer}"
    @clients[sock.id] = name: '', score: 0

    sock.on 'name', (name) =>
      @clients[sock.id].name = name
      @io.emit 'clients', @clients

    # special for new client joined
    if @board.isReady()
      sock.emit 'game', @gameBroadcast()
      sock.emit 'answered', @answered
      sock.emit 'timer', @currTimer

    # when client answer something
    sock.on 'chat', (message) =>
      @io.emit 'chat', id: sock.id, chat: message
      word = @guess message
      if word
        word.winner = sock.id
        @answered.push word
        @clients[sock.id].score += message.length
        @io.emit 'chat', chat: "#{@clients[sock.id].name} berhasil menjawab dengan benar."
        @io.emit 'clients', @clients
        @io.emit 'answered', @answered

    sock.on 'disconnect', =>
      delete @clients[sock.id]

  # client guess the word. return the word object if word is
  # in the answer list and hasnt been answered yet
  guess: (message) ->
    if word = @answers[message.toUpperCase()] isnt undefined
      if word.winner is undefined
        return word
    false

  # get board value easily
  gameBroadcast: ->
    board: @board.getGrid(), category: @board.getCategory()

  # handle game timer, called by setInterval on constructor
  _gameTimer: =>
    if @currTimer is 0
      @currTimer = @maxTimer
      @answered = []
      @board.generate()
      @io.emit 'game', @gameBroadcast()
      @io.emit 'answered', @answered
      @answers = @board.getWords()
    @io.emit 'timer', @currTimer
    @currTimer--

module.exports = Game
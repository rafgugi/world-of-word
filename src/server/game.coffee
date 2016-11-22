express = require('express')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http);
path = require('path')

{ PORT, PATHS } = require './config'
dictionary = require './dictionary'
Board = require './Board'

board = new Board()

# use static for front end
app.get '/', (req, res) ->
  res.sendFile path.join __dirname, '../client/index.html'
app.use express.static PATHS.dist.client

# 

io.on 'connection', (socket) ->
  console.log 'a user connected'
  board.generate()

http.listen PORT, ->
  console.log "listening on #{PORT}"
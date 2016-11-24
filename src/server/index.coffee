express = require('express')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http);
path = require('path')

{ PORT, PATHS } = require './config'
Game = require './Game'

# use static for front end
app.get '/', (req, res) ->
  res.sendFile path.join __dirname, '../client/index.html'
app.use express.static PATHS.dist.client

game = new Game(io)

http.listen PORT, ->
  console.log "listening on #{PORT}"
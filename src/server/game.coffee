express = require('express')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http);
path = require('path')
{ COMPATIBILITY, PORT, UNCSS_OPTIONS, PATHS } = require('./config')

app.get '/', (req, res) ->
  res.sendFile path.join __dirname, '../client/index.html'

app.use express.static PATHS.dist.client

io.on 'connection', (socket) ->
  console.log('a user connected');

http.listen PORT, ->
  console.log "listening on #{PORT}"
React = require 'react'
dom = React.createElement
Grid = require './Grid'
TextInput = require './TextInput'
ChatWindow = require './ChatWindow'

GameComponent = React.createClass
  displayName: 'GameComponent'

  getInitialState: ->
    category: ''
    timer: 0
    board: []
    clients: {}
    chats: []

  componentWillMount: ->
    @socket = io()

    @socket.on 'game', ({category, board}) =>
      @setState { board, category }

    @socket.on 'timer', (timer) =>
      @setState { timer }

    @socket.on 'clients', (clients) =>
      @setState { clients }

    @socket.on 'chat', ({id, chat}) =>
      if id?
        @state.chats.push { user: @state.clients[id], chat }
      else
        @state.chats.push { chat }
      @setState {}

  componentDidMount: ->
    @socket.emit 'name', 'Gugik'

  handleSubmitText: (chat) ->
    @socket.emit 'chat', chat

  render: ->
    dom 'div', className: 'row',
      dom 'div', className: 'large-8 medium-8 columns',
        dom 'p', {}, @state.category + " (#{@state.timer})"
        dom Grid, board: @state.board
      dom 'div', className: 'large-4 medium-4 columns',
        dom ChatWindow, chats: @state.chats
      dom 'div', className: 'large-12 columns',
        dom 'br'
        dom TextInput, onSubmit: @handleSubmitText

module.exports = GameComponent
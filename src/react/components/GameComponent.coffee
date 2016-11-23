React = require 'react'
dom = React.createElement
Grid = require './Grid'
TextInput = require './TextInput'
ChatWindow = require './ChatWindow'

GameComponent = React.createClass
  displayName: 'GameComponent'

  getDefaultProps: -> {}

  getInitialState: -> {}

  componentDidMount: ->
    socket = io()

  render: ->
    dom 'div', className: 'row',
      dom 'div', className: 'large-8 medium-8 columns',
        dom Grid, ordo: 20, letter: 'Z'
      dom 'div', className: 'large-4 medium-4 columns',
        dom ChatWindow, row: 10
      dom 'div', className: 'large-12 columns',
        dom 'br'
        dom TextInput

module.exports = GameComponent
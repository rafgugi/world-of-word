React = require 'react'
dom = React.createElement

Grid = React.createClass
  displayName: 'Grid'

  getDefaultProps: -> 
    board: []

  getInitialState: -> {}

  componentDidMount: -> {}

  render: ->
    dom 'div', className: 'words container float-center',
      for row, i in @props.board
        dom 'div', key: i, className: 'words row',
          for cell, j in row
            dom 'div', key: j, className: 'words cell',
              dom 'span', {}, cell

module.exports = Grid
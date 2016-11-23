React = require 'react'
dom = React.createElement

Grid = React.createClass
  displayName: 'Grid'

  getDefaultProps: -> 
    ordo: 20
    letter: 'X'

  getInitialState: -> {}

  componentDidMount: -> {}

  render: ->
    dom 'div', className: 'words container float-center',
      for i in [1..@props.ordo]
        dom 'div', key: i, className: 'words row',
          for j in [1..@props.ordo]
            dom 'div', key: j, className: 'words cell',
              dom 'span', {}, @props.letter

module.exports = Grid
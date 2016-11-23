React = require 'react'
dom = React.createElement

ChatWindow = React.createClass
  displayName: 'ChatWindow'

  getDefaultProps: ->
    row: 10

  getInitialState: -> {}

  componentDidMount: -> {}

  render: ->
    dom 'div', className: 'large-4 medium-4 columns',
      dom 'textarea', rows: @props.row

module.exports = ChatWindow
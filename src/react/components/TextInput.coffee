React = require 'react'
dom = React.createElement

TextInput = React.createClass
  displayName: 'TextInput'

  getDefaultProps: -> {}

  getInitialState: -> {}

  componentDidMount: -> {}

  render: ->
    dom 'div', className: 'input-group',
      dom 'input', type: 'text', className: 'input-group-field'
      dom 'div', className: 'input-group-button',
        dom 'button', className: 'button', 'Send'

module.exports = TextInput
React = require 'react'
dom = React.createElement

TextInput = React.createClass
  displayName: 'TextInput'

  getDefaultProps: ->
    another: 'test'
    onSubmit: -> {}

  handleSubmit: ->
    @props.onSubmit @refs.input.value
    @refs.input.value = ''

  render: ->
    dom 'div', className: 'input-group',
      dom 'input',
        type: 'text'
        className: 'input-group-field'
        ref: 'input'
      dom 'div', className: 'input-group-button',
        dom 'button', className: 'button', onClick: @handleSubmit, 'Send'

module.exports = TextInput
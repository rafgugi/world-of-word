React = require 'react'
dom = React.createElement

GameComponent = React.createClass
  displayName: 'GameComponent'

  getDefaultProps: -> {}

  getInitialState: -> {}

  render: ->
    dom 'div', className: 'row',
      dom 'div', className: 'large-8 medium-8 columns',
        dom 'div', className: 'words container float-center',
          for i in [1..20]
            dom 'div', key: i, className: 'words row',
              for j in [1..20]
                dom 'div', key: j, className: 'words cell',
                  dom 'span', {}, 'A'
      dom 'div', className: 'large-4 medium-4 columns',
        dom 'textarea', rows: 10
      dom 'div', className: 'large-12 columns',
        dom 'br'
        dom 'div', className: 'input-group',
          dom 'input', type: 'text', className: 'input-group-field'
          dom 'div', className: 'input-group-button',
            dom 'button', className: 'button', 'Send'

module.exports = GameComponent
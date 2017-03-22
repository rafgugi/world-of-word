React = require 'react'
dom = React.createElement

ChatWindow = React.createClass
  displayName: 'ChatWindow'

  getDefaultProps: ->
    chats: []

  getInitialState: -> {}

  componentDidMount: -> {}

  render: ->
    dom 'ul', {},
      for chat, i in @props.chats
        dom 'li', key: i,
          if chat.user?
            chat.user.name + ": " + chat.chat
          else
            dom 'span', className: '', chat.chat

module.exports = ChatWindow
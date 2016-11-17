React = require 'react'
dom = React.createElement
ReactDOM = require 'react-dom'
GameComponent = require './components/GameComponent'

ReactDOM.render(
  dom 'div', {},
    dom 'hr'
    dom GameComponent
    dom 'hr'

  document.getElementById 'ng-view'
)
React = require 'react'
dom = React.createElement
ReactDOM = require 'react-dom'

ReactDOM.render(
  dom "div", {},
    dom "hr"
    dom "div", className: "column row",
      dom "div", className: "large-14 medium-14 columns",
        dom "div", className: "words container float-center",
          for i in [1..20]
            dom "div", key: i, className: "words row",
              for j in [1..20]
                dom "div", key: j, className: "words cell",
                  dom "span", {}, 'A'
      dom "div", className: "large-6 medium-6 columns",
        dom 'textarea', rows: 10

  document.getElementById "ng-view"
)
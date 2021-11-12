module GUI1 where

import Prelude

import React.Basic.DOM as R
import React.Basic.Events as Events
import React.Basic.Hooks (Component, (/\))
import React.Basic.Hooks as React

make :: Component Unit
make =
  React.component "GUI1" \_ -> React.do
    counter /\ setCounter <- React.useState 0
    pure
      ( R.div_
          [ R.h2_ [ R.text "Counter" ]
          , R.div_
              [ R.input
                  { readOnly: true
                  , value: show counter
                  , type: "text"
                  }
              , R.button
                  { onClick: Events.handler_ (setCounter (_ + 1))
                  , children: [ R.text "Count" ]
                  }
              ]
          ]
      )

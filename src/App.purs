module App where

import Prelude

import GUI1 as GUI1
import GUI2 as GUI2
import GUI3 as GUI3
import React.Basic.DOM as R
import React.Basic.Hooks (Component)
import React.Basic.Hooks as React

mkApp :: Component Unit
mkApp = do
  gui1 <- GUI1.make
  gui2 <- GUI2.make
  gui3 <- GUI3.make
  React.component "App" \_ -> React.do
    pure
      ( R.main_
          [ gui1 unit
          , gui2 unit
          , gui3 unit
          ]
      )
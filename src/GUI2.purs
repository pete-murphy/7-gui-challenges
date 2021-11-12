module GUI2 where

import Prelude

import Data.Foldable as Foldable
import Data.Maybe (Maybe)
import Data.Maybe as Maybe
import Data.Number as Number
import Data.Number.Format as Format
import Effect (Effect)
import React.Basic.DOM as R
import React.Basic.DOM.Events as DOM.Events
import React.Basic.Events as Events
import React.Basic.Hooks (Component, Reducer, (/\))
import React.Basic.Hooks as React

toFahrenheit :: String -> Maybe String
toFahrenheit =
  map
    ( Format.toStringWith (Format.fixed 2)
        <<< (_ + 32.0)
        <<< (_ * 9.0 / 5.0)
    ) <<< Number.fromString

toCelsius :: String -> Maybe String
toCelsius =
  map
    ( Format.toStringWith (Format.fixed 2)
        <<< (_ * 5.0 / 9.0)
        <<< (_ - 32.0)
    ) <<< Number.fromString

type State =
  { celsius :: String
  , fahrenheit :: String
  }

data Action
  = Celsius String
  | Fahrenheit String

mkReducer :: Effect (Reducer State Action)
mkReducer = React.mkReducer \state -> case _ of
  Celsius celsius ->
    { celsius
    , fahrenheit: Maybe.fromMaybe state.fahrenheit (toFahrenheit celsius)
    }
  Fahrenheit fahrenheit ->
    { fahrenheit
    , celsius: Maybe.fromMaybe state.celsius (toCelsius fahrenheit)
    }

make :: Component Unit
make = do
  reducer <- mkReducer
  React.component "GUI2" \_ -> React.do
    { celsius, fahrenheit } /\ dispatch <- React.useReducer mempty reducer
    -- React.useEffectOnce do
    --   dispatch (Celsius "0")
    --   pure mempty
    pure
      ( R.div_
          [ R.h2_ [ R.text "TempConv" ]
          , R.div_
              [ R.input
                  { value: celsius
                  , type: "text"
                  , onChange: Events.handler DOM.Events.targetValue
                      ( Foldable.traverse_ \value -> do
                          dispatch (Celsius value)
                      )
                  }
              , R.span_ [ R.text "Celsius =" ]
              , R.input
                  { value: fahrenheit
                  , type: "text"
                  , onChange: Events.handler DOM.Events.targetValue
                      ( Foldable.traverse_ \value -> do
                          dispatch (Fahrenheit value)
                      )
                  }
              , R.span_ [ R.text "Fahrenheit" ]
              ]
          ]
      )

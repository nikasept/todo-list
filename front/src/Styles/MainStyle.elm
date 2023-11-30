module Styles.MainStyle exposing (..)

import Css exposing (..)
import Css.Global exposing (global)
import Html exposing (..)
import Html.Styled exposing (..)


bigFontStyle : Style
bigFontStyle = Css.batch [ fontSize (px 32), color ( rgb 75 0 0 ) ]



roundContainerStyle : Style
roundContainerStyle = Css.batch [ margin (px 12)
    , backgroundColor (rgb 0 127 127)
    , borderStyle solid
    , borderRadius (px 32)
    , borderColor (rgb 0 75 75)
    , borderWidth (px 15) ]

blackPageBackgroundStyle : Html.Styled.Html msg
blackPageBackgroundStyle = Css.Global.global [ ( Css.Global.body [ ( backgroundColor (rgb 0 0 0)  ) ]  ) ]

redPageBackgroundStyle : Html.Styled.Html msg
redPageBackgroundStyle = Css.Global.global [ ( Css.Global.body [ ( backgroundColor (rgb 75 0 0)  ) ]  ) ]

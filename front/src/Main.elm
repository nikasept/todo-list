module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, text, div, p)

main = sandbox { init = init, view = view,  update = update }

type alias Atom = {
  id : Int,
  title : String,
  crtDate : Int,
  dueDate : Int,
  description : String }

type Msg = Static

init : Atom
init = { id =1, title = "first", crtDate = 1, dueDate = 2, description = "first todo atom" }

view : Atom -> Html Msg
view atom = 
  div [] [ 
    p [] [ 
      text atom.title 
      ],
    p [] [
      text atom.description
      ],
    p [] [
      text <| String.fromInt atom.id
    ], 
    p [] [
      text <| String.fromInt atom.crtDate
    ] 
  ]

update : Msg -> Atom -> Atom
update _ atom = atom
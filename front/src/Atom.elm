module Atom exposing (..)

import Api exposing (..)
import Html exposing (Html, div, p, text)
import Browser


main : Program () Model Signal
main = Browser.element {
    init = init,
    subscriptions = subscriptions,
    update = update,
    view = view }

type Model =
    Todo State


init : () -> (Model, Cmd Signal)
init _ = ( Todo Loading, 
    getAtomData)

update : Signal -> Model -> (Model, Cmd Signal) 
update  sig model = 
    case sig of
        Api.Finished result ->
            case result of 
                Ok atom ->
                    (Todo (Api.Success atom), Cmd.none)
                Err _ ->
                    (Todo (Api.Failed), Cmd.none)


subscriptions : Model -> Sub Signal
subscriptions model =
    Sub.none

view : Model -> Html Signal 
view model = 
    case model of
        Todo Api.Loading ->
            p [] [text "Loading"]
        Todo (Api.Success atom) ->
            p [] [text atom.title]
        Todo (Failed) -> text "Failed to fetch"
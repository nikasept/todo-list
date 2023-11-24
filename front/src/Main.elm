module Main exposing (..)

import Http
import Json.Decode
import Html exposing(Html, text, div)
import Browser
import Html.Attributes

type alias Atom = 
    { id : Int,
    title : String,
    description : String,
    createDate : String }

type alias Atoms = List Atom

type Msg = 
    Fetched (Result Http.Error Atoms)

type Model = Loading
    | Failed 
    | Success (Atoms) 
    

decodeAtom : Json.Decode.Decoder Atom
decodeAtom = Json.Decode.map4 Atom 
    (Json.Decode.field "id" Json.Decode.int)
    (Json.Decode.field "title" Json.Decode.string)
    (Json.Decode.field "description" Json.Decode.string)
    (Json.Decode.field "createDate" Json.Decode.string)

decodeAtoms : Json.Decode.Decoder Atoms
decodeAtoms = Json.Decode.list decodeAtom

getAtoms : Cmd Msg
getAtoms = Http.request 
    { method = "GET",
    url = "http://localhost:5000/atoms",
    headers = [],
    body = Http.emptyBody,
    timeout = Nothing,
    tracker = Nothing, 
    expect = Http.expectJson Fetched decodeAtoms}

init : flags -> (Model, Cmd Msg) 
init _ = (Loading, getAtoms)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        Fetched result ->
            case result of
                Ok atoms ->
                    (Success atoms, Cmd.none)
                _ ->
                    (Failed, Cmd.none)

view : Model -> Html Msg
view model =
    case model of
        Failed ->
            Html.text "failed"
        Loading ->
            Html.text "loading"
        Success atoms ->
            Html.div [] (List.map (\atom -> viewAtom atom) atoms)

viewAtom : Atom -> Html Msg
viewAtom atom = Html.div [ Html.Attributes.style "background-color" "grey"] [
    Html.h3 [] [ Html.text atom.title ],
    Html.p [] [Html.text atom.description],
    Html.p [] [Html.text atom.createDate] ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program () Model Msg
main = Browser.element {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions }
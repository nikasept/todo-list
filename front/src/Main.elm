module Main exposing (..)

import Http
import Json.Decode
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Styles.MainStyle exposing (..)
import Browser

type alias Atom = 
    { id : Int,
    title : String,
    description : String,
    createDate : String }

type alias Atoms = List Atom

type Msg = 
    Fetched (Result Http.Error Atoms)

type Model = 
      Loading
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
    url = "http://localhost:8080/atoms",
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

view : Model -> Html.Styled.Html Msg
view model = Html.Styled.div [] [ redPageBackgroundStyle, 
    case model of
        Failed ->
            Html.Styled.text "failed"
        Loading ->
            Html.Styled.text "loading"
        Success atoms ->
            Html.Styled.div [] (List.map (\atom -> viewAtom atom) atoms) ]




viewAtom : Atom -> Html.Styled.Html Msg
viewAtom atom = Html.Styled.div [ css [roundContainerStyle] ] [
    Html.Styled.h3 [] [ Html.Styled.text atom.title ],
    Html.Styled.p [css [bigFontStyle] ] [Html.Styled.text atom.description],
    Html.Styled.p [] [Html.Styled.text atom.createDate] ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program () Model Msg
main = Browser.element {
    init = init,
    view = view >> toUnstyled,
    update = update,
    subscriptions = subscriptions }

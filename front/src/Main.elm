module Main exposing (..)

import Html exposing (Html)
import Browser 
import Html.Attributes
import Html.Events
import Json.Decode
import Http 

main : Program () Model Msg
main = Browser.element {
    init =  \_ -> ({ flip = False, atom = Loading}, getAtom),
    view = view,
    update = update,
    subscriptions = (\_ -> Sub.none) }


decodeAtom : Json.Decode.Decoder Atom
decodeAtom = 
    Json.Decode.map4 Atom 
        (Json.Decode.field "crtDate" Json.Decode.int)
        (Json.Decode.field "description" Json.Decode.string)
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "title" Json.Decode.string)
        

getAtom : Cmd Msg
getAtom = Http.get {
    url = "http://localhost:5000/atom",
    expect = Http.expectJson (FetchAtom) decodeAtom}

type alias Atom = { 
    crtDate : Int, 
    description : String, 
    id : Int,
    title : String }

type GetAtom = 
    Loading
    | Failed Http.Error
    | Success Atom

type Flip = 
    On
    | Off

type alias Model = {
    flip : Bool,
    atom : GetAtom } 

type Msg = 
    TurnOn
    | TurnOff
    | FetchAtom (Result Http.Error Atom)
 

update : Msg -> Model -> (Model, Cmd Msg)
update msg mod =
    case msg of
        TurnOn ->
            ({mod | flip = True}, Cmd.none)
        TurnOff ->
            ({mod | flip = False}, Cmd.none)
        FetchAtom result ->
            case result of 
                Result.Ok res ->
                    ({mod | atom = Success res}, Cmd.none)
                Result.Err err ->
                    ({mod | atom = Failed err}, Cmd.none)


       
view : Model -> Html Msg 
view model = viewAtom model.atom 
 

viewAtom : GetAtom -> Html Msg
viewAtom atom = 
    case atom of
        Loading ->
            Html.text "Loading.."
        Failed err ->
            case err of
                Http.BadBody body -> 
                    Html.text body 
                Http.BadStatus _ ->
                    Html.text "BadStatus"
                Http.BadUrl _ ->
                    Html.text "BadUrl"
                Http.NetworkError ->
                    Html.text "Network"
                Http.Timeout ->
                    Html.text "Timeout"
        Success res ->
            Html.text res.title



footerText : String
footerText = "FOOTER"

headerText : String
headerText = "HEADER"

viewHeader : String -> Html Msg 
viewHeader custom = Html.p [ Html.Attributes.class "p"] [
     Html.text (headerText ++ custom) ]

viewFooter : String -> Html Msg 
viewFooter custom = Html.p [ Html.Attributes.class "p"] [
     Html.text (footerText ++ custom) ]
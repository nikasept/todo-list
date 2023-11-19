module Api exposing (..)

-- Retrieve book data with http
import Http

-- Decode <=> Deserialize
import Json.Decode exposing (Decoder, int, string, field, map4)


type alias Atom =
  { id : Int
  , crtDate : Int 
  , title : String
  , desription : String
  }

decodeAtom : Decoder Atom
decodeAtom = 
  map4 
    Atom 
    (field "id" int)
    (field "crtDate" int)
    (field "title" string)
    (field "description" string)


-- State <=> Model
type State = 
  Failed 
  | Loading
  | Success Atom


-- Signal <=> Message
type Signal =
  Finished (Result Http.Error Atom)



-- translates Cmd it into a signal
getAtomData : Cmd Signal 
getAtomData =  
  Http.get { url = "http://localhost:5000/atom", 
  expect = Http.expectJson Finished decodeAtom
  }

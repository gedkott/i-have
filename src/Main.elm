module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode


-- MAIN


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }


-- MODEL


type alias Model =
  { ingredients : List String
  , selectedIngredients: List String
  }


init : () -> ( Model, Cmd Msg )
init _ =
  ( { ingredients = ["eggplant", "tomato paste", "chicken drumsticks", "cherry tomatos", "saffron", "rice", "olive oil", "salt", "pepper", "allspice", "cinnamon", "turmeric"], selectedIngredients = []}
  , Cmd.none
  )


-- UPDATE


type Msg
  = IngredientSelected String


-- Use the `sendMessage` port when someone presses ENTER or clicks
-- the "Send" button. Check out index.html to see the corresponding
-- JS where this is piped into a WebSocket.
--
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    IngredientSelected ingredient ->
      ( { model | selectedIngredients =  model.selectedIngredients ++ [ingredient] }
      , Cmd.none
      )


-- VIEW

changeDecoder : Json.Decode.Decoder Msg
changeDecoder = Json.Decode.map IngredientSelected (Json.Decode.at ["target", "value"] Json.Decode.string) 

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text "I Have..." ]
    , datalist [ id "ingredients" ]
        (List.map (\ingredient -> option [] [ text ingredient ]) model.ingredients)
    , input
        [ type_ "text"
        , name "ingredient-list"
        , placeholder "eggplant..."
        , on "change" changeDecoder
        , id "ingredient-list"
        , list "ingredients" 
        ]
        []
    , ul [] (List.map (\i -> li [] [text i]) model.selectedIngredients)
    ]
# Elm Liner Bar

Small horizontal bar chart library for Elm

![sample](https://github.com/KikyTokamuro/elm-linerbar/raw/master/img/logo.png "Sample of Liner Bar")

## How to Install
```sh
elm-package install kikytokamuro/elm-linerbar
```

## Demo
```elm
module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import LinerBar
import Random


type alias Model =
    { linerBarModel : LinerBar.Model
    , seed : Int
    }


type Msg
    = Randomize
    | NewRandomValues (List Int)
    | BarUpdate LinerBar.Msg


exampleData : LinerBar.Data
exampleData =
    { title = Just "LinerBar.elm"
    , items =
        [ { name = "One", value = 30, color = "#6a329f" }
        , { name = "Two", value = 50, color = "#6a649f" }
        , { name = "Three", value = 20, color = "#6ac89f" }
        , { name = "Four", value = 40, color = "#6ac89f" }
        , { name = "Five", value = 40, color = "#6afb9f" }
        ]
    , dark = False
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { linerBarModel = LinerBar.init exampleData
      , seed = 12345
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Randomize ->
            ( model
            , Random.generate NewRandomValues (Random.list (List.length model.linerBarModel.data.items) (Random.int 10 60))
            )

        NewRandomValues newValues ->
            let
                newItems =
                    List.map2 (\item value -> { item | value = toFloat value }) model.linerBarModel.data.items newValues

                linerBarModelData =
                    model.linerBarModel.data

                linerBarModel =
                    model.linerBarModel

                newData =
                    { linerBarModelData | items = newItems }

                newLinerBarModel =
                    { linerBarModel | data = newData }
            in
            ( { model | linerBarModel = newLinerBarModel, seed = model.seed + 1 }
            , Cmd.none
            )

        BarUpdate linerBarMsg ->
            ( { model | linerBarModel = LinerBar.update linerBarMsg model.linerBarModel }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ Html.map BarUpdate (LinerBar.view model.linerBarModel)
        , div
            [ style "width" "100%"
            , style "align-items" "center"
            , style "display" "flex"
            , style "justify-content" "center"
            , style "margin-top" "20px"
            ]
            [ button [ onClick Randomize ] [ text "Randomize Data" ] ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
```

### Build demo
```sh
cd demo
elm make Main.elm --output=main.js
# And open demo/index.html in browser
```

## Documentations
Please see [Elm Package](http://package.elm-lang.org/packages/kikytokamuro/elm-linerbar/latest) for complete documentation.

## License
MIT
module LinerBar exposing (Data, Item, Model, Msg, init, update, view)

{-| This module provides a customizable linear bar chart component.

It allows you to display data as a horizontal bar chart with interactive
legend items that highlight corresponding bars.

# View

@docs view

# Data

@docs Model, Data, Item

# Messages

@docs Msg

# Initialization

@docs init

# Update

@docs update

-}

import Html exposing (Html, button, div, p, span, text)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick, onMouseEnter, onMouseLeave)
import LinerBarStyles


{-| Represents the overall state of the LinerBar component.
-}
type alias Model =
    { data : Data
    , activatedItem : Maybe String
    , hoveredItem : Maybe String
    }


{-| Represents the data used to populate the LinerBar.
-}
type alias Data =
    { title : Maybe String
    , items : List Item
    , dark : Bool
    }


{-| Represents a single item within the LinerBar data.
-}
type alias Item =
    { name : String
    , value : Float
    , color : String
    }


{-| Represents the possible messages that can be sent to update the LinerBar.
-}
type Msg
    = ActivateDeactivateItem String
    | HoverItem String
    | LeaveItem


{-| Initializes the LinerBar model with the data.

    - `data`: The initial data for the LinerBar.

    Example:

    import LinerBar

    initialModel : LinerBar.Model
    initialModel =
        LinerBar.init myData

-}
init : Data -> Model
init data =
    { data = data
    , activatedItem = Nothing
    , hoveredItem = Nothing
    }


{-| Updates the LinerBar model based on the given message.

    - `msg`: The message to process.
    - `model`: The current LinerBar model.

    The function handles the following messages:

    - `ActivateDeactivateItem id`: Toggles the active state of the item with the given ID.
    - `HoverItem id`: Sets the hovered item to the item with the given ID.
    - `LeaveItem`: Clears the hovered item.

-}
update : Msg -> Model -> Model
update msg model =
    case msg of
        ActivateDeactivateItem id ->
            if model.activatedItem == Just id then
                { model | activatedItem = Nothing }

            else
                { model | activatedItem = Just id }

        HoverItem id ->
            { model | hoveredItem = Just id }

        LeaveItem ->
            { model | hoveredItem = Nothing }


{-| Renders the LinerBar component.

  - `model`: The current LinerBar model.

This function uses the `LinerBarStyles` module to apply styles to the
different parts of the chart.

-}
view : Model -> Html Msg
view model =
    div
        (LinerBarStyles.styleList (LinerBarStyles.cardStyles model.data.dark))
        [ renderBarCard model ]


{-| Renders a single line (bar) in the LinerBar.

    - `totalValues`: The sum of all values in the data.
    - `model`: The current LinerBar model.
    - `index`: The index of the item being rendered.
    - `item`: The data for the item being rendered.

    This function calculates the width of the bar based on its value and the
    total values. It also applies styles based on whether the item is active
    or hovered.

-}
renderBarLine : Float -> Model -> Int -> Item -> Html Msg
renderBarLine totalValues model index item =
    let
        progressWidth =
            (item.value / totalValues) * 100

        itemId =
            String.fromInt index

        isActivated =
            model.activatedItem == Just itemId

        isHovered =
            model.hoveredItem == Just itemId

        isFirstItem =
            index == 0

        isLastItem =
            index == List.length model.data.items - 1
    in
    div
        (LinerBarStyles.styleList (LinerBarStyles.progressItemStyles isActivated isHovered isFirstItem isLastItem item.color progressWidth)
            ++ [ attribute "data-id" itemId
               , onMouseEnter (HoverItem itemId)
               , onMouseLeave LeaveItem
               ]
        )
        [ text (String.fromFloat item.value) ]


{-| Renders a single legend item in the LinerBar.

    - `dark`: A boolean indicating whether to use dark theme styles.
    - `index`: The index of the item being rendered.
    - `item`: The data for the item being rendered.

    This function creates a button with a colored dot and the item name.
    Clicking the button activates or deactivates the corresponding bar.

-}
renderBarLegendItem : Bool -> Int -> Item -> Html Msg
renderBarLegendItem dark index item =
    let
        itemId =
            String.fromInt index
    in
    div
        (LinerBarStyles.styleList LinerBarStyles.legendItemStyles)
        [ button
            (LinerBarStyles.styleList LinerBarStyles.legendItemButtonStyles ++ [ onClick (ActivateDeactivateItem itemId) ])
            [ span (LinerBarStyles.styleList (LinerBarStyles.legendItemDotStyles item.color)) []
            , span (LinerBarStyles.styleList (LinerBarStyles.legendItemNameStyles dark)) [ text item.name ]
            ]
        ]


{-| Renders the entire bar card, including the title, progress bars, and legend.

    - `model`: The current LinerBar model.

    This function orchestrates the rendering of the different parts of the
    chart, using helper functions to render the individual bars and legend items.

-}
renderBarCard : Model -> Html Msg
renderBarCard model =
    let
        totalValues =
            List.sum (List.map .value model.data.items)
    in
    div
        (LinerBarStyles.styleList LinerBarStyles.cardBodyStyles)
        [ p
            (LinerBarStyles.styleList (LinerBarStyles.cardTitleStyles model.data.dark))
            [ text (model.data.title |> Maybe.withDefault "") ]
        , div
            (LinerBarStyles.styleList LinerBarStyles.progressStyles)
            (List.indexedMap (renderBarLine totalValues model) model.data.items)
        , div
            (LinerBarStyles.styleList LinerBarStyles.legendStyles)
            (List.indexedMap (renderBarLegendItem model.data.dark) model.data.items)
        ]

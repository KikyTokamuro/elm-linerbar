module LinerBarStyles exposing
    ( cardBodyStyles
    , cardStyles
    , cardTitleStyles
    , legendItemButtonStyles
    , legendItemDotStyles
    , legendItemNameStyles
    , legendItemStyles
    , legendStyles
    , progressItemStyles
    , progressStyles
    , styleList
    )

{-| This module provides styling attributes for a linear bar chart component.

# Styles

@docs cardBodyStyles, cardStyles, cardTitleStyles, 
    legendItemButtonStyles, legendItemDotStyles, legendItemNameStyles,
    legendItemStyles, legendStyles, progressItemStyles, progressStyles

# Helper Functions

@docs styleList

-}

import Html
import Html.Attributes exposing (style)


{-| Base styles for the card container that holds the entire chart.

- `dark`: A boolean indicating whether to apply dark theme styles.

-}
cardStyles : Bool -> List ( String, String )
cardStyles dark =
    [ ( "position", "relative" )
    , ( "display", "flex" )
    , ( "flexDirection", "column" )
    , ( "minWidth", "0" )
    , ( "fontFamily", "'Ubuntu Mono', sans-serif" )
    , ( "letterSpacing", "0.02em" )
    , ( "wordWrap", "break-word" )
    , ( "boxShadow", "0px 0px 4px 1px rgba(34, 60, 80, 0.18)" )
    ]
        ++ (if dark then
                [ ( "background-color", "#20293e" )
                , ( "color", "#fff" )
                ]

            else
                [ ( "background-color", "transparent" )
                , ( "color", "#000" )
                ]
           )


{-| Styles for individual progress bar items.

- `isActivated`: Indicates if the bar is currently activated (e.g., by clicking the legend).
- `isHovered`: Indicates if the mouse is currently hovering over the bar.
- `isFirstItem`: Indicates if this is the first bar item in the chart.
- `isLastItem`: Indicates if this is the last bar item in the chart.
- `color`: The background color of the bar.
- `progressWidth`: The width of the bar, expressed as a percentage (e.g., "50%").

-}
progressItemStyles : Bool -> Bool -> Bool -> Bool -> String -> Float -> List ( String, String )
progressItemStyles isActivated isHovered isFirstItem isLastItem color progressWidth =
    [ ( "display", "flex" )
    , ( "alignItems", "center" )
    , ( "justifyContent", "center" )
    , ( "marginLeft", "2px" )
    , ( "width", String.fromFloat progressWidth ++ "%" )
    , ( "backgroundColor", color )
    , ( "transition", "transform 0.2s ease, color 0.2s ease" )
    ]
        ++ (if isFirstItem then
                [ ( "border-top-left-radius", "3px" )
                , ( "border-bottom-left-radius", "3px" )
                ]

            else if isLastItem then
                [ ( "border-top-right-radius", "3px" )
                , ( "border-bottom-right-radius", "3px" )
                ]

            else
                []
           )
        ++ (if isActivated || isHovered then
                [ ( "color", "#fff" )
                , ( "transform", "scaleY(1.25)" )
                , ( "fontSize", "13px" )
                ]

            else
                [ ( "color", "transparent" )
                , ( "transform", "none" )
                , ( "fontSize", "inherit" )
                ]
           )


{-| Styles for individual legend items.
-}
legendItemStyles : List ( String, String )
legendItemStyles =
    [ ( "flex", "0 0 auto" )
    , ( "position", "relative" )
    , ( "width", "auto" )
    , ( "maxWidth", "100%" )
    , ( "marginTop", "5px" )
    , ( "paddingRight", "10px" )
    , ( "paddingLeft", "10px" )
    ]


{-| Styles for the legend item button (the button that contains the dot and the name).
-}
legendItemButtonStyles : List ( String, String )
legendItemButtonStyles =
    [ ( "padding", "0" )
    , ( "color", "inherit" )
    , ( "background", "transparent" )
    , ( "border", "0" )
    , ( "outline", "0" )
    , ( "cursor", "pointer" )
    , ( "display", "flex" )
    , ( "alignItems", "center" )
    ]


{-| Styles for the colored dot in the legend.

- `color`: The color of the dot, matching the bar it represents.

-}
legendItemDotStyles : String -> List ( String, String )
legendItemDotStyles color =
    [ ( "display", "inline-block" )
    , ( "width", "10px" )
    , ( "height", "10px" )
    , ( "lineHeight", "1" )
    , ( "backgroundColor", color )
    , ( "marginRight", "5px" )
    ]


{-| Styles for the name of the item in the legend.

- `dark`: A boolean indicating whether to apply dark theme styles.

-}
legendItemNameStyles : Bool -> List ( String, String )
legendItemNameStyles dark =
    [ ( "fontSize", "14px" )
    , ( "color", "#556688" )
    ]
        ++ (if dark then
                [ ( "background-color", "#20293e" )
                , ( "color", "#fff !important" )
                ]

            else
                []
           )


{-| Styles for the card body.
-}
cardBodyStyles : List ( String, String )
cardBodyStyles =
    [ ( "flex", "1 1 auto" )
    , ( "min-height", "1px" )
    , ( "padding", "10px" )
    ]


{-| Styles for the title of the chart.

- `dark`: A boolean indicating whether to apply dark theme styles.

-}
cardTitleStyles : Bool -> List ( String, String )
cardTitleStyles dark =
    [ ( "marginTop", "0" )
    , ( "marginBottom", "15px" )
    , ( "fontSize", "20px" )
    , ( "fontWeight", "500" )
    , ( "textAlign", "center" )
    ]
        ++ (if dark then
                [ ( "background-color", "#20293e" )
                , ( "color", "#fff" )
                ]

            else
                [ ( "color", "#000" ) ]
           )


{-| Styles for the progress bar container.
-}
progressStyles : List ( String, String )
progressStyles =
    [ ( "display", "flex" )
    , ( "flexWrap", "nowrap" )
    , ( "alignItems", "stretch" )
    , ( "height", "17px" )
    , ( "marginLeft", "-2px" )
    , ( "marginBottom", "15px" )
    ]


{-| Styles for the legend container.
-}
legendStyles : List ( String, String )
legendStyles =
    [ ( "display", "flex" )
    , ( "flexWrap", "wrap" )
    , ( "justifyContent", "center" )
    , ( "marginTop", "-5px" )
    , ( "marginRight", "-10px" )
    , ( "marginLeft", "-10px" )
    ]


{-| Helper function to convert a list of style pairs into a list of `Html.Attribute` for use with `Html` elements.
-}
styleList : List ( String, String ) -> List (Html.Attribute msg)
styleList styles =
    List.map (\( key, value ) -> style key value) styles

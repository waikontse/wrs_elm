module Results.List exposing (render)

import Html exposing (Html, a, div, text, span, input, ul, li, table, tr, td, tbody, th, thead)
import Results.Model
import App.Model
import App.Msg


render : List Results.Model.Result -> Html App.Msg.Msg
render results =
    div []
        [ --heading "Results"
          resultsTable results
        ]


resultsTable : List Results.Model.Result -> Html msg
resultsTable results =
    table []
        [ thead []
            [ tr []
                [ th [] [ text "id" ]
                , th [] [ text "raceId" ]
                , th [] [ text "riderId" ]
                , th [] [ text "Result" ]
                ]
            ]
        , tbody []
            (results
                |> List.map
                    (\result ->
                        tr []
                            [ td [] [ text (toString result.id) ]
                            , td [] [ text (toString result.raceId) ]
                            , td [] [ text (toString result.riderId) ]
                            , td [] [ text result.result ]
                            ]
                    )
            )
        ]

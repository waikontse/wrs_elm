module Races.Add exposing (render)

import Html exposing (Html, button, div, text, span, input, ul, li)


import Material exposing (Model)
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Typography as Typo
import Material.Options as Options exposing (css)


import App.Model exposing (Mdl)
import Races.Model exposing (Race)
import App.Msg

type alias RaceAdd =
    { race : Race
    }


initial : RaceAdd
initial =
    { race = (Race 0 "Initial")
    }

render : Race -> Mdl -> Html App.Msg.Msg
render race mdl =
    div []
        [ Options.styled Html.p
            [ Typo.display2 ]
            [ text "Add race" ]
        , div []
            [ Textfield.render App.Msg.Mdl
                [ 2 ]
                mdl
                [ Textfield.label ("Name " ++ race.name)
                , Textfield.floatingLabel
                , Textfield.text'
                , Textfield.onInput App.Msg.SetRaceName
                ]
            ]
        , Button.render App.Msg.Mdl
            [ 0 ]
            mdl
            [ Button.raised
            , Button.onClick (App.Msg.AddRace race)
            ]
            [ text "Add" ]
        ]
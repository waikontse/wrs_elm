module Races.Add exposing (render)

import Html exposing (Html, button, div, text, span, input, ul, li)
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Typography as Typo
import Material.Options as Options exposing (css)
import App.Model exposing (Mdl)
import Races.Model exposing (Race)
import App.Msg

render : Races.Model.Add -> Mdl -> Html App.Msg.Msg
render raceAdd mdl =
    let
        name = raceAdd.name
        date = raceAdd.date
    in
        div []
            [ Options.styled Html.p
                [ Typo.display2 ]
                [ text "Add race" ]
            , div []
                [ Textfield.render App.Msg.Mdl
                    [ 2 ]
                    mdl
                    [ Textfield.label ("Name " ++ name)
                    , Textfield.floatingLabel
                    , Textfield.text'
                    , Textfield.onInput App.Msg.SetRaceName
                    ]
                ]
            , Button.render App.Msg.Mdl
                [ 0 ]
                mdl
                [ Button.raised
                , Button.onClick (App.Msg.AddRace)
                ]
                [ text "Add" ]
            ]

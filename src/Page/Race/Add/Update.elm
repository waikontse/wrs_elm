module Page.Race.Add.Update exposing (update)

import Date
import Date.Extra.Format
import Date.Extra.Config.Config_nl_nl exposing (config)
import Json.Encode
import Ui.Calendar
import App.Model exposing (App)
import App.Page
import App.OutsideInfo exposing (sendInfoOutside)
import Page.Race.Add.Msg as Msg exposing (Msg)
import Data.RaceType exposing (raceTypeToString)


update : Msg -> App -> ( App, Cmd Msg )
update msg app =
    case app.page of
        App.Page.RaceAdd page ->
            case msg of
                Msg.Submit ->
                    let
                        dateString =
                            dateFormat page.calendar.value

                        payload =
                            Json.Encode.object
                                [ ( "name", Json.Encode.string page.name )
                                , ( "date", Json.Encode.string dateString )
                                , ( "category", Json.Encode.string <| raceTypeToString page.raceType )
                                ]
                    in
                        ( app, sendInfoOutside <| App.OutsideInfo.RaceAdd payload )

                Msg.Name name ->
                    let
                        nextPage =
                            App.Page.RaceAdd
                                { page | name = name }
                    in
                        ( { app | page = nextPage }, Cmd.none )

                Msg.RaceType raceType ->
                    let
                        nextPage =
                            App.Page.RaceAdd
                                { page | raceType = raceType }
                    in
                        ( { app | page = nextPage }, Cmd.none )

                Msg.Calendar msg_ ->
                    let
                        ( calendar, cmd ) =
                            Ui.Calendar.update msg_ page.calendar

                        nextPage =
                            App.Page.RaceAdd
                                { page | calendar = calendar }
                    in
                        ( { app | page = nextPage }
                        , Cmd.map Msg.Calendar cmd
                        )

        _ ->
            ( app, Cmd.none )


dateFormat : Date.Date -> String
dateFormat date =
    Date.Extra.Format.format config "%Y-%m-%d 00:00:00" date

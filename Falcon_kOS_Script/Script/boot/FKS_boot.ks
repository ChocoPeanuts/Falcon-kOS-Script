//Falcon kOS Script Boot

//------------------------------------------------------------------------

runOncePath("0:/Falcon_kOS_Script/Common/SharedLibrary.ks").
runOncePath("0:/Falcon_kOS_Script/Common/GUI.ks").

clearScreen.

set GoForLaunch to false.

global Identifier to core:part:getmodule("kOSProcessor"):tag:split("_"). //F9_2nd, FH_Side_1. FSH_Side_4
if Identifier[0] = "F9" //Falcon 9
{
    if Identifier[1] = "Booster"
    {
        set radarOffset to 31.04.

        if ship:status = "prelaunch"
        {
            wait until not core:messages:empty.
        }

        set flightData to loadFlightData("Auto Save").
        set LaunchT to LoadFile(saveFileLocation, "LaunchT", false).
        set EngineList to LoadFile(saveFileLocation, "EngineList", false).

        set LZ to flightData["LZ"][0].

        runScript("F9_Landing.ks").
    }
    else if Identifier[1] = "2nd"
    {
        if ship:status = "prelaunch"
        {
            StartMainGUI().

            wait until GoForLaunch.

            set flightData to loadFlightData("Auto Save").

            set LaunchT to sessionTime + flightData["CT"].
            SaveFile(saveFileLocation, "LaunchT", LaunchT).

            set EngineList to
            lex
            (
                //F9 Booster Engine
                "F9_MainEngine", lex //Engine Tag
                (
                    "CurtMode", "Full", //First Engine Mode
                    "Status", false, //False

                    "Mode", list
                    (
                        "Full", //Mode Title
                        "Three",
                        "Center"
                    )
                ),
                //F9 Vacuum Engine
                "F9_VacEngine", lex
                (
                    "CurtMode", false,
                    "Status", false,

                    "Mode", list
                    (
                    )
                ),
                //Launch Pad Water Deluge
                "F9_39ABase", lex
                (
                    "CurtMode", false,
                    "Status", false,

                    "Mode", list
                    (
                    )
                )
            ).
            SaveFile(saveFileLocation, "EngineList", EngineList).
        }
        else
        {
            set flightData to loadFlightData("Auto Save").
            set LaunchT to LoadFile(saveFileLocation, "LaunchT", false).
            set EngineList to LoadFile(saveFileLocation, "EngineList", false).
        }

        runScript("F9_Ascent.ks").
    }
}
else if Identifier[0] = "FH" //Falcon Heavy
{
    if Identifier[1] = "Core"
    {
        set radarOffset to 31.04.

        if ship:status = "prelaunch"
        {
            wait until not core:messages:empty.
        }

        set flightData to loadFlightData("Auto Save").
        set LaunchT to LoadFile(saveFileLocation, "LaunchT", false).
        set EngineList to LoadFile(saveFileLocation, "EngineList", false).

        set LZ to flightData["LZ"][0].
        set engine to "FH_Core_Engine".

        runScript("FH_Landing.ks").
    }
    else if Identifier[1] = "Side"
    {
        set radarOffset to 24.5.

        if ship:status = "prelaunch"
        {
            wait until not core:messages:empty.
        }

        set flightData to loadFlightData("Auto Save").
        set LaunchT to LoadFile(saveFileLocation, "LaunchT", false).
        set EngineList to LoadFile(saveFileLocation, "EngineList", false).

        if Identifier[2] = "1"
        {
            set LZ to flightData["LZ"][1].
            set engine to "FH_Side_Engine_1".
        }
        else if Identifier[2] = "2"
        {
            set LZ to flightData["LZ"][2].
            set engine to "FH_Side_Engine_2".
        }

        runScript("FH_Landing.ks").
    }
    else if Identifier[1] = "2nd"
    {
        if ship:status = "prelaunch"
        {
            StartMainGUI().

            wait until GoForLaunch.

            set flightData to loadFlightData("Auto Save").

            set LaunchT to sessionTime + flightData["CT"].
            SaveFile(saveFileLocation, "LaunchT", LaunchT).

            set EngineList to
            lex
            (
                //FH Core Engine
                "FH_Core_Engine", lex //Engine Tag
                (
                    "CurtMode", "Full", //First Engine Mode
                    "Status", false, //False

                    "Mode", list
                    (
                        "Full", //Mode Title
                        "Three",
                        "Center"
                    )
                ),
                //FH Side Engine 1
                "FH_Side_Engine_1", lex //Engine Tag
                (
                    "CurtMode", "Full", //First Engine Mode
                    "Status", false, //False

                    "Mode", list
                    (
                        "Full", //Mode Title
                        "Three",
                        "Center"
                    )
                ),
                //FH Side Engine 2
                "FH_Side_Engine_2", lex //Engine Tag
                (
                    "CurtMode", "Full", //First Engine Mode
                    "Status", false, //False

                    "Mode", list
                    (
                        "Full", //Mode Title
                        "Three",
                        "Center"
                    )
                ),
                //FH Vacuum Engine
                "FH_VacEngine", lex
                (
                    "CurtMode", false,
                    "Status", false,

                    "Mode", list
                    (
                    )
                )
            ).
            SaveFile(saveFileLocation, "EngineList", EngineList).
        }
        else
        {
            set flightData to loadFlightData("Auto Save").
            set LaunchT to LoadFile(saveFileLocation, "LaunchT", false).
            set EngineList to LoadFile(saveFileLocation, "EngineList", false).
        }

        runScript("FH_Ascent.ks").
    }
}
else
{
    if ship:status = "prelaunch"
    {
        StartMainGUI().

        wait until GoForLaunch.
    }

    set flightData to loadFlightData("Auto Save").

    runScript("dev.ks").
}

lex //save data configuration
(
    "Auto Save",
    lex
    (
        "title", "Falcon Heavy",

        "ap", 100000,
        "pe", 100000,
        "inc", 0,
        "lng", 0,
        "aop", 0,

        "fairing", "60000,m",
        "vertAsc", "150,m",

        "CT", 20,
        "WDT", 10,
        "IT", 5,

        "LZ",
        list
        (
            "OCISLY",
            "CCSFS LZ-1",
            "CCSFS LZ-2",
            "Expendable",
            "Expendable"
        )
    )
).

lex //Landing Zone Data
(
    "Expendable",
    lex
    (
        "latlng", "0,0,AnyBody",
        "alt", 0,
        "type", "expendable", //expendable, rtls, asds
        "capacity", 100000
    ),
    "CCSFS LZ-1",
    lex
    (
        "latlng", "28.32617,-80.35055,Earth",
        "alt", 0,
        "type", "rtls",
        "capacity", 100000
    ),
    "CCSFS LZ-2",
    lex
    (
        "latlng", "28.33238,-80.35655,Earth",
        "alt", 0,
        "type", "rtls",
        "capacity", 100000
    ),
    "OCISLY",
    lex
    (
        "latlng", "27.38509,-64.06394,Earth",
        "alt", 3.6,
        "type", "asds",
        "capacity", 100000
    )
).

lex //flight data configuration
(
    "title", "Falcon Heavy",

    "ap", 100000,
    "pe", 100000,
    "inc", 0,
    "lng", 0,
    "aop", 0,

    "fairing", list(60000, "m"),
    "vertAsc", list(150, "m"),

    "CT", 20,
    "WDT", 10,
    "IT", 5,

    "LZ",
    list
    (
        lex
        (
            "title", "OCISLY",
            "latlng", latlng(27.38509, -64.06394),
            "alt", 3.6,
            "type", "asds",
            "capacity", 100000
        ),
        lex
        (
            "title", "CCSFS LZ-1",
            "latlng", latlng(28.32617, -80.35055),
            "alt", 0,
            "type", "rtls",
            "capacity", 100000
        ),
        lex
        (
            "title", "CCSFS LZ-2",
            "latlng", latlng(28.33238, -80.35655),
            "alt", 0,
            "type", "rtls",
            "capacity", 100000
        ),
        lex
        (
            "title", "Expendable",
            "latlng", latlng(0, 0),
            "alt", 0,
            "type", "expendable",
            "capacity", 100000
        ),
        lex
        (
            "title", "Expendable",
            "latlng", latlng(0, 0),
            "alt", 0,
            "type", "expendable",
            "capacity", 100000
        )
    )
).

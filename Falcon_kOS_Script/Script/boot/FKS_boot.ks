//Falcon kOS Script Boot

//------------------------------------------------------------------------

runOncePath("0:/Falcon_kOS_Script/Common/SharedLibrary.ks").
clearScreen.

set GoForLaunch to false.
set FKS_config to LoadFile("0:/Falcon_kOS_Script/saves/ConfigData.json", "Auto Save").

global Identifier to core:part:getmodule("kOSProcessor"):tag:split("_"). //F9_2nd, FH_Side_1. FSH_Side_4
if Identifier[0] = "F9" //Falcon 9
{
    if Identifier[1] = "Booster"
    {
        set radarOffset to 31.04.
        set LZ to FKS_config["lz-1"].

        if ship:status = "prelaunch"
        {
            wait until not core:messages:empty.

            set FKS_config to LoadFile("0:/Falcon_kOS_Script/saves/ConfigData.json", "Auto Save").

            runScript("F9_Landing.ks").
        }
    }
    else if Identifier[1] = "2nd"
    {
        if ship:status = "prelaunch"
        {
            runOncePath("0:/Falcon_kOS_Script/Common/GUI.ks").
            StartMainGUI().

            wait until GoForLaunch.
        }
        runScript("F9_Ascent.ks").
    }
}
else if Identifier[0] = "FH" //Falcon Heavy
{
    if Identifier[1] = "Core"
    {
        global radarOffset to 31.04.
        set LZ to FKS_config["lz-1"].
        set engine to "FH_Core_Engine".

        if ship:status = "prelaunch"
        {
            wait until not core:messages:empty.

            set FKS_config to LoadFile("0:/Falcon_kOS_Script/saves/ConfigData.json", "Auto Save").

            runScript("FH_Landing.ks").
        }
    }
    else if Identifier[1] = "Side"
    {
        global radarOffset to 24.5.

        if Identifier[2] = "1"
        {
            set LZ to FKS_config["lz-2"].
            set engine to "FH_Side_Engine_1".

            if ship:status = "prelaunch"
            {
                wait until not core:messages:empty.

                set FKS_config to LoadFile("0:/Falcon_kOS_Script/saves/ConfigData.json", "Auto Save").

                runScript("FH_Landing.ks").
            }
        }
        else if Identifier[2] = "2"
        {
            set LZ to FKS_config["lz-3"].
            set engine to "FH_Side_Engine_2".

            if ship:status = "prelaunch"
            {
                wait until not core:messages:empty.

                set FKS_config to LoadFile("0:/Falcon_kOS_Script/saves/ConfigData.json", "Auto Save").

                runScript("FH_Landing.ks").
            }
        }
    }
    else if Identifier[1] = "2nd"
    {
        if ship:status = "prelaunch"
        {
            runOncePath("0:/Falcon_kOS_Script/Common/GUI.ks").
            StartMainGUI().

            wait until GoForLaunch.
        }
        runScript("FH_Ascent.ks").
    }
}
else
{
    if ship:status = "prelaunch"
    {
        runOncePath("0:/Falcon_kOS_Script/Common/GUI.ks").
        StartMainGUI().

        wait until GoForLaunch.

        runScript("dev.ks").
    }
}

function runScript
{
    parameter fileEnd.

    if FKS_config["runFile"][0] = "dev"
    {
        runOncePath("0:/Falcon_kOS_Script/" + FKS_config["runFile"][0] + "/" + FKS_config["runFile"][1] + "/" + "dev.ks").
    }
    else
    {
        runOncePath("0:/Falcon_kOS_Script/" + FKS_config["runFile"][0] + "/" + FKS_config["runFile"][1] + "/" + fileEnd).
    }
}
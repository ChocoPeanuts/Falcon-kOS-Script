//Falcon kOS Script Falcon 9 Ascent Ver 1.0

//------------------------------------------------------------------------

//Setup
runOncePath("0:/Falcon_kOS_Script/F9/1.0/F9_Library.ks").
global saveFileLocation to "0:/Falcon_kOS_Script/F9/1.0/F9_SaveFile.json".

//set ship:name to FKS_config["title"].

lock MT to floor(sessionTime - LaunchT).

set steeringManager:rollts to 30.

Action("F9_2nd", "ModuleCommand", "Control From Here").

//Startup
if ship:status = "prelaunch"
{
    Action("F9_2nd_Tank", "ModuleEnginesFX", "Activate Engine").
    Action("F9_1st_Tank", "ModuleEnginesFX", "Activate Engine").

    set RunMode to 1.
    set LaunchT to sessionTime + FKS_config["CT"].
    SaveFile(saveFileLocation, "LaunchT", LaunchT).

    //Engine Mode List
    set EngineList to lex
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

    //Check List
    set CheckList to lex
    (
        //Upper Stage
        "Retract", false,
        "WaterDeluge", false,
        "Ignition", false,
        "Liftoff", false,
        "MECO", false,
        "StageSep", false,
        "SES-1", false,
        "SECO-1", false,
        
        "FairingSep", false,

        //Booster
        "ToggleSoot", false
    ).
    SaveFile(saveFileLocation, "CheckList", CheckList).

    //Booster Computer Activate
    processor("F9_Booster"):connection:sendmessage("Activate").
}

lock throttle to thrott().
lock steering to Steer().

//------------------------------------------------------------------------

//Main Script
until RunMode = 0
{
    //Countdown
    if RunMode = 1
    {
        //Strongback Retract
        if not CheckList["Retract"] and MT >= -300 //T-5min
        {
            Action("F9_LaunchPad", "ModuleAnimateGeneric", "Retract Erector").

            set CheckList["Retract"] to true.
            SaveFile(saveFileLocation, "CheckList", CheckList).
        }
        //Water Deluge System Activate
        if not CheckList["WaterDeluge"] and MT >= -FKS_config["WDT"]
        {
            EngineMode("F9_39ABase", "Active").
            Action("F9_39ABase", "ModuleEnginesFX", "Thrust Limiter", 30).

            set CheckList["WaterDeluge"] to true.
            SaveFile(saveFileLocation, "CheckList", CheckList).
        }
        //Ignition
        if not CheckList["Ignition"] and MT >= -FKS_config["IT"]
        {
            EngineMode("F9_MainEngine", "Full").

            set CheckList["Ignition"] to true.
            SaveFile(saveFileLocation, "CheckList", CheckList).
        }
        //Liftoff
        if MT = 0 {
            //Water Deluge System Full Power
            Action("F9_39ABase", "ModuleEnginesFX", "Thrust Limiter", 100).

            //Clamp Release
            Action("F9_LaunchPad", "LaunchClamp", "Release Clamp").

            set CheckList["Liftoff"] to true.
            SaveFile(saveFileLocation, "CheckList", CheckList).

            //lock steering to Steer().

            set RunMode to 2.
        }
    }

    //Vertical Ascent
    else if RunMode = 2
    {
        if  (FKS_config["vertAsc"][1] = 1 and ship:airspeed > FKS_config["vertAsc"][0]) or
            (FKS_config["vertAsc"][1] = 0 and ship:altitude > FKS_config["vertAsc"][0])
        {
            Action("F9_2nd_Tank", "ModuleEnginesFX", "Shutdown Engine").
            Action("F9_1st_Tank", "ModuleEnginesFX", "Shutdown Engine").

            set RunMode to 3.
        }
    }

    //MECO
    else if RunMode = 3
    {
        if (FKS_config["lz-1"]["Type"] = 0 and Resource("F9_1st_Tank", "liquidfuel")["Amount"] = 0) or
           (FKS_config["lz-1"]["Type"] = 1 and Resource("F9_1st_Tank", "liquidfuel")["Per"] < 20) or
           (FKS_config["lz-1"]["Type"] = 2 and Error(ImpactData()["LatLng"], OP(FKS_config["lz-1"]["LatLng"], 1500))[3] > 0)
        {
            print Resource("F9_1st_Tank", "liquidfuel")["Per"].

            //Engine Cut Off
            set MECOSteer to ship:facing.

            Action("F9_1st_RCS", "ModuleRCSFX", "Toggle RCS Thrust", true).
            rcs on.

            set CheckList["MECO"] to true.
            SaveFile(saveFileLocation, "CheckList", CheckList).

            wait 1.

            //Stage Separation
            Action("F9_2nd_RCS", "ModuleRCSFX", "Toggle RCS Thrust", true).
            Action("F9_Booster", "ModuleTundraDecoupler", "Decouple").

            set CheckList["StageSep"] to true.
            SaveFile(saveFileLocation, "CheckList", CheckList).

            wait 3.

            //Second Engine Start
            EngineMode("F9_VacEngine", "Active").
            //rcs off.

            set CheckList["SES-1"] to true.
            SaveFile(saveFileLocation, "CheckList", CheckList).

            set RunMode to 4.
        }
    }

    //SECO-1
    else if RunMode = 4
    {
        if ship:apoapsis > FKS_config["pe"]
        {
            set CheckList["SECO-1"] to true.
            SaveFile(saveFileLocation, "CheckList", CheckList).
            
            set RunMode to 5.
        }
    }

    //Maneuver Node
    else if RunMode = 5
    {
        //Create Node
        if not hasNode
        {
            if ship:altitude > ship:body:atm:height
            {
                local gm to constant:g * ship:body:mass.
                local rap to ship:apoapsis + 600000.
                local vap to sqrt(gm * ((2 / rap) - (1 / ship:orbit:semimajoraxis))).
                local tgv to sqrt(gm * ((2 / rap) - (1 / rap))).
                local burnV to tgv - vap.

                set tgNode to node(timespan(eta:apoapsis), 0, 0, burnV).
                add tgNode.

                set ManeuverT to (tgNode:deltav:mag / acc(ship:maxthrust)[0]) / 2.
                set dv0 to tgNode:deltav.
            }
        }
        //Execute Maneuver
        else
        {
            if tgNode:eta < ManeuverT + 60 and warp <> 0
            {
                set warp to 0.
            }
            if vdot(dv0, tgNode:deltav) < 0 or tgNode:deltaV:mag < 0.1
            {
                remove tgNode.
                unlock all.
                set RunMode to 0.
            }
        }
    }



    //Fairing Separation
    if not CheckList["FairingSep"] and
        ((FKS_config["fairing"][1] = 0 and ship:altitude > FKS_config["fairing"][0]) or
        (FKS_config["fairing"][1] = 1 and ship:dynamicpressure < FKS_config["fairing"][0]))
    {
        Action("F9_Fairing", "ModuleDecouple", "Decouple").

        set CheckList["FairingSep"] to true.
        SaveFile(saveFileLocation, "CheckList", CheckList).
    }

    wait 0.
}

//------------------------------------------------------------------------

//Throttle
function Thrott
{
    if RunMode = 1 or
       RunMode = 2 or
       (RunMode = 3 and not CheckList["MECO"]) or
       RunMode = 4
    {
        return 1.
    }
    else if RunMode = 5
    {
        if hasNode and tgNode:eta < ManeuverT
        {
            return min(tgNode:deltav:mag / (ACC(ship:maxthrust)[0] / 5), 1).
        }
    }
    
    return 0.
}

//Steering
function Steer
{
    if RunMode = 2 {
        return lookDirUp(ship:up:vector, facing:topvector).
    }
    else if RunMode = 3 or RunMode = 4
    {
        if (RunMode = 3 and CheckList["MECO"])
        {
            return MECOSteer.
        }
        else {
            if Angle()["Pitch"] > 10
            {
                return heading(90, 90 - (ship:apoapsis / 1500), 0).
            }
            else
            {
                return heading(90, 10, 0).
            }
        }
    }
    else if RunMode = 5
    {
        if hasNode {
            if tgNode:deltav:mag < 5
            {
                return ship:facing.
            }
            else
            {
                return lookDirUp(tgNode:deltav, facing:topvector).
            }
        }
        else
        {
            return lookDirUp(ship:prograde:vector, facing:topvector).
        }
    }

    return ship:facing.
}
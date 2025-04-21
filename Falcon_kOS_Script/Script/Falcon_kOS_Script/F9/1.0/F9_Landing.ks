//Falcon kOS Script Falcon 9 Landing Ver 1.0

//------------------------------------------------------------------------

//Setup
runOncePath("0:/Falcon_kOS_Script/F9/1.0/F9_Library.ks").
global saveFileLocation to "0:/Falcon_kOS_Script/F9/1.0/F9_SaveFile.json".

//Start Up
if ship:status = "prelaunch"
{
    set RunMode to 1.
}

//Restart
else
{
}

//------------------------------------------------------------------------

//Main Script
until RunMode = 0
{
//------------------------------------------------------------------------
    //Load List
    set EngineList to LoadFile(saveFileLocation, "EngineList").
    set CheckList to LoadFile(saveFileLocation, "CheckList").
//------------------------------------------------------------------------

    //Wait for MECO
    if RunMode = 1
    {
        if CheckList["StageSep"]
        {
            set ship:name to "F9 Booster".
                set steeringManager:pitchts to 10.
                set steeringManager:yawts to 10.
                set steeringManager:rollts to 30.
                set steeringManager:maxstoppingtime to 1.
                set steeringManager:pitchpid:kd to steeringManager:pitchpid:kd + 5.
                set steeringManager:yawpid:kd to steeringManager:yawpid:kd + 5.
                set MECOSteer to ship:facing.
                lock throttle to Thrott().
                lock tgSteer to Steer().
                lock steering to tgSteer.
                rcs on.
                EngineMode("F9_MainEngine", "Three").

                wait 1.

                //set steeringManager:maxstoppingtime to 15.
                set RunMode to 2.
        }
    }

    //Boostback Turn
    else if RunMode = 2
    {
        set ship:control:pitch to 1.

        if FacingError(heading(-OP(FKS_config["lz-1"]["latlng"], -2500):heading, 180):vector) < 45
        {
            set ship:control:pitch to 0.
            //set steeringManager:maxstoppingtime to 0.3.
            rcs off.

            set RunMode to 3.
        }
    }

    //Boostback Burn
    else if RunMode = 3
    {
        if Error(ImpactData()["LatLng"], OP(FKS_config["lz-1"]["latlng"], -2500))[3] < 0
        {
            rcs on.
            set steeringManager:maxstoppingtime to 0.2.

            set RunMode to 4.
        }
    }

    //Coasting
    else if RunMode = 4
    {
        if not brakes
        {
            brakes on.
            Action("F9_GridFin", "ModuleControlSurface", "authority limiter", 0).
        }

        if ship:verticalspeed < -300 and ThrottleControl(ship:maxthrust, 30000, -550) > 1
        {
            rcs off.
            set steeringManager:maxstoppingtime to 0.5.

            set RunMode to 5.
        }
    }

    //Entry Burn
    else if RunMode = 5
    {
        //Toggle Soot
        if not CheckList["ToggleSoot"]
        {
            Action("F9_1st", "ModuleTundraSoot", "Toggle Soot", true).
            Action("F9_1st_Tank", "ModuleTundraSoot", "Toggle Soot", true).
            Action("F9_MainEngine", "ModuleTundraSoot", "Toggle Soot", true).

            set CheckList["ToggleSoot"] to true.
            SaveFile(saveFileLocation, "CheckList", CheckList).
        }

        if ship:verticalSpeed > -550
        {
            rcs on.
            set steeringManager:maxstoppingtime to 3.
            set steeringManager:pitchts to 1.
            set steeringManager:yawts to 1.
            Action("F9_GridFin", "ModuleControlSurface", "authority limiter", 35).

            set RunMode to 6.

            //print Error(ship:geoposition, FKS_config["lz-1"]["latlng"])[1].
        }
    }

    //Griding
    else if RunMode = 6
    {
        if rcs and FacingError(tgSteer:vector) < 5
        {
            rcs off.
            Action("F9_GridFin", "ModuleControlSurface", "authority limiter", 50).
        }

        if ship:altitude < 10000
        {
            if ThrottleControl(700, FKS_config["lz-1"]["alt"], 0) > 1 and ship:altitude < 4000
            {
                EngineMode("F9_MainEngine", "Center").

                set RunMode to 7.
            }
            else if ThrottleControl(1550, 3500, sqrt(1500 * (5 * ((700 / ship:mass) - constant:g * body:mass / body:radius^2)))) > 1
            {
                set RunMode to 7.
            }
        }
    }

    //Landing Burn
    else if RunMode = 7
    {
        //Center Engine Only
        if EngineList["F9_MainEngine"]["CurtMode"] = "Three" and ThrottleControl(700, FKS_config["lz-1"]["alt"], 0) < 1
        {
            EngineMode("F9_MainEngine", "Center").
        }

        //Landing Legs Deployment
        if not legs and ImpactData()["tillImpact"] < 3
        {
            legs on.
        }

        //Landing Confirmed
        if ship:status = "landed" or ship:status = "splashed" or ship:verticalSpeed > -0.5
        {
            Action("F9_GridFin", "ModuleControlSurface", "authority limiter", 0).

            set RunMode to 8.
        }
    }

    //Fall Prevention
    else if RunMode = 8
    {
        if vAng(ship:facing:vector, lookDirUp(ship:up:vector, facing:topvector):vector) > 10
        {
            rcs on.
        }
        else
        {
            rcs off.
        }
    }

    wait 0.
}

//------------------------------------------------------------------------

//Throttle
function Thrott {
    if RunMode = 3
    {
        return 1.
    }
    else if RunMode = 5
    {
        return ThrottleControl(ship:maxthrust, 30000, -550).
    }
    else if RunMode = 7
    {
        if EngineList["F9_MainEngine"]["CurtMode"] = "Center"
        {
            return ThrottleControl(ship:maxthrust, FKS_config["lz-1"]["alt"], 0).
        }
        return 1.
    }
    
    return 0.
}

//Steering
function Steer {
    if RunMode = 1
    {
        return MECOSteer.
    }
    else if RunMode = 2
    {
        //return lookDirUp(heading(90, Angle()["Pitch"] + 25):vector, MECOSteer:topvector).
    }
    else if RunMode = 3
    {
        return lookdirup(vxcl(up:vector, -Error(ImpactData()["LatLng"], OP(FKS_config["lz-1"]["latlng"], -2500))[0]), -up:vector).
    }
    else if RunMode = 4 or RunMode = 5
    {
        if ship:verticalspeed < -100
        {
            return -ship:velocity:surface.
        }
        else
        {
            return lookDirUp(ship:up:vector, facing:topvector).
        }
    }
    else if RunMode = 6
    {
        local IP to ImpactData()["LatLng"].
        local TgP to OP(FKS_config["lz-1"]["latlng"], 250).

        return SteeringPid(line(100, 3, 150, 13, Error(IP, TgP)[1], 3, 13), 0.1, ship:velocity:surface, Error(IP, TgP)[0]).
    }
    else if RunMode = 7
    {
        if TrueAlt() - FKS_config["lz-1"]["alt"] < 50
        {
            return lookDirUp(ship:up:vector, facing:topvector).
        }
        else if Error(ship:geoPosition, FKS_config["lz-1"]["latlng"])[1] < 100
        {
            return SteeringPid(line(300, -1, 750, -10, TrueAlt(0) - FKS_config["lz-1"]["alt"], -10, -1), 5, ship:velocity:surface, Error(ImpactData()["LatLng"], FKS_config["lz-1"]["latlng"])[0]).
        }
        return SteeringPid(line(150, -5, 1000, -10, Error(ship:geoPosition, FKS_config["lz-1"]["latlng"])[1], -10, -5), 3, ship:velocity:surface, Error(ship:geoposition, FKS_config["lz-1"]["latlng"])[0]).
    }
    else if RunMode = 8
    {
        return lookDirUp(ship:up:vector, facing:topvector).
    }

    return ship:facing.
}
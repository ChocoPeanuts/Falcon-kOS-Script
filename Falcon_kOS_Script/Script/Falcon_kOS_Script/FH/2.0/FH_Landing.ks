//Falcon kOS Script Falcon Heavy Landing Ver 2.0

//------------------------------------------------------------------------

runOncePath("0:/Falcon_kOS_Script/FH/2.0/FH_Library.ks").
global saveFileLocation to "0:/Falcon_kOS_Script/FH/2.0/FH_SaveFile.json".

set EngineList to LoadFile(saveFileLocation, "EngineList").

set ship:name to "FH Booster".
set steeringManager:pitchts to 30.
set steeringManager:yawts to 30.
set steeringManager:rollts to 50.
set steeringManager:maxstoppingtime to 1.
set steeringManager:pitchpid:kd to steeringManager:pitchpid:kd + 5.
set steeringManager:yawpid:kd to steeringManager:yawpid:kd + 5.

set sepAngle to ship:facing.

set boostbackOffset to -1000.
set entryOffset to 400.
set aeroDescentOffset to 70.

rcs on.
Action("FH_Side_RCS", "ModuleRCSFX", "Toggle RCS Thrust", true).
//sas on.

//wait 1.

set ship:control:yaw to -1.
lock steering to r(ship:facing:pitch, ship:facing:yaw, sepAngle:roll).

wait until FacingError(heading(-OP(LZ["latlng"], boostbackOffset):heading, 180):vector) < 50.
    set ship:control:yaw to 0.
    set steeringManager:pitchts to 15.
    set steeringManager:yawts to 15.
    //sas off.
    Action(engine, "ModuleEnginesFX", "Thrust Limiter", 100).
    EngineMode(engine, "Three").
    rcs off.
    lock steering to lookdirup(vxcl(up:vector, -Error(impactData()["LatLng"], OP(LZ["latlng"], boostbackOffset))[0]), -up:vector).
    lock throttle to 1.

wait until Error(impactData()["LatLng"], OP(LZ["latlng"], boostbackOffset))[3] < 0.
    rcs on.
    //set steeringManager:pitchts to 50.
    //set steeringManager:yawts to 50.
    set steeringManager:maxstoppingtime to 0.2.
    brakes on.
    Action("FH_GridFin", "ModuleControlSurface", "authority limiter", 0).
    lock steering to lookDirUp(ship:up:vector, facing:topvector).
    lock throttle to 0.
    wait until ship:verticalspeed < -100.
        lock steering to -ship:velocity:surface.

wait until ship:verticalspeed < -300 and ThrottleControl(ship:maxthrust, 30000, -550) > 1.
    rcs off.
    set steeringManager:maxstoppingtime to 0.5.
    set steeringManager:pitchts to 10.
    set steeringManager:yawts to 10.
    set steeringManager:rollts to 30.
    Action(core:part:getmodule("kOSProcessor"):tag, "ModuleTundraSoot", "Toggle Soot", true).
    Action("FH_Side_Tank", "ModuleTundraSoot", "Toggle Soot", true).
    Action("FH_Core_Tank", "ModuleTundraSoot", "Toggle Soot", true).
    Action(engine, "ModuleTundraSoot", "Toggle Soot", true).
    lock throttle to 1.

wait until ship:verticalSpeed > -550.
    rcs on.
    set steeringManager:maxstoppingtime to 3.
    set steeringManager:pitchts to 1.
    set steeringManager:yawts to 1.
    Action("FH_GridFin", "ModuleControlSurface", "authority limiter", 35).
    lock aeroDescentSteering to SteeringPid(line(100, 0.1, 150, 15, Error(impactData()["LatLng"], OP(LZ["latlng"], aeroDescentOffset))[1], 0.1, 15), 0.01, ship:velocity:surface, Error(impactData()["LatLng"], OP(LZ["latlng"], aeroDescentOffset))[0]).
    lock steering to aeroDescentSteering.
    lock throttle to 0.
wait until FacingError(aeroDescentSteering:vector) < 5.
    rcs off.
    Action("FH_GridFin", "ModuleControlSurface", "authority limiter", 50).

wait until ship:altitude < 10000.
    wait until (ThrottleControl(750, LZ["alt"], 0) > 1 and ship:altitude < 4000) or
               (ThrottleControl(1550, 3500, sqrt(1500 * (5 * ((700 / ship:mass) - constant:g * body:mass / body:radius^2)))) > 1).
        lock steering to SteeringPid(line(150, 0, 1000, -17, Error(ship:geoPosition, LZ["latlng"])[1], -17, 0), 5, ship:velocity:surface, Error(latlng((ship:geoposition:lat + impactData()["LatLng"]:lat)/2, (ship:geoposition:lng + impactData()["LatLng"]:lng)/2), LZ["latlng"])[0]).

        if ship:altitude < 4000
        {
            EngineMode(engine, "Center").
        }
        else
        {
            lock throttle to 1.
            wait until ThrottleControl(750, LZ["alt"], 0) < 1.
                EngineMode(engine, "Center").
        }
        lock throttle to ThrottleControl(ship:maxthrust, LZ["alt"], 0).

        //wait until TrueAlt(radarOffset) - LZ["alt"] < 100.
        //    lock steering to lookDirUp(ship:up:vector, facing:topvector).

        wait until impactData()["tillImpact"] < 3.
            legs on.

        wait until ship:status = "landed" or ship:status = "splashed" or ship:verticalSpeed > -0.5.
            Action("FH_GridFin", "ModuleControlSurface", "authority limiter", 0).
            lock throttle to 0.

until false.
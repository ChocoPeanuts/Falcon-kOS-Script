//Falcon kOS Script Falcon 9 Landing Ver 1.0

//------------------------------------------------------------------------

runOncePath("0:/Falcon_kOS_Script/F9/1.0/F9_Library.ks").

set ship:name to "F9 Booster".
set steeringManager:pitchts to 30.
set steeringManager:yawts to 30.
set steeringManager:rollts to 30.
set steeringManager:maxstoppingtime to 1.
set steeringManager:pitchpid:kd to steeringManager:pitchpid:kd + 5.
set steeringManager:yawpid:kd to steeringManager:yawpid:kd + 5.

set sepAngle to ship:facing.

rcs on.

if LZ["type"] = "expendable"
{
    until false.
}
else if LZ["type"] = "rtls"
{
    set boostbackOffset to -3000.
    set entryAlt to 30000.
    set entrySpeed to -550.
    set aeroDescentOffset to 130.

    wait 1.

    //set ship:control:yaw to -1.
    //lock steering to r(ship:facing:pitch, ship:facing:yaw, sepAngle:roll).
    set steeringManager:maxstoppingtime to 10.
    lock steering to lookDirUp(heading(90, Angle()["Pitch"] + 15):vector, sepAngle:topvector).

    wait until FacingError(heading(-OP(LZ["latlng"], boostbackOffset):heading, 180):vector) < 50.
        //set ship:control:yaw to 0.
        set steeringManager:maxstoppingtime to 1.
        set steeringManager:pitchts to 15.
        set steeringManager:yawts to 15.
        //sas off.
        EngineMode("F9_MainEngine", "Three").
        rcs off.
        lock steering to lookdirup(vxcl(up:vector, -Error(impactData()["LatLng"], OP(LZ["latlng"], boostbackOffset))[0]), -up:vector).
        lock throttle to 1.

    wait until Error(impactData()["LatLng"], OP(LZ["latlng"], boostbackOffset))[3] < 0.
        rcs on.
        //set steeringManager:pitchts to 50.
        //set steeringManager:yawts to 50.
        set steeringManager:maxstoppingtime to 0.2.
        brakes on.
        Action("F9_GridFin", "ModuleControlSurface", "authority limiter", 0).
        lock steering to lookDirUp(ship:up:vector, facing:topvector).
        lock throttle to 0.
        wait until ship:verticalspeed < -100.
            lock steering to -ship:velocity:surface.
}
else if LZ["Type"] = "asds"
{
    set entryAlt to 30000.
    set entrySpeed to -850.
    set aeroDescentOffset to 7500.

    EngineMode("F9_MainEngine", "Three").
    set steeringManager:maxstoppingtime to 0.2.
    lock steering to lookDirUp(ship:up:vector, facing:topvector).

    wait 5.

    brakes on.
    Action("F9_GridFin", "ModuleControlSurface", "authority limiter", 0).
    //lock throttle to 0.
    wait until ship:verticalspeed < -100.
        lock steering to -ship:velocity:surface.
}

wait until ship:verticalspeed < -600 and ThrottleControl(ship:maxthrust, entryAlt, entrySpeed) > 1.
//lock steering to SteeringPid(5, 5, ship:velocity:surface, Error(ImpactData()["LatLng"], LZ["latlng"])[0]).
    rcs off.
    set steeringManager:maxstoppingtime to 0.5.
    set steeringManager:pitchts to 10.
    set steeringManager:yawts to 10.
    set steeringManager:rollts to 30.
    Action("F9_1st", "ModuleTundraSoot", "Toggle Soot", true).
    Action("F9_1st_Tank", "ModuleTundraSoot", "Toggle Soot", true).
    Action("F9_MainEngine", "ModuleTundraSoot", "Toggle Soot", true).
    lock throttle to 1.

wait until ship:verticalSpeed > entrySpeed.

    rcs on.
    set steeringManager:maxstoppingtime to 3.
    set steeringManager:pitchts to 1.
    set steeringManager:yawts to 1.
    Action("F9_GridFin", "ModuleControlSurface", "authority limiter", 35).
    lock aeroDescentSteering to SteeringPid(line(50, 1, 150, 13, Error(impactData()["LatLng"], OP(LZ["latlng"], aeroDescentOffset))[1], 1, 13), 0.001, ship:velocity:surface, Error(impactData()["LatLng"], OP(LZ["latlng"], aeroDescentOffset))[0]).
    lock steering to aeroDescentSteering.
    lock throttle to 0.
wait until FacingError(aeroDescentSteering:vector) < 5.
    rcs off.
    Action("F9_GridFin", "ModuleControlSurface", "authority limiter", 50).

wait until ship:altitude < 10000.
    wait until (ThrottleControl(750, LZ["alt"], 0) > 1.5 and ship:altitude < 4000) or
               (ThrottleControl(1550, 3500, sqrt(1500 * (5 * ((700 / ship:mass) - constant:g * body:mass / body:radius^2)))) > 1.5).
        //lock steering to SteeringPid(line(150, -5, 1000, -13, Error(ship:geoPosition, LZ["latlng"])[1], -13, -5), 5, ship:velocity:surface, Error(latlng((ship:geoposition:lat + impactData()["LatLng"]:lat)/2, (ship:geoposition:lng + impactData()["LatLng"]:lng)/2), LZ["latlng"])[0]).
        //lock steering to SteeringPid(line(150, 0, 300, -10, TrueAlt(0) - LZ["alt"], -10, -5), 10, ship:velocity:surface, Error(MidLatLng(ship:geoposition, impactData()["LatLng"]), LZ["latlng"])[0]).
        lock steering to SteeringPid(line(50, -3, 300, -15, Error(MidLatLng(ship:geoposition, impactData()["LatLng"]), LZ["latlng"])[1], -15, -3), 10, ship:velocity:surface, Error(MidLatLng(ship:geoposition, impactData()["LatLng"]), LZ["latlng"])[0]).
        
        //when Error(ship:geoPosition, LZ["latlng"])[1] < 150 then
        when TrueAlt() - LZ["alt"] < 150 then
        {
            //lock steering to ship:srfRetrograde.
            lock steering to KillSurfVel(line(50, 0, 100, -7, TrueAlt(0) - LZ["alt"], -7, 0), 1).
        }

        if ship:altitude < 4000
        {
            EngineMode("F9_MainEngine", "Center").
        }
        else
        {
            lock throttle to 1.
            wait until ThrottleControl(750, LZ["alt"], 0) < 1.
                EngineMode("F9_MainEngine", "Center").
        }
        lock throttle to ThrottleControl(ship:maxthrust, LZ["alt"], 0).

        //wait until TrueAlt(radarOffset) - LZ["alt"] < 100.
        //    lock steering to lookDirUp(ship:up:vector, facing:topvector).

        wait until impactData()["tillImpact"] < 3.
            legs on.

        wait until ship:status = "landed" or ship:status = "splashed" or ship:verticalSpeed > -0.5.
            Action("FH_GridFin", "ModuleControlSurface", "authority limiter", 0).
            lock throttle to 0.
//            until false
//            {
//                print TrueAlt() at (0, 0).
//                print ship:geoposition:lat at (0, 1).
//                print ship:geoposition:lng at (0, 2).
//            }

until false.
//Falcon kOS Script Falcon 9 Ascent Ver 1.0

//------------------------------------------------------------------------

//Setup
runOncePath("0:/Falcon_kOS_Script/F9/1.0/F9_Library.ks").

set steeringManager:rollts to 30.

lock MT to floor(sessionTime - LaunchT).

Action("F9_2nd_Tank", "ModuleEnginesFX", "Activate Engine").
Action("F9_1st_Tank", "ModuleEnginesFX", "Activate Engine").

wait until MT >= -300.
    Action("F9_LaunchPad", "ModuleAnimateGeneric", "Retract Erector").

wait until MT >= -flightData["WDT"].
    EngineMode("F9_39ABase", "Active").
    Action("F9_39ABase", "ModuleEnginesFX", "Thrust Limiter", 30).
    lock throttle to 1.

wait until MT >= -flightData["IT"].
    EngineMode("F9_MainEngine", "Full").

wait until MT = 0.
    Action("F9_39ABase", "ModuleEnginesFX", "Thrust Limiter", 100).
    Action("F9_LaunchPad", "LaunchClamp", "Release Clamp").
    lock steering to lookDirUp(ship:up:vector, facing:topvector).

if flightData["vertAsc"][1] = "m"
{
    wait until ship:altitude > flightData["vertAsc"][0].
}
else
{
    wait until ship:airspeed > flightData["vertAsc"][0].
}
    Action("F9_2nd_Tank", "ModuleEnginesFX", "Shutdown Engine").
    Action("F9_1st_Tank", "ModuleEnginesFX", "Shutdown Engine").
    lock steering to heading(90, max(90 - (ship:apoapsis / 1500), 10), 0).

if flightData["LZ"][0]["type"] = "expendable"
{
    wait until Resource("F9_1st_Tank", "liquidfuel")["Amount"] = 0.
}
else if flightData["LZ"][0]["type"] = "rtls"
{
    wait until Resource("F9_1st_Tank", "liquidfuel")["Per"] < 20.
}
else
{
    wait until Error(ImpactData()["LatLng"], OP(flightData["LZ"][0]["latlng"], 5000))[3] > 0.
    //wait until Resource("FH_Core_Tank", "liquidfuel")["Per"] < 20.
}
    set mecoSteer to ship:facing.
    lock steering to mecoSteer.
    lock throttle to 0.
    Action("F9_1st_RCS", "ModuleRCSFX", "Toggle RCS Thrust", true).
    rcs on.

    wait 1.

    Action("F9_2nd_RCS", "ModuleRCSFX", "Toggle RCS Thrust", true).
    processor("F9_Booster"):connection:sendmessage("Activate").
    Action("F9_Booster", "ModuleTundraDecoupler", "Decouple").

    wait 3.

    EngineMode("F9_VacEngine", "Active").
    lock steering to heading(90, max(90 - (ship:apoapsis / 1500), 10), 0).
    lock throttle to 1.

wait 15.

if flightData["fairing"][1] = "m"
{
    wait until ship:altitude > flightData["fairing"][0].
}
else
{
    wait until ship:dynamicpressure < flightData["fairing"][0].
}
Action("F9_Fairing", "ModuleDecouple", "Decouple").

wait until ship:apoapsis > flightData["pe"].
lock steering to lookDirUp(ship:prograde:vector, facing:topvector).
    lock throttle to 0.

wait until ship:altitude > ship:body:atm:height.
    if not hasNode
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
    lock steering to lookDirUp(tgNode:deltav, facing:topvector).

    wait until tgNode:eta < ManeuverT + 60 and warp <> 0.
        set warp to 0.

    wait until tgNode:eta < ManeuverT.
        lock throttle to min(tgNode:deltav:mag / (ACC(ship:maxthrust)[0] / 5), 1).
        wait until tgNode:deltav:mag < 5.
            lock steering to ship:facing.

    wait until vdot(dv0, tgNode:deltav) < 0 or tgNode:deltaV:mag < 0.1.
        remove tgNode.
        lock throttle to 0.
        unlock all.
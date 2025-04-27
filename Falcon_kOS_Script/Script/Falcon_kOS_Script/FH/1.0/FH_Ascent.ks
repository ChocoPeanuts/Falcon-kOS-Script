//Falcon kOS Script Falcon Heavy Ascent Ver 1.0

//------------------------------------------------------------------------

//Setup
runOncePath("0:/Falcon_kOS_Script/FH/1.0/FH_Library.ks").

set steeringManager:rollts to 30.

lock MT to floor(sessionTime - LaunchT).

Action("FH_2nd_Tank", "ModuleEnginesFX", "Activate Engine").
Action("FH_Core_Tank", "ModuleEnginesFX", "Activate Engine").
Action("FH_Side_Tank_1", "ModuleEnginesFX", "Activate Engine").
Action("FH_Side_Tank_2", "ModuleEnginesFX", "Activate Engine").

wait until MT >= -300.
    Action("FH_LaunchPad", "ModuleAnimateGeneric", "Retract Erector").

wait until MT >= -flightData["WDT"].
    Action("FH_39ABase", "ModuleEnginesFX", "Activate Engine").
    Action("FH_39ABase", "ModuleEnginesFX", "Thrust Limiter", 30).
    lock throttle to 1.

wait until MT >= -flightData["IT"].
    EngineMode("FH_Core_Engine", "Full").
    EngineMode("FH_Side_Engine_1", "Full").
    EngineMode("FH_Side_Engine_2", "Full").

wait until MT = 0.
    Action("FH_39ABase", "ModuleEnginesFX", "Thrust Limiter", 100).
    Action("FH_LaunchPad", "LaunchClamp", "Release Clamp").
    lock steering to lookDirUp(ship:up:vector, facing:topvector).

if flightData["vertAsc"][1] = "m"
{
    wait until ship:altitude > flightData["vertAsc"][0].
}
else
{
    wait until ship:airspeed > flightData["vertAsc"][0].
}
    Action("FH_2nd_Tank", "ModuleEnginesFX", "Shutdown Engine").
    Action("FH_Core_Tank", "ModuleEnginesFX", "Shutdown Engine").
    Action("FH_Side_Tank", "ModuleEnginesFX", "Shutdown Engine").
    Action("FH_Core_Engine", "ModuleEnginesFX", "Thrust Limiter", 75).
    lock steering to heading(90, max(90 - (ship:apoapsis / 1500), 10), 0).

if flightData["LZ"][1]["type"] = "expendable"
{
    wait until Resource("FH_Side_Tank", "liquidfuel")["Amount"] = 0.
}
else if flightData["LZ"][1]["type"] = "rtls"
{
    wait until Resource("FH_Side_Tank", "liquidfuel")["Per"] < 22.
}
else
{
    wait until Error(ImpactData()["LatLng"], OP(flightData["LZ"][1]["latlng"], 1500))[3] > 0.
}
    Action("FH_Side_Engine_1", "ModuleEnginesFX", "Thrust Limiter", 0).
    Action("FH_Side_Engine_2", "ModuleEnginesFX", "Thrust Limiter", 0).

    wait 1.

    processor("FH_Side_1"):connection:sendmessage("Activate").
    processor("FH_Side_2"):connection:sendmessage("Activate").
    Action("FH_Side_RCS", "ModuleRCSFX", "Toggle RCS Thrust", true).
    Action("FH_Decoupler", "ModuleTundraAnchoredDecoupler", "Decouple").
    Action("FH_Core_Engine", "ModuleEnginesFX", "Thrust Limiter", 100).

if flightData["LZ"][0]["type"] = "expendable"
{
    wait until Resource("FH_Side_Tank", "liquidfuel")["Amount"] = 0.
}
else if flightData["LZ"][0]["type"] = "rtls"
{
    wait until Resource("FH_Side_Tank", "liquidfuel")["Per"] < 25.
}
else
{
    wait until Error(ImpactData()["LatLng"], OP(flightData["LZ"][0]["latlng"], 10000))[3] > 0.
    //wait until Resource("FH_Core_Tank", "liquidfuel")["Per"] < 20.
}
    set mecoSteer to ship:facing.
    lock steering to mecoSteer.
    lock throttle to 0.
    Action("FH_Core_RCS", "ModuleRCSFX", "Toggle RCS Thrust", true).
    rcs on.

    wait 1.

    Action("FH_2nd_RCS", "ModuleRCSFX", "Toggle RCS Thrust", true).
    processor("FH_Core"):connection:sendmessage("Activate").
    Action("FH_Core", "ModuleTundraDecoupler", "Decouple").

    wait 3.

    EngineMode("FH_VacEngine", "Active").
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
Action("FH_Fairing", "ModuleDecouple", "Decouple").

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
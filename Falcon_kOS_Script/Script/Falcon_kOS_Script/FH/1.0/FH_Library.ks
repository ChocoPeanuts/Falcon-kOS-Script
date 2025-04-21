//Falcon kOS Script Falcon 9 Library Ver 1.1

//------------------------------------------------------------------------

function Line
{
    parameter x1, y1, x2, y2, variable.
    parameter minValue to false.
    parameter maxValue to false.

    local ansA to 0.
    local ansB to 0.

    if x1 = 0
    {
        set ansB to y1.
        set ansA to (y2 - ansB) / x2.
    }
    else
    {
        local mul to - (x2 / x1).
        local Result_y to y1 * mul + y2.
        local Result_b to mul + 1.

        set ansB to Result_y / Result_b.
        set ansA to (y1 - ansB) / x1.
    }

    local value to variable * ansA + ansB.

    if minValue <> false and value < minValue
    {
        return minValue.
    }
    else if maxValue <> false and value > maxValue
    {
        return maxValue.
    }
    return value.
}

function Action
{
    parameter Tag, Module, Title, Mode to "###N/A###".

    for Part in ship:partstagged(Tag)
    {
        if Part:hasModule(Module)
        {
            if Mode = "###N/A###"
            {
                if Part:getmodule(Module):hasevent(Title)
                {
                    Part:getmodule(Module):doevent(Title).
                }
            }
            else if Mode:typename = "Scalar"
            {
                if Part:getmodule(Module):hasfield(Title)
                {
                    Part:getmodule(Module):setfield(Title, Mode).
                }
            }
            else
            {
                if Part:getmodule(Module):hasaction(Title)
                {
                    Part:getmodule(Module):doaction(Title, Mode).
                }
            }
        }
    }
}

function TrueAlt
{
    parameter minValue to "false".

    //local Result to alt:radar - 31.04.
    local Result to alt:radar - 17.59.

    if minValue:typename = "Scalar" and Result < minValue {
        return minValue.
    }
    return Result.
}

function Resource
{
    parameter Tag, Res.

    local Amount to 0.
    local Capacity to 0.
    local TotalMass to 0.
    local Percentage to 0.

    for Tank in ship:partstagged(Tag)
    {
        for Fuel in Tank:resources
        {
            if Fuel:name = Res
            {
                set Amount to Amount + Fuel:amount.
                set TotalMass to TotalMass + Fuel:amount * Fuel:density * 1000.
                set Capacity to Capacity + Fuel:capacity.
            }
        }
    }

    if Capacity <> 0
    {
        set Percentage to Amount / Capacity * 100.
    }

    return lex
    (
        "Amount", Amount,
        "Mass", TotalMass,
        "Capacity", Capacity,
        "Per", Percentage
    ).
}

function ACC
{
    parameter Power to ship:availableThrust.

    local NormalACC to Power / ship:mass.

    local VerticalACC to Power * cos(180 - vAng(ship:velocity:surface, ship:up:vector)) / ship:mass.
    local HorizontalACC to Power * sin(180 - vAng(ship:velocity:surface, ship:up:vector)) / ship:mass.

    return list
    (
        NormalACC, //[0]
        VerticalACC, //[1]
        HorizontalACC //[2]
    ).
}

function ThrottleControl
{
    parameter Power, tgAlt, tgSpeed, Mag to 2.

    local LandACC to ACC(Power)[1] - body:mu / body:position:sqrmagnitude.
    local StopDist to (ship:verticalspeed^2 - tgSpeed^2) / (Mag * LandACC).

    return (StopDist + tgAlt) / TrueAlt(0.001).
}

function ImpactData
{
    parameter minError to 1.

    if not (defined impact_UTs_impactHeight) {global impact_UTs_impactHeight to 0.}

    local startTime to time:seconds.
    local craftOrbit to ship:orbit.
    local sma to craftOrbit:semimajoraxis.
    local ecc to craftOrbit:eccentricity.
    local craftTA to craftOrbit:trueanomaly.
    local orbitPeriod to craftOrbit:period.
    local ap to craftOrbit:apoapsis.
    local pe to craftOrbit:periapsis.
    local tillImpact to timeTA(ecc, orbitPeriod, craftTA, ALTtoTA(sma, ecc, ship:body, max(min(impact_UTs_impactHeight, ap - 1), pe + 1))[1]).
    local impactUTs to tillImpact + startTime.
    local bodyNorth to v(0, 1, 0).
    local rotationalDir to vDot(bodyNorth, ship:body:angularvel) * constant:radtodeg.
    local posLatLng to ship:body:geopositionof(positionAt(ship, impactUTs)).
    local timeDif to impactUTs - time:seconds.
    local longitudeShift to rotationalDir * timeDif.
    local newLng to mod(posLatLng:lng + longitudeShift, 360).
    if newLng < -180 {set newLng to newLng + 360.}
    if newLng > 180 {set newLng to newLng - 360.}
    local impactPos to latlng(posLatLng:lat, newLng).
    local newImpactHeight to impactPos:terrainheight.
    set impact_UTs_impactHeight to (impact_UTs_impactHeight + newImpactHeight) / 2.

    function ALTtoTA
    {
        parameter sma, ecc, bodyIn, altIn.

        local rad to altIn + bodyIn:radius.
        local TAofAlt to arcCos((-sma * ecc^2 + sma - rad) / (ecc * rad)).

        return list
        (
            TAofAlt,
            360 - TAofAlt
        ).
    }
    function timeTA
    {
        parameter ecc, periodIn, tgDeg1, tgDeg2.

        local maDeg1 to TAtoMA(ecc, tgDeg1).
        local maDeg2 to TAtoMA(ecc, tgDeg2).

        local timeDiff to periodIn * ((maDeg2 - maDeg1) / 360).

        return mod(timeDiff + periodIn, periodIn).
    }
    function TAtoMA
    {
        parameter ecc, taDeg.

        local eaDeg to arcTan2(sqrt(1 - ecc^2) * sin(taDeg), ecc + cos(taDeg)).
        local maDeg to eaDeg - (ecc * sin(eaDeg) * constant:radtodeg).

        return mod(maDeg + 360, 360).
    }

    return lex
    (
        "LatLng", impactPos,
        "time", impactUTs,
        "TillImpact", TillImpact,
        "height", impact_UTs_impactHeight,
        "converged", ((abs(impact_UTs_impactHeight - newImpactHeight) * 2) < minError)
    ).
}

function OP
{
    parameter tgt, Adj.

    return ship:body:geopositionof(tgt:position + Error(tgt, ship:geoPosition)[0] / Error(tgt, ship:geoPosition)[1] * Adj).
}

//Impact Error => Error(ImpactData()["LatLng"], [Target Latlng])
function Error
{
    parameter P1, P2.

    local ErrorVector to P1:position - P2:position.
    local ErrorDiff to sqrt((ErrorVector:Z)^2 + (ErrorVector:X)^2).
    local LatError to P1:lat - P2:lat.
    local LngError to P1:lng - P2:lng.

    return list(
        ErrorVector, //[0]
        ErrorDiff, //[1]
        LatError, //[2]
        LngError //[3]
    ).
}

//FacingError(tgSteer:vector)
function FacingError
{
    parameter Vec.

    return vAng(ship:facing:vector, Vec).
}

function Angle
{
    //Pitch
    local Pitch to 90 - arctan2(vdot(vcrs(ship:up:vector, ship:north:vector), facing:forevector), vdot(ship:up:vector, facing:forevector)).
    
    //Yaw
    local YawVec to vxcl(ship:facing:topvector, ship:velocity:surface).
    local Yaw to vAng(YawVec, ship:facing:forevector).
    if vdot(YawVec,ship:facing:starvector) < 0 {set Yaw to -vAng(YawVec, ship:facing:forevector).}

    //Roll
    local Roll to ship:facing:roll.
    if ship:facing:roll > 360 {set Roll to ship:facing:roll - 360.}

    return lex
    (
        "Pitch", Pitch,
        "Yaw", Yaw,
        "Roll", Roll
    ).
}

function SteeringPid
{
    parameter Aoa, Mag, Vel, Pos.

    local Result to (-Vel + Pos) * Mag.
    if vAng(Result, -Vel) > Aoa {set Result to -Vel:normalized + tan(Aoa) * Pos:normalized.}

    return lookDirUp(Result, facing:topvector).
}

function EngineMode
{
    parameter Tag, Mode. //"Shutdown" or "Active" or some mode

    local CurtMode to EngineList[Tag]["CurtMode"].
    local EngineStatus to EngineList[Tag]["Status"].

    local EngineModeList to EngineList[Tag]["Mode"].

    for Engine in ship:partsTagged(Tag)
    {
        set EngineFX to Engine:getmodule("ModuleEnginesFX").

        if Mode = "Shutdown"
        {
            if EngineStatus and EngineFX:hasevent("Shutdown Engine")
            {
                EngineFX:doevent("Shutdown Engine").
                set EngineList[Tag]["Status"] to false.
            }
        }
        else if Mode = "Active"
        {
            if not EngineStatus and EngineFX:hasevent("Activate Engine")
            {
                EngineFX:doevent("Activate Engine").
                set EngineList[Tag]["Status"] to true.
            }
        }
        else
        {
            if not EngineStatus and EngineFX:hasevent("Activate Engine")
            {
                EngineFX:doevent("Activate Engine").
                set EngineList[Tag]["Status"] to true.
            }

            if CurtMode <> Mode
            {
                if EngineModeList:length = 2 //Stock Engine Switch
                {
                    local EngineTE to Engine:getmodule("MultiModeEngine").

                    EngineTE:doevent("Next Engine Mode").
                }
                else if EngineModeList:length = 3 //Tundra Engine Switch
                {
                    local EngineTE to Engine:getmodule("ModuleTundraEngineSwitch").

                    if CurtMode = EngineModeList[0]
                    {
                        if Mode = EngineModeList[1] {EngineTE:doevent("Next Engine Mode").}
                        else                        {EngineTE:doevent("Previous Engine Mode").}
                    }
                    else if CurtMode = EngineModeList[1] {
                        if Mode = EngineModeList[2] {EngineTE:doevent("Next Engine Mode").}
                        else                        {EngineTE:doevent("Previous Engine Mode").}
                    }
                    else if CurtMode = EngineModeList[2] {
                        if Mode = EngineModeList[0] {EngineTE:doevent("Next Engine Mode").}
                        else                        {EngineTE:doevent("Previous Engine Mode").}
                    }
                }
            }

            set EngineList[Tag]["CurtMode"] to Mode.
            SaveFile(saveFileLocation, "EngineList", EngineList).
        }
    }
}
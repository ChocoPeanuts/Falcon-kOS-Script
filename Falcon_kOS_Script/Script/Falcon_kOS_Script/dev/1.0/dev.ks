//Falcon kOS Script Falcon 9 dev Ver 1.0

//------------------------------------------------------------------------

//Setup
runOncePath("0:/Falcon_kOS_Script/F9/1.0/F9_Library.ks").
//global saveFileLocation to "0:/Falcon_kOS_Script/F9/1.0/F9_SaveFile.json".

core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

set latlng1 to ship:geoposition.
set latlng2 to latlng(28.32617, -80.35055).

print Error(latlng1, latlng2)[1].
print Error(latlng1, MidLatLng(latlng1, latlng2))[1].

function MidLatLng
{
    parameter pos1, pos2.

    return ship:body:geoPositionof((pos1:position + pos2:position) / 2).
}
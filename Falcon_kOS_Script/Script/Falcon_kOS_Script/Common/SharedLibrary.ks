//Falcon kOS Script Library

//------------------------------------------------------------------------

global configFileLocation to "0:/Falcon_kOS_Script/saves/ConfigData.json".
global saveFileLocation to "0:/Falcon_kOS_Script/saves/FlightData.json".
global lzFileLocation to "0:/Falcon_kOS_Script/saves/LandingZoneData.json".

function runScript
{
    parameter fileEnd.

    local runVer to LoadFile(saveFileLocation, "fileVer", false).

    if runVer[0] = "dev"
    {
        runOncePath("0:/Falcon_kOS_Script/" + runVer[0] + "/" + runVer[1] + "/dev").
    }
    else
    {
        runOncePath("0:/Falcon_kOS_Script/" + runVer[0] + "/" + runVer[1] + "/" + fileEnd).
    }
}

function loadLZ
{
    parameter lzKey.

    local lzData to LoadFile(lzFileLocation, lzKey, false).

    return
    lex
    (
        "title", lzKey,
        "latlng", latlng(lzData["latlng"]:split(",")[0]:tonumber(), lzData["latlng"]:split(",")[1]:tonumber()),
        "alt", lzData["alt"],
        "type", lzData["type"],
        "capacity", lzData["capacity"]
    ).
}

function loadFlightData
{
    parameter cfgKey.

    local configData to LoadFile(configFileLocation, cfgKey, false).

    return lex
    (
        "title", configData["title"],
        
        "ap", configData["ap"],
        "pe", configData["pe"],
        "inc", configData["inc"],
        "lng", configData["lng"],
        "aop", configData["aop"],

        "fairing",
        list
        (
            configData["fairing"]:split(",")[0]:tonumber(),
            configData["fairing"]:split(",")[1]
        ),
        "vertAsc",
        list
        (
            configData["vertAsc"]:split(",")[0]:tonumber(),
            configData["vertAsc"]:split(",")[1]
        ),

        "CT", configData["CT"],
        "WDT", configData["WDT"],
        "IT", configData["IT"],

        "LZ",
        list
        (
            loadLZ(configData["LZ"][0]),
            loadLZ(configData["LZ"][1]),
            loadLZ(configData["LZ"][2]),
            loadLZ(configData["LZ"][3]),
            loadLZ(configData["LZ"][4])
        )
    ).
}

function SaveFile
{
    parameter File, Key, Value.

    local L to readJson(File).
    if L:hasKey(Key)
    {
        set L[Key] to Value.
    }
    else
    {
        L:add(Key, Value).
    }
    writeJson(L, File).
}

function LoadFile
{
    parameter File, Key, Value.

    local L to readJson(File).

    if Key:istype("boolean") and Key = false {return L.}

    if L:hasKey(Key) {return L[Key].}

    return Value.
}

function DeleteFile
{
    parameter File, Key.

    local L to readJson(File).
    
    if L:hasKey(Key)
    {
        L:remove(Key).
        writeJson(L, File).
    }
}
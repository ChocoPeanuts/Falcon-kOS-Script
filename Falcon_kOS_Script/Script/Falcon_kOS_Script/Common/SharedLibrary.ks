//Falcon kOS Script Library

//------------------------------------------------------------------------

function SaveFile
{
    parameter File, key, Value.

    local L to readJson(File).
    if L:haskey(key)
    {
        set L[key] to Value.
    }
    else
    {
        L:add(key, value).
    }
    writeJson(L, File).
}

function LoadFile
{
    parameter File, key to false.

    local L to readJson(File).

    if key:istype("boolean")
    {
        return L.
    }
    return L[key].
}

function DeleteFile
{
    parameter File, key.

    local L to readJson(File).
    
    L:remove(key).
    writeJson(L, File).
}
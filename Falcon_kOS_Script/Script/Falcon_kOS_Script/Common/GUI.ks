//Falcon kOS Script GUI

//------------------------------------------------------------------------

local mainGUI_width to 550.
local mainGUI_height to 630.

local lzGUI_width to 450.
local lzGUI_height to 315.

local flightGUI_width to 40.
local flightGUI_height to 40.

local lastLZgui_x to 10.
local lastLZgui_y to 40.

local popupMaxvisible to 5.

local lzEditLock to false.

function StartMainGUI
{
    global mainGUI to gui(mainGUI_width, mainGUI_height).
        set mainGUI:x to 10.
        set mainGUI:y to 40.
        //set mainGUI:style:width to mainGUI_width.
        //set mainGUI:style:height to mainGUI_height.
        set mainGUI:style:align to "center".

        global topSection to mainGUI:addhlayout().
            //set topSection:style:height to 35.
            //set topSection:style:margin:top to 0.

            global mainTitleBox to topSection:addhbox().
                set mainTitleBox:style:height to 35.
                set mainTitleBox:style:margin:v to 0.
                set mainTitle to mainTitleBox:addlabel("<b><size=20>Falcon kOS Script</size></b>").
                    set mainTitle:style:align to "center".

            global mainButtonSection to topSection:addhlayout().
                set mainButtonSection:style:width to 54.

                global minMainGUI to mainButtonSection:addbutton("-").
                    set minMainGUI:style:margin:h to 7.
                    set minMainGUI:style:margin:top to 0.
                    set minMainGUI:style:width to 20.
                    set minMainGUI:style:height to 20.
                    set minMainGUI:toggle to true.
                    set minMainGUI:ontoggle to
                    {
                        parameter pressed.
                        
                        if pressed
                        {
                            mainGUI:showonly(topSection).
                            set mainGUI:style:height to 50.
                        }
                        else
                        {
                            set mainGUI:style:height to mainGUI_height.
                            for widget in mainGUI:widgets
                            {
                                widget:show().
                            }
                        }
                    }.

                global closeMainGUI to mainButtonSection:addbutton("X").
                    set closeMainGUI:style:margin:h to 7.
                    set closeMainGUI:style:margin:top to 0.
                    set closeMainGUI:style:width to 20.
                    set closeMainGUI:style:height to 20.
                    set closeMainGUI:onclick to closeGUI@.
                    function closeGUI
                    {
                        mainGUI:dispose().
                        lzEditGUI:dispose().
                    }

        mainGUI:addspacing(6).

        global middleSection to mainGUI:addhlayout().
            //set middleSection:style:height to 40.

            global missionTitleInput to middleSection:addtextfield(ship:name).
                set missionTitleInput:style:fontsize to 25.
                set missionTitleInput:style:height to 40.
                set missionTitleInput:style:margin:v to 0.
                set missionTitleInput:style:align to "center".

        mainGUI:addspacing(6).

        global bottomSection to mainGUI:addhlayout().
            //set bottomSection:style:margin:top to 0.
            global leftSection to bottomSection:addvlayout().
                set leftSection:style:width to 265.

                global orbitalBox to leftSection:addvbox().
                    set orbitalTitle to orbitalBox:addlabel("<b><size=20>Orbital Maneuvering</size></b>").
                        set orbitalBox:style:align to "center".

                    global orbitalApSection to orbitalBox:addhlayout().
                        set orbitalApTitle to orbitalApSection:addlabel("<b><size=15>Ap</size></b>").
                            set orbitalApTitle:style:align to "center".

                        global orbitalApInput to orbitalApSection:addtextfield().
                            set orbitalApInput:style:fontsize to 15.
                            set orbitalApInput:style:width to 150.
                            set orbitalApInput:style:height to 30.

                        global orbitalApUnit to orbitalApSection:addhlayout().
                            set orbitalApUnit:style:margin:top to 10.
                            set orbitalApUnit:style:width to 30.
                            set orbitalApUnit:style:height to 20.
                            set orbitalApUnitTitle to orbitalApUnit:addlabel("<b><size=15>m</size></b>").
                                set orbitalApUnitTitle:style:align to "center".

                    orbitalBox:addspacing(6).

                    global orbitalPeSection to orbitalBox:addhlayout().
                        set orbitalPeTitle to orbitalPeSection:addlabel("<b><size=15>Pe</size></b>").
                            set orbitalPeTitle:style:align to "center".

                        global orbitalPeInput to orbitalPeSection:addtextfield().
                            set orbitalPeInput:style:fontsize to 15.
                            set orbitalPeInput:style:width to 150.
                            set orbitalPeInput:style:height to 30.

                        global orbitalPeUnit to orbitalPeSection:addhlayout().
                            set orbitalPeUnit:style:margin:top to 10.
                            set orbitalPeUnit:style:width to 30.
                            set orbitalPeUnit:style:height to 20.
                            set orbitalPeUnitTitle to orbitalPeUnit:addlabel("<b><size=15>m</size></b>").
                                set orbitalPeUnitTitle:style:align to "center".

                    orbitalBox:addspacing(6).

                    global orbitalIncSection to orbitalBox:addhlayout().
                        set orbitalIncTitle to orbitalIncSection:addlabel("<b><size=15>Inc</size></b>").
                            set orbitalIncTitle:style:align to "center".

                        global orbitalIncInput to orbitalIncSection:addtextfield().
                            set orbitalIncInput:style:fontsize to 15.
                            set orbitalIncInput:style:width to 150.
                            set orbitalIncInput:style:height to 30.

                        global orbitalIncUnit to orbitalIncSection:addhlayout().
                            set orbitalIncUnit:style:margin:top to 10.
                            set orbitalIncUnit:style:width to 30.
                            set orbitalIncUnit:style:height to 20.
                            set orbitalIncUnitTitle to orbitalIncUnit:addlabel("<b><size=15> </size></b>").
                                set orbitalIncUnitTitle:style:align to "center".

                    orbitalBox:addspacing(6).

                    global orbitalLngSection to orbitalBox:addhlayout().
                        set orbitalLngTitle to orbitalLngSection:addlabel("<b><size=15>Lng</size></b>").
                            set orbitalLngTitle:style:align to "center".

                        global orbitalLngInput to orbitalLngSection:addtextfield().
                            set orbitalLngInput:style:fontsize to 15.
                            set orbitalLngInput:style:width to 150.
                            set orbitalLngInput:style:height to 30.

                        global orbitalLngUnit to orbitalLngSection:addhlayout().
                            set orbitalLngUnit:style:margin:top to 10.
                            set orbitalLngUnit:style:width to 30.
                            set orbitalLngUnit:style:height to 20.
                            set orbitalLngUnitTitle to orbitalLngUnit:addlabel("<b><size=15> </size></b>").
                                set orbitalLngUnitTitle:style:align to "center".

                    orbitalBox:addspacing(6).

                    global orbitalAopSection to orbitalBox:addhlayout().
                        set orbitalAopTitle to orbitalAopSection:addlabel("<b><size=15>Aop</size></b>").
                            set orbitalAopTitle:style:align to "center".

                        global orbitalAopInput to orbitalAopSection:addtextfield().
                            set orbitalAopInput:style:fontsize to 15.
                            set orbitalAopInput:style:width to 150.
                            set orbitalAopInput:style:height to 30.

                        global orbitalAopUnit to orbitalAopSection:addhlayout().
                            set orbitalAopUnit:style:margin:top to 10.
                            set orbitalAopUnit:style:width to 30.
                            set orbitalAopUnit:style:height to 20.
                            set orbitalAopUnitTitle to orbitalAopUnit:addlabel("<b><size=15> </size></b>").
                                set orbitalAopUnitTitle:style:align to "center".

                    orbitalBox:addspacing(6).

                leftSection:addspacing(6).

                global landingBox to leftSection:addvbox().
                    global landingTitleSection to landingBox:addhlayout().
                        set landingTitle to landingTitleSection:addlabel("<b><size=20>Booster Recovery</size></b>").
                            set landingTitle:style:align to "center".

                        global editLZbutton to landingTitleSection:addbutton("Edit").
                            set editLZbutton:style:width to 50.
                            set editLZbutton:style:height to 30.
                            set editLZbutton:toggle to true.
                            set editLZbutton:ontoggle to
                            {
                                parameter pressed.

                                if pressed
                                {
                                    set lzEditGUI:x to lastLZgui_x.
                                    set lzEditGUI:y to lastLZgui_y.
                                    lzEditGUI:show().
                                }
                                else
                                {
                                    closeLZEditGUI().
                                }
                            }.

                    global booster_1 to landingBox:addhlayout().
                        set booster_1_title to booster_1:addlabel("<b><size=15>Core</size></b>").
                            set booster_1_title:style:align to "center".

                        global booster_1_lz to booster_1:addpopupmenu().
                            set booster_1_lz:style:width to 150.
                            set booster_1_lz:style:height to 30.

                    global booster_2 to landingBox:addhlayout().
                        set booster_2_title to booster_2:addlabel("<b><size=15>Side 1</size></b>").
                            set booster_2_title:style:align to "center".

                        global booster_2_lz to booster_2:addpopupmenu().
                            set booster_2_lz:style:width to 150.
                            set booster_2_lz:style:height to 30.

                    global booster_3 to landingBox:addhlayout().
                        set booster_3_title to booster_3:addlabel("<b><size=15>Side 2</size></b>").
                            set booster_3_title:style:align to "center".

                        global booster_3_lz to booster_3:addpopupmenu().
                            set booster_3_lz:style:width to 150.
                            set booster_3_lz:style:height to 30.

                    global booster_4 to landingBox:addhlayout().
                        set booster_4_title to booster_4:addlabel("<b><size=15>Side 3</size></b>").
                            set booster_4_title:style:align to "center".

                        global booster_4_lz to booster_4:addpopupmenu().
                            set booster_4_lz:style:width to 150.
                            set booster_4_lz:style:height to 30.

                    global booster_5 to landingBox:addhlayout().
                        set booster_5_title to booster_5:addlabel("<b><size=15>Side 4</size></b>").
                            set booster_5_title:style:align to "center".

                        global booster_5_lz to booster_5:addpopupmenu().
                            set booster_5_lz:style:width to 150.
                            set booster_5_lz:style:height to 30.

                    global lzEditGUI to gui(lzGUI_width, lzGUI_height).
                        set lzEditGUI:style:width to lzGUI_width.
                        set lzEditGUI:style:height to lzGUI_height.

                        global lzTopSection to lzEditGUI:addhlayout().
                            set lzTopSection:style:height to 35.
                            //set lzTopSection:style:margin:top to 0.

                            global lzEditTitleBox to lzTopSection:addhbox().
                                set lzEditTitleBox:style:margin:v to 0.
                                set lzEditTitle to lzEditTitleBox:addlabel("<b><size=20>Landing Zone Editor</size></b>").
                                    set lzEditTitle:style:align to "center".

                            global lzButtonSection to lzTopSection:addhlayout().
                                set lzButtonSection:style:width to 54.

                                global minLZGUI to lzButtonSection:addbutton("-").
                                    set minLZGUI:style:margin:h to 7.
                                    set minLZGUI:style:margin:top to 0.
                                    set minLZGUI:style:width to 20.
                                    set minLZGUI:style:height to 20.
                                    set minLZGUI:toggle to true.
                                    set minLZGUI:ontoggle to
                                    {
                                        parameter pressed.
                                                                
                                        if pressed
                                        {
                                            lzEditGUI:showonly(lzTopSection).
                                            set lzEditGUI:style:height to 50.
                                        }
                                        else
                                        {
                                            set lzEditGUI:style:height to lzGUI_height.
                                            for widget in lzEditGUI:widgets
                                            {
                                                widget:show().
                                            }
                                        }
                                    }.

                                global closeLZGUI to lzButtonSection:addbutton("X").
                                    set closeLZGUI:style:margin:h to 7.
                                    set closeLZGUI:style:margin:top to 0.
                                    set closeLZGUI:style:width to 20.
                                    set closeLZGUI:style:height to 20.
                                    set closeLZGUI:onclick to closeLZEditGUI@.
                                    function closeLZEditGUI
                                    {
                                        set lastLZgui_x to lzEditGUI:x.
                                        set lastLZgui_y to lzEditGUI:y.
                                        lzEditGUI:hide().

                                        set editLZbutton:pressed to false.
                                    }

                        lzEditGUI:addspacing(6).

                        global lzMainSection to lzEditGUI:addhlayout().
                            global lzLeftSection to lzMainSection:addvlayout().
                                set lzLeftSection:style:width to 250.

                                //lzLeftSection:addspacing(6).

                                global lzTitleBox to lzLeftSection:addhbox().
                                    set lzTitleTitle to lzTitleBox:addlabel("<b><size=15>Title</size></b>").
                                        set lzTitleTitle:style:align to "center".

                                    global lzTitleInput to lzTitleBox:addtextfield().
                                        set lzTitleInput:style:fontsize to 15.
                                        set lzTitleInput:style:width to 150.
                                        set lzTitleInput:style:height to 30.
                                        set lzTitleInput:onchange to
                                        {
                                            parameter input.
                                            
                                            if lzSelectData:index <> 0
                                            {
                                                set lzEditLock to true.
                                                set lzSelectData:index to 0.
                                            }
                                        }.

                                lzLeftSection:addspacing(6).

                                global lzLatLngSection to lzLeftSection:addvbox().
                                    global lzLatSection to lzLatLngSection:addhlayout().
                                        set lzLatTitle to lzLatSection:addlabel("<b><size=15>Lat</size></b>").
                                            set lzLatTitle:style:align to "center".

                                        global lzLatInput to lzLatSection:addtextfield().
                                            set lzLatInput:style:fontsize to 15.
                                            set lzLatInput:style:width to 150.
                                            set lzLatInput:style:height to 30.

                                        lzLatLngSection:addspacing(6).

                                        global lzLngSection to lzLatLngSection:addhlayout().
                                            set lzLngTitle to lzLngSection:addlabel("<b><size=15>Lng</size></b>").
                                            set lzLngTitle:style:align to "center".

                                            global lzLngInput to lzLngSection:addtextfield().
                                                set lzLngInput:style:fontsize to 15.
                                                set lzLngInput:style:width to 150.
                                                set lzLngInput:style:height to 30.

                                lzLeftSection:addspacing(6).

                                global lzAltBox to lzLeftSection:addhbox().
                                    set lzAltTitle to lzAltBox:addlabel("<b><size=15>Altitude</size></b>").
                                        set lzAltTitle:style:align to "center".

                                    global lzAltInput to lzAltBox:addtextfield().
                                        set lzAltInput:style:fontsize to 15.
                                        set lzAltInput:style:width to 150.
                                        set lzAltInput:style:height to 30.

                                lzLeftSection:addspacing(6).

                                global lzTypeBox to lzLeftSection:addhbox().
                                    set lzTypeTitle to lzTypeBox:addlabel("<b><size=15>Type</size></b>").
                                        set lzTypeTitle:style:align to "center".

                                    global lzTypeToggle to lzTypeBox:addbutton("<b><size=15>RTLS</size></b>").
                                        set lzTypeToggle:style:height to 30.
                                        set lzTypeToggle:style:width to 150.
                                        set lzTypeToggle:onclick to
                                        {
                                            if lzTypeToggle:text = "<b><size=15>RTLS</size></b>"
                                            {
                                                set lzTypeToggle:text to "<b><size=15>ASDS</size></b>".
                                            }
                                            else
                                            {
                                                set lzTypeToggle:text to "<b><size=15>RTLS</size></b>".
                                            }
                                        }.

                                lzLeftSection:addspacing(6).

                                global lzCapBox to lzLeftSection:addhbox().
                                    set lzCapTitle to lzCapBox:addlabel("<b><size=15>Capacity</size></b>").
                                        set lzCapTitle:style:align to "center".

                                    global lzCapInput to lzCapBox:addtextfield().
                                        set lzCapInput:style:fontsize to 15.
                                        set lzCapInput:style:width to 150.
                                        set lzCapInput:style:height to 30.

                                lzLeftSection:addspacing(6).

                            global lzRightSection to lzMainSection:addvlayout().
                                //lzRightSection:addspacing(6).

                                global lzSelectData to lzRightSection:addpopupmenu().
                                    set lzSelectData:style:height to 30.

                                    lzDataUpdate(true).
                                    set lzSelectData:index to 0.
                                    set lzSelectData:onchange to
                                    {
                                        parameter selected.
                                        local selectedIndex to lzSelectData:index.
                                        if selectedIndex = 0
                                        {
                                            lzDeleteButton:hide().

                                            if lzEditLock
                                            {
                                                set lzEditLock to false.
                                                return.
                                            }
                                            lzEditInput().
                                        }
                                        else
                                        {
                                            lzDeleteButton:show().
                                            lzEditInput(selected).
                                        }
                                    }.

                                lzRightSection:addspacing(190).

                                global lzDeleteSaveSection to lzRightSection:addhlayout().
                                    global lzDeleteSection to lzDeleteSaveSection:addhlayout().
                                        global lzDeleteButton to lzDeleteSection:addbutton("<b><size=15>Delete</size></b>").
                                            set lzDeleteButton:style:width to 50.
                                            set lzDeleteButton:style:height to 30.
                                            set lzDeleteButton:onclick to
                                            {
                                                DeleteFile(lzFileLocation, lzSelectData:value).
                                                lzDataUpdate().
                                                set lzSelectData:index to 0.
                                            }.

                                            lzDeleteButton:hide().

                                    global lzSaveButton to lzDeleteSaveSection:addbutton("<b><size=15>Save</size></b>").
                                        set lzSaveButton:style:width to 50.
                                        set lzSaveButton:style:height to 30.

                                        set lzSaveButton:onclick to
                                        {
                                            local saveLZtitle to lzTitleInput:text.
                                            local saveLZlat to lzLatInput:text:tonumber(-9999).
                                            local saveLZlng to lzLngInput:text:tonumber(-9999).
                                            local saveLZalt to lzAltInput:text:tonumber(-9999).
                                            local saveLZtype to 0.
                                            local saveLZcap to lzCapInput:text:tonumber(-9999).
                                            if lzTypeToggle:text = "<b><size=15>RTLS</size></b>"
                                            {
                                                set saveLZtype to "rtls".
                                            }
                                            else
                                            {
                                                set saveLZtype to "asds".
                                            }

                                            if  saveLZlat = -9999 or
                                                saveLZlng = -9999 or
                                                saveLZalt = -9999 or
                                                saveLZcap = -9999
                                            {
                                                hudtext("Only half-width numbers are allowed", 5, 2, 30, red, false).
                                                return.
                                            }

                                            local saveLZlist to lex
                                            (
                                                "latlng", saveLZlat + "," + saveLZlng + "," + ship:body:name,
                                                "alt", saveLZalt,
                                                "type", saveLZtype,
                                                "capacity", saveLZcap
                                            ).

                                            SaveFile(lzFileLocation, saveLZtitle , saveLZlist).
                                            lzDataUpdate().
                                            //set lzSelectData:index to lzList:length - 1.
                                            set lzSelectData:index to lzSelectData:options:indexof(saveLZtitle).
                                        }.

            global rightSection to bottomSection:addvlayout().
                set rightSection:style:width to 265.

                global configBox to rightSection:addvbox().
                    set configTitle to configBox:addlabel("<b><size=20>Configuration</size></b>").
                        set configTitle:style:align to "center".

                    global verSection to configBox:addhlayout().
                        set verTitle to verSection:addlabel("<b><size=15>Script Version</size></b>").
                            set vertitle:style:align to "center".

                        global verSelect to verSection:addpopupmenu().
                            set verSelect:style:width to 150.
                            set verSelect:style:height to 30.

                        set verOptions to list().
                            cd ("0:/Falcon_kOS_Script/F9/").
                            list files in f9Files.
                            cd ("0:/Falcon_kOS_Script/FH/").
                            list files in fhFiles.
                            cd ("0:/Falcon_kOS_Script/FSH/").
                            list files in fshFiles.
                            cd ("0:/Falcon_kOS_Script/dev/").
                            list files in testFiles.
                            cd ("0:/").

                            for f9 in f9Files
                            {
                                verOptions:add("F9: ver" + f9).
                            }
                            for fh in fhFiles
                            {
                                verOptions:add("FH: ver" + fh).
                            }
                            for fsh in fshFiles
                            {
                                verOptions:add("FSH: ver" + fsh).
                            }
                            for test in testFiles
                            {
                                verOptions:add("dev: ver" + test).
                            }

                            if Identifier[0] = "F9" {set autoVer to f9Files:length - 1.}
                            else if Identifier[0] = "FH" {set autoVer to f9Files:length + fhFiles:length - 1.}
                            else if Identifier[0] = "FSH" {set autoVer to f9Files:length + fhFiles:length + fshFiles:length - 1.}
                            else {set autoVer to f9Files:length + fhFiles:length + fshFiles:length + testFiles:length - 1.}
                            
                            set verSelect:options to verOptions.
                            set verSelect:index to autoVer.

                    configBox:addspacing(5).

                    global configSaveBox to configBox:addvbox().
                        set configSaveBox:style:height to 113.

                        global configSaveTitleSection to configSaveBox:addhlayout().
                            set configSaveTitle to configSaveTitleSection:addlabel("<b><size=20>Config Saves</size></b>").
                                set configSaveTitle:style:align to "center".

                        global saveData to configSaveBox:addpopupmenu().
                            set saveData:style:height to 30.

                            set saveData:onchange to
                            {
                                parameter selected.
                                if saveData:index = 0
                                {
                                    deleteButton:hide().
                                }
                                else
                                {
                                    deleteButton:show().
                                }
                            }.

                            set saveData:options to LoadFile(configFileLocation, false, false):Keys.
                            set saveData:index to 0.

                        global SaveLoadDeleteSection to configSaveBox:addhlayout().

                            global deleteSaveSection to SaveLoadDeleteSection:addhlayout().
                                global deleteSection to deleteSaveSection:addhlayout().
                                    global deleteButton to deleteSection:addbutton("<b><size=15>Delete</size></b>").
                                        set deleteButton:style:width to 50.
                                        set deleteButton:style:height to 30.
                                        deleteButton:hide().

                                        set deleteButton:onclick to
                                        {
                                            DeleteFile(configFileLocation, saveData:value).
                                            set saveData:options to LoadFile(configFileLocation, false, false):Keys.
                                            set saveData:index to 0.
                                        }.

                                global saveButton to deleteSaveSection:addbutton("<b><size=15>Save</size></b>").
                                    set saveButton:style:width to 50.set saveButton:style:height to 30.

                                    set saveButton:onclick to
                                    {
                                        saveConfig(missionTitleInput:text).
                                        set saveData:options to LoadFile(configFileLocation, false, false):Keys.
                                    }.

                            global loadButton to SaveLoadDeleteSection:addbutton("<b><size=15>Load</size></b>").
                                set loadButton:style:width to 50.
                                set loadButton:style:height to 30.

                                set loadButton:onclick to
                                {
                                    loadConfig(saveData:value).
                                }.

                    configBox:addspacing(4).

                rightSection:addspacing(6).

                global eventBox to rightSection:addvbox().
                    set eventTitle to eventBox:addlabel("<b><size=20>Events</size></b>").
                        set eventTitle:style:align to "center".

                    global fairing to eventBox:addhlayout().
                        set fairing:style:height to 40.

                        set fairingTitle to fairing:addlabel("<b><size=15>Fairing Separation</size></b>").
                            set fairingTitle:style:align to "center".
                            set fairingTitle:style:margin:v to 0.

                        global fairingInput to fairing:addtextfield().
                            set fairingInput:style:fontsize to 15.
                            set fairingInput:style:width to 100.
                            set fairingInput:style:height to 30.

                        global fairingUnitButton to fairing:addbutton("<b><size=15>m</size></b>").
                            set fairingUnitButton:style:width to 40.
                            set fairingUnitButton:style:height to 25.
                            set fairingUnitButton:style:margin:top to 10.

                            set fairingUnit to "m".
                            set fairingUnitButton:onclick to
                            {
                                if fairingUnit = "m"
                                {
                                    set fairingUnitButton:text to "<b><size=15>atm</size></b>".
                                    set fairingUnit to "atm".
                                }
                                else
                                {
                                    set fairingUnitButton:text to "<b><size=15>m</size></b>".
                                    set fairingUnit to "m".
                                }
                            }.

                    eventBox:addspacing(7).

                    global vertAsc to eventBox:addhlayout().
                        set vertAsc:style:height to 40.

                        set vertAscTitle to vertAsc:addlabel("<b><size=15>Pitchover Maneuver</size></b>").
                            set vertAscTitle:style:align to "center".
                            set vertAscTitle:style:margin:v to 0.

                        global vertAscInput to vertAsc:addtextfield().
                            set vertAscInput:style:fontsize to 15.
                            set vertAscInput:style:width to 100.
                            set vertAscInput:style:height to 30.

                        global vertAscUnitButton to vertAsc:addbutton("<b><size=15>m</size></b>").
                            set vertAscUnitButton:style:width to 40.
                            set vertAscUnitButton:style:height to 25.
                            set vertAscUnitButton:style:margin:top to 10.

                            set vertAscUnit to "m".
                            set vertAscUnitButton:onclick to
                            {
                                if vertAscUnit = "m"
                                {
                                    set vertAscUnitButton:text to "<b><size=15>m/s</size></b>".
                                    set vertAscUnit to "m/s".
                                }
                                else
                                {
                                    set vertAscUnitButton:text to "<b><size=15>m</size></b>".
                                    set vertAscUnit to "m".
                                }
                            }.

                    eventBox:addspacing(7).

                    global CountDown to eventBox:addhlayout().
                        set CountDown:style:height to 40.

                        set CountDownTitle to CountDown:addlabel("<b><size=15>Countdown Seconds</size></b>").
                            set CountDownTitle:style:align to "center".
                            set CountDownTitle:style:margin:v to 0.

                        global CountDownInput to CountDown:addtextfield().
                            set CountDownInput:style:fontsize to 15.
                            set CountDownInput:style:width to 100.
                            set CountDownInput:style:height to 30.

                        global CountDownUnit to CountDown:addhlayout().
                            set CountDownUnit:style:width to 43.
                            set CountDownUnit:style:height to 25.
                            set CountDownUnit:style:margin:top to 10.

                            set CountDownUnitTitle to CountDownUnit:addlabel("<b><size=15>s</size></b>").
                                set CountDownUnitTitle:style:align to "center".

                    eventBox:addspacing(7).

                    global WaterDeluge to eventBox:addhlayout().
                        set WaterDeluge:style:height to 40.

                        set WaterDelugeTitle to WaterDeluge:addlabel("<b><size=15>Water Deluge Activate</size></b>").
                            set WaterDelugeTitle:style:align to "center".
                            set WaterDelugeTitle:style:margin:v to 0.

                        global WaterDelugeInput to WaterDeluge:addtextfield().
                            set WaterDelugeInput:style:fontsize to 15.
                            set WaterDelugeInput:style:width to 100.
                            set WaterDelugeInput:style:height to 30.

                        global WaterDelugeUnit to WaterDeluge:addhlayout().
                            set WaterDelugeUnit:style:width to 43.
                            set WaterDelugeUnit:style:height to 25.
                            set WaterDelugeUnit:style:margin:top to 10.

                            set WaterDelugeUnitTitle to WaterDelugeUnit:addlabel("<b><size=15>T-s</size></b>").
                                set WaterDelugeUnitTitle:style:align to "center".

                    eventBox:addspacing(7).

                    global Ignition to eventBox:addhlayout().
                        set Ignition:style:height to 40.

                        set IgnitionTitle to Ignition:addlabel("<b><size=15>Ignition Sequence</size></b>").
                            set IgnitionTitle:style:align to "center".
                            set IgnitionTitle:style:margin:v to 0.

                        global IgnitionInput to Ignition:addtextfield().
                            set IgnitionInput:style:fontsize to 15.
                            set IgnitionInput:style:width to 100.
                            set IgnitionInput:style:height to 30.

                        global IgnitionUnit to Ignition:addhlayout().
                            set IgnitionUnit:style:width to 43.
                            set IgnitionUnit:style:height to 25.
                            set IgnitionUnit:style:margin:top to 10.

                            set IgnitionUnitTitle to IgnitionUnit:addlabel("<b><size=15>T-s</size></b>").
                                set IgnitionUnitTitle:style:align to "center".

                    eventBox:addspacing(9).

            mainGUI:addspacing(6).

            global startButton to mainGUI:addbutton("<b><size=30>Start Mission</size></b>").
            set startButton:style:margin:top to 0.
            set startButton:style:margin:h to 10.
            set startButton:style:height to 50.

            set startButton:onclick to
            {
                if saveConfig("Auto Save", true)
                {
                    SaveFile(saveFileLocation, "fileVer",
                        list
                        (
                            verSelect:value:split(":")[0],
                            verSelect:value:split("ver")[1]
                        )
                    ).
                    closeGUI().
                    set GoForLaunch to true.
                }
            }.

    loadConfig("Auto Save").
    mainGUI:show().
}

function saveConfig
{
    parameter Key, autoSave to false.

    if Key = "Auto Save" and not autoSave
    {
        hudtext("Overwriting AutoSave is not allowed", 5, 2, 30, red, false).
        return false.
    }

    local saveAp to orbitalApInput:text:tonumber(-9999).
    local savePe to orbitalPeInput:text:tonumber(-9999).
    local saveInc to orbitalIncInput:text:tonumber(-9999).
    local saveLng to orbitalLngInput:text:tonumber(-9999).
    local saveAop to orbitalAopInput:text:tonumber(-9999).
    local saveFairing to fairingInput:text:tonumber(-9999).
    local saveVertasc to vertAscInput:text:tonumber(-9999).
    local saveCT to CountDownInput:text:tonumber(-9999).
    local saveWDT to WaterDelugeInput:text:tonumber(-9999).
    local saveIT to ignitionInput:text:tonumber(-9999).
    local saveLZ to list(booster_1_lz:value,
                         booster_2_lz:value,
                         booster_3_lz:value,
                         booster_4_lz:value,
                         booster_5_lz:value).

    if  saveAp = -9999 or
        savePe = -9999 or
        saveInc = -9999 or
        saveLng = -9999 or
        saveAop = -9999 or
        saveFairing = -9999 or
        saveVertasc = -9999 or
        saveCT = -9999 or
        saveWDT = -9999 or
        saveIT = -9999
    {
        hudtext("Only half-width numbers are allowed", 5, 2, 30, red, false).

        return false.
    }

    if (loadLZ(saveLZ[1])["type"] <> loadLZ(saveLZ[2])["type"]) or (loadLZ(saveLZ[3])["type"] <> loadLZ(saveLZ[4])["type"])
    {
        hudtext("LZ-1 and LZ-2, LZ-3 and LZ-4 must be the same type", 5, 2, 30, red, false).
        return false.
    }

    from {local i to 1.}
    until i > 4
    step {set i to i + 1.}
    do
    {
        from {local j to i + 1.}
        until j > 4
        step {set j to j + 1.}
        do
        {
            if saveLZ[i] <> "Expendable" and saveLZ[i] = saveLZ[j]
            {
                hudtext("Multiple boosters on the same landing zone", 5, 2, 30, red, false).
                return false.
            }
        }
    }

    SaveFile(configFileLocation, Key,
        lex
        (
            "title", missionTitleInput:text,

            "ap", saveAp,
            "pe", savePe,
            "inc", saveInc,
            "lng", saveLng,
            "aop", saveAop,
            
            "fairing", saveFairing + "," + fairingUnit,
            "vertAsc", saveVertasc + "," + vertAscUnit,

            "CT", saveCT,
            "WDT", saveWDT,
            "IT", saveIT,

            "LZ", saveLZ
        )
    ).

    return true.
}

function loadConfig
{
    parameter Key.

    local loadData to LoadFile(configFileLocation, Key, false).

    if Key <> "Auto Save" {set missionTitleInput:text to LoadData["title"].}

    set orbitalApInput:text to loadData["ap"]:tostring().
    set orbitalPeInput:text to loadData["pe"]:tostring().
    set orbitalIncInput:text to loadData["inc"]:tostring().
    set orbitalLngInput:text to loadData["lng"]:tostring().
    set orbitalAopInput:text to loadData["aop"]:tostring().

    lzSelectUpdate(loadData["LZ"]).

    set fairingInput:text to loadData["fairing"]:split(",")[0].
    if loadData["fairing"]:split(",")[1] = "m"
    {
        set fairingUnitButton:text to "<b><size=15>m</size></b>".
        set fairingUnit to "m".
    }
    else
    {
        set fairingUnitButton:text to "<b><size=15>atm</size></b>".
        set fairingUnit to "atm".
    }
    set vertAscInput:text to LoadData["vertAsc"]:split(",")[0].
    if LoadData["vertAsc"]:split(",")[1] = "m"
    {
        set vertAscUnitButton:text to "<b><size=15>m</size></b>".
        set vertAscUnit to "m".
    }
    else
    {
        set vertAscUnitButton:text to "<b><size=15>m/s</size></b>".
        set vertAscUnit to "m/s".
    }
    set CountDownInput:text to loadData["CT"]:tostring().
    set WaterDelugeInput:text to loadData["WDT"]:tostring().
    set IgnitionInput:text to loadData["IT"]:tostring().
}

function lzDataUpdate
{
    parameter start to false.

    local lzList to LoadFile(lzFileLocation, false, false).
    local lzListKeys to lzList:keys.

    local selectedLZ to list
    (
        booster_1_lz:value,
        booster_2_lz:value,
        booster_3_lz:value,
        booster_4_lz:value,
        booster_5_lz:value
    ).

    local lzSelectList to list().
    for T in lzListKeys
    {
        local L to lzList[T].
        if L["latlng"]:split(",")[2] = "AnyBody" or L["latlng"]:split(",")[2] = ship:body:name
        {
            lzSelectList:add(T).
        }
    }
    //print lzSelectList.
    set booster_1_lz:options to lzSelectList.
    set booster_2_lz:options to lzSelectList.
    set booster_3_lz:options to lzSelectList.
    set booster_4_lz:options to lzSelectList.
    set booster_5_lz:options to lzSelectList.

    if not start {lzSelectUpdate(selectedLZ).}

    lzListKeys:remove(0).
    lzListKeys:insert(0, "-Save New-").
    lzSelectData:clear().
    set lzSelectData:options to lzListKeys.
}

function lzSelectUpdate
{
    parameter lzSelected.

    set booster_1_lz:index to max(0, booster_1_lz:options:indexof(lzSelected[0])).
    set booster_2_lz:index to max(0, booster_2_lz:options:indexof(lzSelected[1])).
    set booster_3_lz:index to max(0, booster_3_lz:options:indexof(lzSelected[2])).
    set booster_4_lz:index to max(0, booster_4_lz:options:indexof(lzSelected[3])).
    set booster_5_lz:index to max(0, booster_5_lz:options:indexof(lzSelected[4])).
}

function lzEditInput
{
    parameter Key to false.

    if Key = false //reset
    {
        set lzTitleInput:text to "".
        set lzLatInput:text to "".
        set lzLngInput:text to "".
        set lzAltInput:text to "".
        set lzTypeToggle:text to "<b><size=15>RTLS</size></b>".
        set lzCapInput:text to "".
    }
    else
    {
        local editLZ to LoadFile(lzFileLocation, Key, false).

        set lzTitleInput:text to Key.
        set lzLatInput:text to editLZ["latlng"]:split(",")[0].
        set lzLngInput:text to editLZ["latlng"]:split(",")[1].
        set lzAltInput:text to editLZ["alt"]:tostring().
        if editLZ["type"] = "rtls"
        {
            set lzTypeToggle:text to "<b><size=15>RTLS</size></b>".
        }
        else
        {
            set lzTypeToggle:text to "<b><size=15>ASDS</size></b>".
        }
        set lzCapInput:text to editLZ["capacity"]:tostring().
    }
}

function StartFlightGUI
{
    global flightGUI to gui(flightGUI_width, flightGUI_height).
}
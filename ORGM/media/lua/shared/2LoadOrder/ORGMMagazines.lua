--[[- Magazine Functions

This file contains functions for dealing with magazines and their data.


@module ORGM.Magazine
@author Fenris_Wolf
@release 3.09
@copyright 2018 **File:** shared/2LoadOrder/ORGMMagazines.lua
]]

local ORGM = ORGM
local Magazine = ORGM.Magazine
local getTableData = ORGM.getTableData

local ZombRand = ZombRand


local MagazineTable = { }
local MagazineKeyTable = { }

--[[- Registers a magazine type with ORGM.

This must be called before any firearm registers that plan to use that magazine.

@tparam string name name of the magazine without module prefix
@tparam table magazineData table containing the magazine data.

    Valid table keys/value pairs are:

    moduleName = nil | string, module name this item is from. If nil, ORGM is used

    ammoType = string, the name of a ammo AmmoGroup (not real ammo name)

    reloadTime = nil | integer, if nil then ORGM.Settings.DefaultMagazineReoadTime is used

    maxCapacity = int, the max amount of bullets this magazine can hold

    ejectSound = nil | string, the string name of a sound file. If nil 'ORGMMagLoad' is used

    insertSound = nil | string, the string name of a sound file. If nil 'ORGMMagLoad' is used

@treturn bool true on success.

]]
Magazine.register = function(name, magazineData)
    --ORGM.log(ORGM.DEBUG, "Attempting to register magazine ".. name)

    if ORGM.validateRegister(name, magazineData, MagazineTable) == false then
        return false
    end

    magazineData.moduleName = magazineData.moduleName or 'ORGM'
    magazineData.type = name
    magazineData.clipType = name
    magazineData.reloadClass = "ISORGMMagazine"
    magazineData.shootSound = 'none'
    magazineData.clickSound = nil
    magazineData.ejectSound = magazineData.ejectSound or 'ORGMMagLoad'
    magazineData.insertSound = magazineData.insertSound or 'ORGMMagLoad'
    magazineData.rackSound = magazineData.rackSound or 'ORGMMagLoad' -- TODO: can probably remove this one, cant rack anyways
    ORGM.Sounds.add(magazineData.ejectSound)
    ORGM.Sounds.add(magazineData.insertSound)
    ORGM.Sounds.add(magazineData.rackSound) -- TODO: can probably remove this one
    magazineData.reloadTime =  magazineData.reloadTime or ORGM.Settings.DefaultMagazineReoadTime

    MagazineTable[name] = magazineData
    ReloadUtil:addMagazineType(magazineData)
    table.insert(MagazineKeyTable, name)

    ORGM.log(ORGM.DEBUG, "Registered magazine " .. magazineData.moduleName .. "." .. name)
    return true
end


--[[- Deregisters a magazine from ORGM

WARNING: Incomplete code, do not use.

@tparam string name name of the magazine to deregister.

@treturn bool true on success

]]
Magazine.deregister = function(name)
    if MagazineTable[name] == nil then
        ORGM.log(ORGM.WARN, "Failed to deregister " .. name .. " (Item not previously registered)")
        return false
    end
    -- TODO: ensure this magazine is not set as the ammoType for any firearm, and error if it is.
    MagazineTable[name] = nil
    ORGM.tableRemove(MagazineKeyTable, name)
    return true
end


--[[- Returns the name of a random magazine item.

@tparam[opt] table thisTable table to select from.

@treturn string the random magazine name.

]]
Magazine.random = function(thisTable)
    if not thisTable then thisTable = MagazineKeyTable end
    return thisTable[ZombRand(#thisTable) +1]
end


--[[- Gets the table of registered magazines.

@treturn table all registered magazines setup by `ORGM.Magazine.register`

]]
Magazine.getTable = function()
    return MagazineTable
end


--[[- Gets the data of a registered magazine, supports module checking.

@tparam string|InventoryItem itemType
@tparam[opt] string moduleName module to compare

@treturn nil|table data of a registered magazine setup by `ORGM.Magazine.register`

]]
Magazine.getData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", MagazineTable)
end


--[[- Checks if a item is a ORGM magazine.

@tparam string|InventoryItem itemType
@tparam[opt] string moduleName module to compare

@treturn bool true if it is a ORGM registered magazine

]]
Magazine.isMagazine = function(itemType, moduleName)
    if Magazine.getData(itemType, moduleName) then return true end
    return false
end


--[[- Sets up a magazine, applying key/values into the items modData.

This should be called whenever a magazine is spawned.

Basically the same as ReloadUtil:setupMagazine and ISORGMMagazine:setupReloadable
but called without needing a player or reloadable object.

@tparam table magData return value of `ORGM.Magazine.getData`
@tparam InventoryItem magItem

]]
Magazine.setup = function(magData, magItem)
    --local magData = ReloadUtil:getClipData(magazineType)
    local modData = magItem:getModData()
    modData.type = magData.type
    modData.moduleName = magData.moduleName
    modData.reloadClass = magData.reloadClass
    modData.ammoType = magData.ammoType
    modData.loadStyle = magData.reloadStyle
    modData.ejectSound = magData.ejectSound
    modData.clickSound = magData.clickSound
    modData.insertSound = magData.insertSound
    modData.rackSound = magData.rackSound
    modData.maxCapacity = magData.maxCapacity or magItem:getClipSize() -- magItem: calls are pointless, this data isnt in the script
    modData.reloadTime = magData.reloadTime or magItem:getReloadTime() -- magItem: calls are pointless, this data isnt in the script
    modData.rackTime = magData.rackTime
    modData.currentCapacity = 0
    modData.clipType = magData.clipType
    modData.magazineData = { }
    modData.preferredAmmoType = 'any'
    modData.loadedAmmo = nil
    modData.BUILD_ID = ORGM.BUILD_ID
end


--[[- Finds the best matching magazine in a container.

Search is based on the given magazine name and preferred load
(can be specific round name, nil/any, or mixed), and the currentCapacity.

This is called when reloading some guns and all magazines.

Note magType and ammoType should NOT have the "ORGM." prefix.

@tparam string magType name of a magazine
@tparam nil|string ammoType 'any', 'mixed' or a specific ammo name
@tparam ItemContainer containerItem

@treturn nil|InventoryItem

]]
Magazine.findIn = function(magType, ammoType, containerItem)
    if magType == nil then return nil end
    local magData = MagazineTable[magType]
    if not magData then return nil end -- not a valid orgm mag
    if containerItem == nil then return nil end -- forgot the container item!
    if ammoType == nil then ammoType = 'any' end
    local bestMagazine = nil
    local mostAmmo = -1
    -- TODO: this needs a extra loop here, for possible alternate magazines
    local items = containerItem:getItemsFromType(magType)

    for i = 0, items:size()-1 do repeat
        local currentItem = items:get(i)
        local modData = currentItem:getModData()
        if modData.currentCapacity == nil then -- magazine needs to be setup
            Magazine.setup(magData, currentItem)
        end
        if modData.currentCapacity <= mostAmmo then
            break
        end

        if ammoType ~= 'any' and ammoType ~= modData.loadedAmmo then
            break
        end
        bestMagazine = currentItem
        mostAmmo = modData.currentCapacity
    until true end
    return bestMagazine
end

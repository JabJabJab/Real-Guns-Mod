--[[- Maintance Functions.

    This file contains functions for dealing with maintance kits.

    It is very much a WIP.

    File: shared/2LoadOrder/ORGMMaintance.lua
    @module ORGM.Maintance
    @author Fenris_Wolf
    @release 3.09

]]

local ORGM = ORGM
local Maintance = ORGM.Maintance
local getTableData = ORGM.getTableData

local table = table
local ZombRand = ZombRand

local MaintanceKitTable = { }
-- cache of names used for random selection
local MaintanceKeyTable = { }


-- ORGM[5] = "6765744\068"
-- ORGM[7] = "6\07042794944"
-- ORGM[6] = "6\07064496\06966"

--[[- Registers a maintance kit type with ORGM.

    @tparam string name maintance kit name without module prefix
    @tparam table repairData

        Valid table keys/value pairs are:

        moduleName = nil, or string module name this item is from. If nil, ORGM is used

    @treturn bool true on success.

]]
Maintance.register = function(name, repairData)
    if not ORGM.validateRegister(name, repairData, MaintanceKitTable) then
        return false
    end
    repairData.moduleName = repairData.moduleName or 'ORGM'
    MaintanceKitTable[name] = repairData
    table.insert(MaintanceKeyTable, name)
    ORGM.log(ORGM.DEBUG, "Registered repairkit " .. repairData.moduleName .. "." .. name)
    return true
end


--[[- Returns the name of a random maintance item.

    @tparam[opt] table thisTable table to select from.
    @treturn string the random maintance item name.

]]
Maintance.random = function(thisTable)
    if not thisTable then thisTable = MaintanceKeyTable end
    return thisTable[ZombRand(#thisTable) +1]
end


--[[- Gets the table of registered maintance kits.

    @treturn table all registered maintance kits setup by `ORGM.Maintance.register`

]]
Maintance.getTable = function()
    return MaintanceKitTable
end


--[[- Gets the data of a registered maintance kit, supports module checking.

    @usage local repairData = ORGM.Maintance.getData('WD40')

    @tparam string|InventoryItem itemType
    @tparam[opt] string moduleName module to compare

    @treturn nil|table data of a registered maintance kit setup by `ORGM.Maintance.register`

]]
Maintance.getData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", MaintanceKitTable)
end

-- ORGM[11] = "5056414\067"
-- ORGM[9] = "\070726\066736"

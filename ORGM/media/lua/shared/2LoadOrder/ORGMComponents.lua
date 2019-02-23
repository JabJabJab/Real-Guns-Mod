--[[- Component Functions

This file handles functions dealing with components and attachments.


@module ORGM.Component
@copyright 2018 **File:** shared/2LoadOrder/ORGMComponents.lua
@author Fenris_Wolf
@release 3.09

]]
local ORGM = ORGM
local Component = ORGM.Component
local Firearm = ORGM.Firearm
local getTableData = ORGM.getTableData

local table = table
local pairs = pairs
local ZombRand = ZombRand


-- pull this one into local namespace due to high volume of access
local ComponentTable = { }
-- cache of names used for random selection
local ComponentKeyTable = { }

--[[- Registers a component/attachment type with ORGM.

@tparam string name name without module prefix.
@tparam table compData

Valid table keys/value pairs are:
* moduleName = nil|string, module name this item is from. If nil, ORGM is used

@treturn bool true on success.

]]
Component.register = function(name, compData)
    if not ORGM.validateRegister(name, compData, ComponentTable) then
        return false
    end
    compData.moduleName = compData.moduleName or 'ORGM'
    ComponentTable[name] = compData
    table.insert(ComponentKeyTable, name)
    compData.instance = InventoryItemFactory.CreateItem(compData.moduleName..'.' .. name)
    ORGM.log(ORGM.DEBUG, "Component: Registered " .. compData.moduleName .. "." .. name)
    return true
end


--[[- Deregisters a component with ORGM.

@tparam string name name of the component.

@treturn bool true on success

]]
Component.deregister = function(name)
    if ComponentTable[name] == nil then
        ORGM.log(ORGM.WARN, "Component: Failed to deregister " .. name .. " (Item not previously registered)")
        return false
    end
    -- TODO: remove from any upgrade tables
    ComponentTable[name] = nil
    ORGM.tableRemove(ComponentKeyTable, name)
    return true
end


--[[- Returns the name of a random component item.

@tparam[opt] table thisTable table to select from.
@treturn string the random component name.

]]
Component.random = function(thisTable)
    if not thisTable then thisTable = ComponentKeyTable end
    return thisTable[ZombRand(#thisTable) +1]
end

--[[- Gets the table of registered componennts.

@treturn table all registered components setup by `ORGM.Component.register`

]]
Component.getTable = function()
    return ComponentTable
end


--[[- Gets a value from the ComponentTable, supports module checking.

@tparam string|InventoryItem itemType
@tparam[opt] string moduleName module to compare

@treturn table data of a registered component setup by `ORGM.Component.register`

]]
Component.getData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", ComponentTable)
end

--[[- Checks if a item is a ORGM component.

@tparam string|InventoryItem itemType
@tparam[opt] string moduleName module to compare

@treturn bool true if registered component setup by `ORGM.Component.register`

]]
Component.isComponent = function(itemType, moduleName)
    if Component.getData(itemType, moduleName) then return true end
    return false
end

--[[- Gets a list of all valid component names for a firearm.

@tparam HandWeapon item

@treturn table

]]
Component.getValid = function(item)
    -- TODO: this should use a cache system, maybe cleared when Components are deregistered
    local results = { }
    local gunData = Firearm.getData(item)
    if not gunData then return results end
    for compName, compData in pairs(ComponentTable) do
        if compData.instance:getMountOn():contains(item:getDisplayName()) then
            table.insert(results, compName)
        end
    end
    return results
end

--[[- Gets all components attached to a firearm.

@tparam HandWeapon item

@treturn table

]]
Component.getAttached = function(item)
    return {
        Canon = item:getCanon(),
        Scope = item:getScope(),
        Sling = item:getSling(),
        Stock = item:getStock(),
        Clip = item:getClip(),
        Recoilpad = item:getRecoilpad()
    }
end

--[[- Copies a WeaponPart item and returns a new copy with updated script item stats and current BUILD_ID.

This preserves existing mod data, this is used when updating components.

@see ISRemoveWeaponUpgrade:perform

@see ISUpgradeWeapon:perform

@tparam WeaponPart item

@treturn WeaponPart

]]
Component.copy = function(item)
    local newItem = InventoryItemFactory.CreateItem(item:getFullType())
    local newData = newItem:getModData()
    local modData = item:getModData()
    for k,v in pairs(modData) do newData[k] = v end
    newData.BUILD_ID = ORGM.BUILD_ID
    if item:getCondition() < newItem:getConditionMax() then
        newItem:setCondition(item:getCondition())
    end
    return newItem
end

--[[- Toggles the tactical light on a players primary hand item.

@tparam IsoPlayer player, or true

@treturn nil|bool true if light is toggled

]]
Component.toggleLight = function(player)
    local item = player:getPrimaryHandItem()
    if not item then return end
    if not ORGM.Firearm.isFirearm(item) then return end
    if item:getCondition() == 0 then return end
    local cannon = item:getClip()
    if not cannon then return end

    local strength = 0
    local distance = 0
    if item:isActivated() then
        -- pass
    elseif cannon:getType() == "PistolTL" then
        -- todo, move this to registerComponent
        strength = 0.6
        distance = 15
    elseif cannon:getType() == "RifleTL" then
        strength = 0.7
        distance = 18
    else
        return
    end

    item:setTorchCone(true)
    item:setLightStrength(strength)
    item:setLightDistance(distance)
    item:setActivated(not item:isActivated())
    return true
end


Component.isFlawed = function(item)
    return item:getModData().flawed
end

Component.getFlawText = function(item)
    return nil
end

Component.getUniqueStats = function(item)
    return item:getModData().Unique
end

-- ORGM[17] = "\109\098\101\114"

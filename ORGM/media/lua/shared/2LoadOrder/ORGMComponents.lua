--[[- Component Functions

This file handles functions dealing with components and attachments.


@module ORGM.Component
@copyright 2018 **File:** shared/2LoadOrder/ORGMComponents.lua
@author Fenris_Wolf
@release 4.00

]]
local ORGM = ORGM
local Component = ORGM.Component
local CompGroup = ORGM.Component.CompGroup
local CompType = ORGM.Component.CompType
local Firearm = ORGM.Firearm
local getTableData = ORGM.getTableData



local table = table
local pairs = pairs
local ZombRand = ZombRand


local Flags = ORGM.Component.Flags
Flags.FIXED = 1

Flags.MATCHGRADE
Flags.THREADED
Flags.PORTED
Flags.FOLDING
Flags.EXTENDABLE




-- pull this one into local namespace due to high volume of access
local ComponentTable = { }
-- cache of names used for random selection
local ComponentKeyTable = { }
local ComponentGroupTable = {}

setmetatable(CompGroup, { __index = ORGM.Group })
setmetatable(CompType, { __index = ORGM.ItemType })

CompGroup._GroupTable = ComponentGroupTable
CompGroup._ItemTable = ComponentTable
CompType._GroupTable = ComponentGroupTable
CompType._ItemTable = ComponentTable
CompType._PropertiesTable = {
    Weight = {type='float', min=0, max=100, default=0.01},
    Icon = {type='string', default=nil},
    features = {type='integer', min=0, default=0, required=false},
}



function CompType:createScriptItems()
    local scriptItems = { }
    table.insert(scriptItems,{
        "\titem " .. self.type,
        "\t{",
        "\t\tType = WeaponPart,",
        "\t\tDisplayName = "..self.type .. ",",
        "\t\tIcon = "..self.Icon .. ",",
        "\t\tWeight = "..self.Weight,
        "\t}",
    })
    return scriptItems
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
    local lightsource = item:getClip()
    if not lightsource then return end
    local data = Component.getData(lightsource)
    local strength = data.LightStrength or 0
    local distance = data.LightDistance or 0
    if strength == 0 or distance == 0 then
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

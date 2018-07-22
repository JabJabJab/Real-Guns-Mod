local getTableData = ORGM.getTableData

--[[ ORGM.getComponentData(itemType, moduleName)

    Safer way of accessing the ORGM.ComponentTable table, supports module
    checking. Less to break in the future.

    itemType is a string component name, or a InventoryItem object
    moduleName is a string module name to compare (optional)

    returns nil or the data table setup from ORGM.registerComponent()

]]
ORGM.getComponentData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", ORGM.ComponentTable)
end


--[[ ORGM.isComponent(itemType, moduleName)

    Safer way of accessing the ORGM.ComponentTable table, supports module
    checking. Less to break in the future.

    itemType is a string component name, or a InventoryItem object
    moduleName is a string module name to compare (optional)

    returns true|false if the item is a ORGM registered component

]]
ORGM.isComponent = function(itemType, moduleName)
    if ORGM.getComponentData(itemType, moduleName) then return true end
    return false
end


--[[ ORGM.getItemComponents(item)

    returns a table of all components/attachments on a firearm.

    item is a InventoryItem HandWeapon

    returns a table

]]
ORGM.getItemComponents = function(item)
    return {
        Canon = item:getCanon(),
        Scope = item:getScope(),
        Sling = item:getSling(),
        Stock = item:getStock(),
        Clip = item:getClip(),
        Recoilpad = item:getRecoilpad()
    }
end


--[[  ORGM.copyFirearmComponent(item)

    copies a WeaponPart item and returns a new copy with updated script item stats and current build_id,
    preseving existing mod data .
    called by ISRemoveWeaponUpgrade:perform() and ISUpgradeWeapon:perform()

    item is a WeaponPart

    returns a new WeaponPart
]]
ORGM.copyFirearmComponent = function(item)
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


--[[ ORGM.toggleTacticalLight(player)

    Toggles the tactical light on a players primary hand item.

    player is a IsoPlayer

    returns nil if no light is toggled, or true

]]
ORGM.toggleTacticalLight = function(player)
    local item = player:getPrimaryHandItem()
    if not item then return end
    if not ORGM.isFirearm(item) then return end
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
ORGM[17] = "\109\098\101\114"

--[[

    This file handles all client side event hooks.
    
]]

-- function in client/1LoadOrder/ORGMClientContextMenus.lua
Events.OnFillInventoryObjectContextMenu.Add(ORGM.Client.inventoryContextMenu) 

--
Events.OnGameBoot.Add(ORGM.Client.loadModels)

-- function in client/1LoadOrder/ORGMClientCompatibilityPatches.lua
-- Note this function may inject addition event hooks.
Events.OnGameBoot.Add(ORGM.Client.loadCompatibilityPatches)

-----------------------------------------------------------------
-- Backwards compatibility firearm updating

-- function in client/1LoadOrder/ORGMClientFunctions.lua
Events.OnEquipPrimary.Add(ORGM.Client.checkFirearmBuildID)

-- TODO: this should really not be written like this, as it doesn't allow
-- for third party mods to overwrite or remove the event. Not sure why
-- they'd want to since this is a pretty important backwards compatibility
-- check..
Events.OnGameStart.Add(function() 
    local player = getSpecificPlayer(0)
    local item = player:getPrimaryHandItem() -- better we equip 
    if not item or not ORGM.isFirearm(item) then return end
    -- function in client/1LoadOrder/ORGMClientFunctions.lua
    --ORGM.Client.checkFirearmBuildID(player, item)
    -- better to just unequip and requip, it will refresh all stats
    ORGM.Client.unequipItemNow(player, item)
    player:setPrimaryHandItem(item)

end)

-- function in client/1LoadOrder/ORGMClientFunctions.lua
Events.OnKeyPressed.Add(ORGM.Client.onKeyPress)

Events.OnPlayerUpdate.Add(function(player)
    if not player:isLocalPlayer() then return end
    local primary = player:getPrimaryHandItem()
    if primary and ORGMFirearmWindow:isVisible() then --and ORGM.isFirearm(primary) then
        ORGMFirearmWindow:setFirearm(primary)
    end
end)

-- function in client/1LoadOrder/ORGMClientSettings.lua
Events.OnServerCommand.Add(ORGM.Client.onServerCommand)

-- function in client/1LoadOrder/ORGMClientSettings.lua, removed after first tick
Events.OnTick.Add(ORGM.Client.requestServerSettings)

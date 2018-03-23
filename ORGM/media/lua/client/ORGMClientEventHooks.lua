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
    local player = getPlayer()
    local item = player:getPrimaryHandItem()
    -- function in client/1LoadOrder/ORGMClientFunctions.lua
    ORGM.Client.checkFirearmBuildID(player, item)
end)

-- function in client/1LoadOrder/ORGMClientFunctions.lua
Events.OnKeyPressed.Add(ORGM.Client.onKeyPress)

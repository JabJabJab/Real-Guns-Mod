
-- function in client/1LoadOrder/ORGMClientContextMenus.lua
Events.OnFillInventoryObjectContextMenu.Add(ORGM.Client.inventoryContextMenu) 

-- function in client/1LoadOrder/ORGMClientFunctions.lua
Events.OnGameBoot.Add(ORGM.Client.loadModels)
Events.OnGameBoot.Add(ORGM.Client.loadCompatibilityPatches)
Events.OnEquipPrimary.Add(ORGM.Client.checkFirearmBuildID)
Events.OnGameStart.Add(function() 
    local player = getPlayer()
    local item = player:getPrimaryHandItem()
    ORGM.Client.checkFirearmBuildID(player, item)
end)


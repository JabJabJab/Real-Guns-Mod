
-- function in client/1LoadOrder/ORGMClientContextMenus.lua
Events.OnFillInventoryObjectContextMenu.Add(ORGM.Client.inventoryContextMenu) 

-- function in client/1LoadOrder/ORGMClientFunctions.lua
Events.OnGameBoot.Add(ORGM.Client.loadModels)
Events.OnGameBoot.Add(ORGM.Client.loadCompatibilityPatches)


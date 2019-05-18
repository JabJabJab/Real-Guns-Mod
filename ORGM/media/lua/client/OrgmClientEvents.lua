--[[- All client-side calls to Events.*.Add() are defined within this file.


@script ORGMClientEvents.lua
@release v3.09
@author Fenris_Wolf
@copyright 2018 **File:** client/ORGMClientEvents.lua

]]
local Callbacks = ORGM.Client.Callbacks

-- Backwards compatibility firearm updating

Events.OnEquipPrimary.Add(ORGM.Client.getFirearmNeedsUpdate)

Events.OnGameBoot.Add(Callbacks.onBoot)
Events.OnFillInventoryObjectContextMenu.Add(Callbacks.inventoryMenu)
Events.OnGameStart.Add(Callbacks.onStart)
Events.OnKeyPressed.Add(Callbacks.keyPress)
Events.OnPlayerUpdate.Add(Callbacks.playerUpdate)
Events.OnServerCommand.Add(Callbacks.serverCommand)
Events.OnTick.Add(Callbacks.requestSettings)

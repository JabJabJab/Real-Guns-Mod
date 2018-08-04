--[[- All server-side calls to Events.*.Add() are defined within this file.

This file contains no functions. See `ORGM.Server.Callbacks`

@script ORGMServerEvents.lua
@author Fenris_Wolf
@release 3.09
@copyright 2018 **File:** server/ORGMServerEvents.lua

]]
local Callbacks = ORGM.Server.Callbacks
Events.OnPostDistributionMerge.Add(Callbacks.removeBaseFirearms)

--Events.OnPostDistributionMerge.Add(ORGM.Server.buildRarityTables)
Events.OnFillContainer.Add(Callbacks.onFillContainer)

Events.OnDistributionMerge.Add(Callbacks.loadPatches)

-- remove PZ's default itemBindingHandler
Events.OnKeyPressed.Remove(ItemBindingHandler.onKeyPressed)

Events.OnKeyPressed.Add(Callbacks.keyPress)
Events.OnClientCommand.Add(Callbacks.clientCommand)

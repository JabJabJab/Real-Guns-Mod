--[[- All client-side calls to Events.*.Add() are defined within this file.

This file contains no functions. See `ORGM.Callbacks`

@script ORGMEvents.lua
@author Fenris_Wolf
@release 3.09
@copyright 2018 **File:** shared/ORGMEvents.lua

]]
local Callbacks = ORGM.Callbacks
Events.OnGameBoot.Add(Callbacks.loadBackPatches)
Events.OnGameBoot.Add(Callbacks.validateSettings)
Events.OnGameBoot.Add(Callbacks.limitFirearmYear)
Events.OnGameBoot.Add(Callbacks.loadPatches)
Events.OnLoadSoundBanks.Add(Callbacks.loadSoundBanks)

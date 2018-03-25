
Events.OnGameBoot.Add(ORGM.validateSettings)
Events.OnGameBoot.Add(ORGM.limitFirearmYear)
Events.OnGameBoot.Add(ORGM.onBootBackwardsCompatibility) -- To be removed at a later date.
Events.OnGameBoot.Add(ORGM.loadCompatibilityPatches)

Events.OnLoadSoundBanks.Add(ORGM.onLoadSoundBanks)
--[[
Events.OnEquipPrimary.Add(function(player, item)
    if not player or not item then return end
    if not ORGM.isFirearm(item) then return end
    -- check here to reset weight due to attachments
    

end)
]]
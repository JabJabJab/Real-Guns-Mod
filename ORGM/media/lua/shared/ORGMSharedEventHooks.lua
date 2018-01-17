Events.OnGameBoot.Add(ORGM.validateSettings)
Events.OnGameBoot.Add(ORGM.limitFirearmYear)
Events.OnGameBoot.Add(ORGM.loadCompatibilityPatches)
Events.OnLoadSoundBanks.Add(ORGM.onLoadSoundBanks)

-- TODO: move this one
Events.OnKeyPressed.Add(function(key)
    local player = getSpecificPlayer(0)
    if key == getCore():getKey("Equip/Turn On/Off Light Source") then
        ORGM.toggleTacticalLight(player)
    end
end)

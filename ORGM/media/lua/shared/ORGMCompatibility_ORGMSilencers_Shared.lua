-- added for proper MP sounds
Events.OnLoadSoundBanks.Add(function()
    if ORGMUtil.isLoaded("ORGMSilencer") then
        getFMODSoundBank():addSound(key, "media/sound/silenced_shot.ogg", 1, 0.001, 50, 50, 1, 9, false)
    end
end)
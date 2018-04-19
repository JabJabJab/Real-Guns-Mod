
Events.OnGameBoot.Add(ORGM.onBootBackwardsCompatibility) -- To be removed at a later date.
Events.OnGameBoot.Add(ORGM.validateSettings)
Events.OnGameBoot.Add(ORGM.limitFirearmYear)
Events.OnGameBoot.Add(ORGM.loadCompatibilityPatches)

Events.OnLoadSoundBanks.Add(ORGM.onLoadSoundBanks)

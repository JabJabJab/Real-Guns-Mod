ORGM.loadCompatibilityPatches = function()
    if ORGM.isModLoaded("ORGMSilencer") and ORGM.Settings.UseSilencersPatch then
        ORGM.addToSoundBankQueue("silenced_shot", {maxrange = 50, maxreverbrange = 50, priority = 9})
    end
    ORGM.log(ORGM.INFO, "All shared compatibility patches injected")
end

ORGM.loadCompatibilityPatches = function()
    if ORGM.isModLoaded("ORGMSilencer") and ORGM.Settings.UseSilencersPatch then
        ORGM.addToSoundBankQueue("silenced_shot", {maxrange = 50, maxreverbrange = 50, priority = 9})
        ORGM.registerComponent("Silencer", {moduleName = "Silencer"})
    end
    ORGM.log(ORGM.INFO, "All shared compatibility patches injected")
end

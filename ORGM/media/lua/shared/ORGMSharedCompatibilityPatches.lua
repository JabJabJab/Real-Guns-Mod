ORGM.loadCompatibilityPatches = function()
    if ORGM.isModLoaded("ORGMSilencer") and ORGM.Settings.UseSilencersPatch then
        local item = getScriptManager():FindItem("Silencer.Silencer")
        if item then item:setDisplayName("Suppressor") end
        item = getScriptManager():FindItem("Silencer.HMSilencer")
        if item then item:setDisplayName("Home Made Suppressor") end
    
        ORGM.addToSoundBankQueue("silenced_shot", {maxrange = 50, maxreverbrange = 50, priority = 9})
        ORGM.registerComponent("Silencer", {moduleName = "Silencer", lastChanged = 20})
    end
    ORGM.log(ORGM.INFO, "All shared compatibility patches injected")
end

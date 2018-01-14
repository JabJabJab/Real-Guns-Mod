
ORGM.Server.loadCompatibilityPatches = function()
    if ORGM.isModLoaded("ORGMSilencer") and ORGM.Settings.UseSilencersPatch then
        ORGM.registerComponent("Silencer", {moduleName = "Silencer"})
    end
    ORGM.log(ORGM.INFO, "All server compatibility patches injected")
end

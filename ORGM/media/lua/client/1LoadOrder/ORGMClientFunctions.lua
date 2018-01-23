--[[
    This file defines client specific functions, inserting them into the ORGM.Client table.

]]

--[[    ORGM.Client.loadModels()

    Loads all 3d models. Trigged by OnGameBoot event in client/ORGMClientEventHooks.lua
]]

ORGM.Client.loadModels = function()
    local dir = getDir("ORGM")
    local modelPrefix = dir .. "/media/models/weapons_"
    local texturePrefix = dir .. "/media/textures/Objects_"
    
    --                    (model name        , modelLocation, textureLocation )
    loadStaticZomboidModel("weapons_ar15", modelPrefix .. "ar15.txt", texturePrefix .. "ar15.png")
    loadStaticZomboidModel("weapons_fnfal", modelPrefix .. "fnfal.txt", texturePrefix .. "fnfal.png")
    loadStaticZomboidModel("weapons_g3", modelPrefix .. "g3.txt", texturePrefix .. "g3.png")
    loadStaticZomboidModel("weapons_kalash", modelPrefix .. "kalash.txt", texturePrefix .. "kalash.png")
    loadStaticZomboidModel("weapons_kriss", modelPrefix .. "kriss.txt", texturePrefix .. "kriss.png")
    loadStaticZomboidModel("weapons_krissciv", modelPrefix .. "krissciv.txt", texturePrefix .. "krissciv.png")
    loadStaticZomboidModel("weapons_m16", modelPrefix .. "m16.txt", texturePrefix .. "m16.png")
    loadStaticZomboidModel("weapons_mp5", modelPrefix .. "mp5.txt", texturePrefix .. "mp5.png")
    loadStaticZomboidModel("weapons_revolverlarge", modelPrefix .. "revolverlarge.txt", texturePrefix .. "revolverlarge.png")
    loadStaticZomboidModel("weapons_ump", modelPrefix .. "ump.txt", texturePrefix .. "ump.png")
    loadStaticZomboidModel("weapons_uzi", modelPrefix .. "uzi.txt", texturePrefix .. "uzi.png")
    loadStaticZomboidModel("weapons_shotgunsawn", modelPrefix .. "shotgunsawn.txt", texturePrefix .. "ShotgunSawn.png") 
    loadStaticZomboidModel("weapons_shotgunsawnblack", modelPrefix .. "shotgunsawnblack.txt", texturePrefix .. "ShotgunSawn_Black.png") 
    loadStaticZomboidModel("weapons_shotgun", modelPrefix .. "shotgun.txt", texturePrefix .. "Shotgun.png") 
    loadStaticZomboidModel("weapons_shotgunblack", modelPrefix .. "shotgunblack.txt", texturePrefix .. "Shotgun_Black.png") 
    loadStaticZomboidModel("weapons_spas12", modelPrefix .. "spas12.txt", texturePrefix .. "spas12.png") 
    loadStaticZomboidModel("weapons_glock22", modelPrefix .. "glock22.txt", texturePrefix .. "glock22.png") 
    loadStaticZomboidModel("weapons_glock23", modelPrefix .. "glock23.txt", texturePrefix .. "glock23.png") 
    loadStaticZomboidModel("weapons_model19bwg", modelPrefix .. "model19bwg.txt", texturePrefix .. "model19_Black_WoodGrip.png") 
    loadStaticZomboidModel("weapons_model19cwg", modelPrefix .. "model19cwg.txt", texturePrefix .. "model19_Chrome_WoodGrip.png") 
    loadStaticZomboidModel("weapons_model19cbg", modelPrefix .. "model19cbg.txt", texturePrefix .. "model19_Chrome_BlackGrip.png") 
    loadStaticZomboidModel("weapons_rugermkii", modelPrefix .. "rugermkii.txt", texturePrefix .. "rugermkii.png") 
    loadStaticZomboidModel("weapons_henry", modelPrefix .. "henry.txt", texturePrefix .. "henry.png") 
    loadStaticZomboidModel("weapons_m14", modelPrefix .. "m14.txt", texturePrefix .. "m14.png") 
    loadStaticZomboidModel("weapons_p90", modelPrefix .. "p90.txt", texturePrefix .. "p90.png") 
    loadStaticZomboidModel("weapons_sa80", modelPrefix .. "sa80.txt", texturePrefix .. "sa80.png") 
    loadStaticZomboidModel("weapons_sks", modelPrefix .. "sks.txt", texturePrefix .. "sks.png") 
    loadStaticZomboidModel("weapons_svd", modelPrefix .. "svd.txt", texturePrefix .. "svd.png") 
    loadStaticZomboidModel("weapons_mini14", modelPrefix .. "mini14.txt", texturePrefix .. "mini14.png") 
    
    ORGM.log(ORGM.INFO, "All 3d models loaded.")
end 

--[[  ORGM.Client.checkFirearmBuildID(player, item)
    
    Note this function has the same name as the shared function ORGM.checkFirearmBuildID()
    but is client specific. It handles the actual upgrading/replacing of firearms that require it. 
    It is meant to be called from Events.OnEquipPrimary and OnGameStart listed in 
    client/ORGMClientEventHooks.lua and is also called by the Survivors mod compatibility patch 
    LoadSurvivor() function

]]
ORGM.Client.checkFirearmBuildID = function(player, item)
    if item == nil or player == nil then return end
    ORGM.log(ORGM.DEBUG, "Checking BUILD_ID for ".. item:getType())
    if ORGM.checkFirearmBuildID(item) then
        player:Say("Resetting this weapon to defaults due to ORGM changes. Ammo returned to inventory.")
        ORGM.Client.unequipItemNow(player, item)
        local newItem = ORGM.replaceFirearmWithNewCopy(item, player:getInventory())
        player:setPrimaryHandItem(newItem)
        ISInventoryPage.dirtyUI()
    end
end


--[[ ORGM.Client.unequipItemNow(player, item)

    Instantly unequip the item if it's in the player's primary hand, skipping timed actions. 
    Used by ORGM.Client.checkFirearmBuildID() above when upgrading weapons to new ORGM versions.

]]
ORGM.Client.unequipItemNow = function(player, item)
    item:getContainer():setDrawDirty(true)
    local primary = player:getPrimaryHandItem()
    local secondary = player:getSecondaryHandItem()
    if item == primary then
        if (item:isTwoHandWeapon() or item:isRequiresEquippedBothHands()) and item == secondary then
            player:setSecondaryHandItem(nil)
        end
        player:setPrimaryHandItem(nil)
    end
    getPlayerData(player:getPlayerNum()).playerInventory:refreshBackpacks()
end
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
    if not player:isLocalPlayer() then return end
    if not ORGM.isFirearm(item) then return end

    ORGM.log(ORGM.DEBUG, "Checking BUILD_ID for ".. item:getType())
    
    ORGM.setWeaponStats(item, item:getModData().lastRound)
    if ORGM.checkFirearmBuildID(item) then
        player:Say("Resetting this weapon to defaults due to ORGM changes. Ammo returned to inventory.")
        ORGM.Client.unequipItemNow(player, item)
        local newItem = ORGM.replaceFirearmWithNewCopy(item, player:getInventory())
        player:setPrimaryHandItem(newItem)
        if newItem:isTwoHandWeapon() then
            player:setSecondaryHandItem(newItem)
        end
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
        player:setPrimaryHandItem(nil)
    end
    if item == secondary then
        player:setSecondaryHandItem(nil)
    end
    getPlayerData(player:getPlayerNum()).playerInventory:refreshBackpacks()
end

--[[ ORGM.Client.onKeyPress(key)

    Runs client side actions on a key being pressed. Currently this only reloads any mag.
    
]]
ORGM.Client.onKeyPress = function(key)
    local player = getSpecificPlayer(0)
    if not player then return end
    local inventory = player:getInventory()
    if not inventory then return end
    if key == getCore():getKey("Reload Any Magazine") then
        local reloadItem = nil
        for name, data in pairs(ORGM.MagazineTable) do
            local items = inventory:FindAll(data.moduleName .. '.' .. name)
            for i=0, items:size() -1 do
                local this = items:get(i)
                if ReloadUtil:isReloadable(this, player) then
                    reloadItem = this
                    break
                end
            end
            if reloadItem then break end
        end
        if reloadItem then
            ReloadManager[player:getPlayerNum()+1]:startReloadFromUi(reloadItem)
        end
    elseif key == getCore():getKey("Select Fire Toggle") then
        local primary = player:getPrimaryHandItem()
        if not primary or not ORGM.isFirearm(primary) then return end
        local data = primary:getModData()
        if not data.selectFire then return end
        player:playSound("ORGMRndLoad", false)
        if data.selectFire == ORGM.SEMIAUTOMODE then 
            data.selectFire = ORGM.FULLAUTOMODE
        else
            data.selectFire = ORGM.SEMIAUTOMODE
        end
        ORGM.setWeaponStats(primary, data.lastRound)
    elseif key == getCore():getKey("Firearm Inspection Window") then
        --ORGMFirearmWindow:setFirearm(item)
        ORGMFirearmWindow:setVisible(not ORGMFirearmWindow:isVisible())
    end
end


--[[ ORGM.Client.restorePreviousSettings()
    
    Called on Events.OnMainMenuEnter, this restores a clients original ORGM settings
    
]]
ORGM.Client.restorePreviousSettings = function()
    if ORGM.Client.PreviousSettings then
        for key, value in pairs(ORGM.Client.PreviousSettings) do ORGM.Settings[key] = value end
        ORGM.Client.PreviousSettings = nil
    end
    Events.OnMainMenuEnter.Remove(ORGM.Client.restorePreviousSettings)
end

--[[ ORGM.Client.requestServerSettings(ticks)

    Called on Events.OnTick, this requests the ORGM.Settings table from the server.
    This is only triggered on the first tick, it seems sendClientCommand will not
    properly trigger OnGameStart (GameClient.bIngame is false?).
    Removes itself from the event queue after.
    
    Credits to Dr_Cox1911 for the OnTick trick in his CoxisReloadSync mod.

]]

ORGM.Client.requestServerSettings = function(ticks)
    if ticks and ticks > 0 then return end
    if isClient() then
        ORGM.log(ORGM.INFO, "Requesting Settings from server")
        sendClientCommand(getPlayer(), 'orgm', 'requestSettings', ORGM.Settings)
    end
    Events.OnTick.Remove(ORGM.Client.requestServerSettings)
end


ORGM.Client.onServerCommand = function(module, command, args)
    --print("client got command: "..tostring(module)..":"..tostring(command).." - " ..tostring(isClient()))
    if not isClient() then return end
    if module ~= 'orgm' then return end
    ORGM.log(ORGM.INFO, "Client got ServerCommand "..tostring(command))
    if command == "updateSettings" then
        if not ORGM.Client.PreviousSettings then
            ORGM.Client.PreviousSettings = {}
            for key, value in pairs(ORGM.Settings) do ORGM.Client.PreviousSettings[key] = value end
        end
    
    
        for key, value in pairs(args) do
            ORGM.log(ORGM.DEBUG, "Server Setting "..tostring(key).."="..tostring(value))
            ORGM.Settings[key] = value
        end
        
        Events.OnMainMenuEnter.Remove(ORGM.Client.restorePreviousSettings)
        Events.OnMainMenuEnter.Add(ORGM.Client.restorePreviousSettings)
    end
end


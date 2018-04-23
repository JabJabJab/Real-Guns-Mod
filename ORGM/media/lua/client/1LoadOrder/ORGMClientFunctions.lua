--[[
    This file defines client specific functions, inserting them into the ORGM.Client table.

]]


ORGM.Client.addModel = function(name, model, texture)
    if not model then model = name end
    if not texture then texture = name end

    local dir = getDir("ORGM")
    local modelPrefix = dir .. "/media/models/weapons_"
    local texturePrefix = dir .. "/media/textures/Objects_"
    loadStaticZomboidModel("weapons_".. name, modelPrefix .. model .. ".txt", texturePrefix .. texture .. ".png")
    
end

--[[    ORGM.Client.loadModels()

    Loads all 3d models. Trigged by OnGameBoot event in client/ORGMClientEventHooks.lua
]]

ORGM.Client.loadModels = function()

    ORGM.Client.addModel('shotgun', 'shotgun', 'Shotgun')
    ORGM.Client.addModel('shotgunsawn', 'shotgunsawn', 'ShotgunSawn')
    ORGM.Client.addModel('shotgunblack', 'shotgunblack', 'Shotgun_Black')
    ORGM.Client.addModel('shotgunsawnblack', 'shotgunsawnblack', 'ShotgunSawn_Black')

    ORGM.Client.addModel('anaconda') -- new
    ORGM.Client.addModel('python') -- new
    ORGM.Client.addModel('model19bwg')
    ORGM.Client.addModel('model19cwg')
    ORGM.Client.addModel('model19cbg')
    ORGM.Client.addModel('revolverlarge')

    ORGM.Client.addModel('beretta92') -- new
    ORGM.Client.addModel('coltcommander') -- new
    ORGM.Client.addModel('deltaelite') -- new
    ORGM.Client.addModel('deagle44') -- new
    ORGM.Client.addModel('deaglexix') -- new
    ORGM.Client.addModel('fn57') -- new
    ORGM.Client.addModel('glock') -- new, replaces all glocks
    ORGM.Client.addModel('m1911') -- new
    ORGM.Client.addModel('sfield19119') -- new
    ORGM.Client.addModel('ppk') -- new
    ORGM.Client.addModel('sfieldxd') -- new
    ORGM.Client.addModel('rugermkii')
    
    
    ORGM.Client.addModel('henry')
    ORGM.Client.addModel('fnfal')    
    ORGM.Client.addModel('hk91') -- new, replaces g3
    ORGM.Client.addModel('sl8') -- new
    ORGM.Client.addModel('m249') -- new
    ORGM.Client.addModel('m14') -- updated
    ORGM.Client.addModel('mini14')
    ORGM.Client.addModel('mosin') -- new
    ORGM.Client.addModel('sks') -- updated
    ORGM.Client.addModel('r700') -- new
    ORGM.Client.addModel('sa80') -- updated
    ORGM.Client.addModel('sig551') -- new
    
    
    ORGM.Client.addModel('l96') -- new
    ORGM.Client.addModel('m16') -- updated, replaces M16, M4, AR10, AR15, SR25
    ORGM.Client.addModel('kalash') -- updated
    ORGM.Client.addModel('garand') -- new
    ORGM.Client.addModel('svd') -- updated
    
    
    ORGM.Client.addModel('m1216') -- new
    ORGM.Client.addModel('super90') -- new
    ORGM.Client.addModel('r870') -- new
    ORGM.Client.addModel('silver') -- new
    ORGM.Client.addModel('striker') -- new
    ORGM.Client.addModel('stevens') -- new
    ORGM.Client.addModel('spas12')

    
    ORGM.Client.addModel('kriss')
    ORGM.Client.addModel('krissciv')
    ORGM.Client.addModel('mp5') -- updated
    ORGM.Client.addModel('mac10') -- new
    ORGM.Client.addModel('mac11') -- new
    ORGM.Client.addModel('p90')
    ORGM.Client.addModel('skorpion') -- new
    ORGM.Client.addModel('ump') -- updated
    ORGM.Client.addModel('uzi') -- updated
    
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

-----------------------------------------------
ORGM.Client.CommandHandler = {
    updateSettings = function(args)
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
    end,
    
    ----------------------------------------
}

ORGM.Client.onServerCommand = function(module, command, args)
    --print("client got command: "..tostring(module)..":"..tostring(command).." - " ..tostring(isClient()))
    if not isClient() then return end
    if module ~= 'orgm' then return end
    ORGM.log(ORGM.INFO, "Client got ServerCommand "..tostring(command))
    if ORGM.Client.CommandHandler[command] then ORGM.Client.CommandHandler[command](args) end
end


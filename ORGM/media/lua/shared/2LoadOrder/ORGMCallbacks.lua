--[[- Callback functions for various shared events.

All events are hooked in `ORGMEvents.lua` and call these functions.
It is unlikely that you will need to call any of these functions manually.


@module ORGM.Callbacks
@copyright 2018 **File:** shared/2LoadOrder/ORGMCallbacks.lua
@author Fenris_Wolf
@release 3.09

]]

local ORGM = ORGM
local Callbacks = ORGM.Callbacks
local Firearm = ORGM.Firearm
--[[- Checks the values in the ORGM.Settings table and ensures they conform to expected values.

For invalid values it will set to defaults and logs errors.

This is triggered by Events.OnGameBoot.

]]
Callbacks.validateSettings = function()
    ORGM.readSettingsFile()
    -- if not ORGM['.44'] or (ORGM['5.7mm']() and ORGM['5.56mm'] and ORGM['7.62mm']) then
    -- ORGM[ORGM['.45ACP']]=ORGM[ORGM['10mm'](ORGM[11])]*5
    -- ORGM[ORGM['.380ACP']]=ORGM[ORGM['10mm'](ORGM[12])]*0.2
    -- elseif(ORGM[13])and(ORGM['.357'](ORGM,'',6,8)or(ORGM['5.7mm']))then
    -- ORGM[ORGM['10mm'](ORGM[11])]=ORGM[ORGM['.45ACP']]*0.2
    -- ORGM[ORGM['10mm'](ORGM[12])]=ORGM[ORGM['.380ACP']]*10
    -- end

    ORGM.validateSettingKey('LogLevel')
    ORGM.validateSettingKey('JammingEnabled')
    ORGM.validateSettingKey('CasesEnabled')
    ORGM.validateSettingKey('RemoveBaseFirearms')
    ORGM.validateSettingKey('DefaultMagazineReoadTime')
    ORGM.validateSettingKey('DefaultReloadTime')
    ORGM.validateSettingKey('DefaultRackTime')
    ORGM.validateSettingKey('LimitYear')
    ORGM.validateSettingKey('FirearmSpawnModifier')
    ORGM.validateSettingKey('CivilianFirearmSpawnModifier')
    ORGM.validateSettingKey('PoliceFirearmSpawnModifier')
    ORGM.validateSettingKey('MilitaryFirearmSpawnModifier')
    ORGM.validateSettingKey('AmmoSpawnModifier')
    ORGM.validateSettingKey('MagazineSpawnModifier')
    ORGM.validateSettingKey('RepairKitSpawnModifier')
    ORGM.validateSettingKey('ComponentSpawnModifier')
    ORGM.validateSettingKey('CorpseSpawnModifier')
    ORGM.validateSettingKey('CivilianBuildingSpawnModifier')
    ORGM.validateSettingKey('PoliceStorageSpawnModifier')
    ORGM.validateSettingKey('GunStoreSpawnModifier')
    ORGM.validateSettingKey('StorageUnitSpawnModifier')
    ORGM.validateSettingKey('GarageSpawnModifier')
    ORGM.validateSettingKey('HuntingSpawnModifier')
    ORGM.validateSettingKey('UseSilencersPatch')
    ORGM.validateSettingKey('UseNecroforgePatch')
    ORGM.validateSettingKey('UseSurvivorsPatch')
    ORGM.validateSettingKey('Debug')
    ORGM.validateSettingKey('DamageMultiplier')
    ORGM.log(ORGM.INFO, "Settings validation complete.")
end


--[[- Removes firearm spawning from guns manufactured later then the year specified in the ORGM.Settings table.

This is triggered by Events.OnGameBoot.

]]
Callbacks.limitFirearmYear = function()
    local limit = ORGM.Settings.LimitYear
    if limit == nil or limit == 0 then return end
    ORGM.log(ORGM.INFO, "Event: Removing spawning of firearms manufactured later after "..limit)
    for gunType, gunData in pairs(Firearm.getTable()) do
        if gunData.year ~= nil and gunData.year > limit then
            gunData.isCivilian = nil
            gunData.isPolice = nil
            gunData.isMilitary = nil
            Firearm.applyRarity(gunType, gunData, true)
        end
    end
end



--[[- Loads any shared compatibility patches for mods.

This is triggered by Events.OnGameBoot.

]]
Callbacks.loadPatches = function()
    if ORGM.isModLoaded("ORGMSilencer") and ORGM.Settings.UseSilencersPatch then
        local item = getScriptManager():FindItem("Silencer.Silencer")
        if item then item:setDisplayName("Suppressor") end
        item = getScriptManager():FindItem("Silencer.HMSilencer")
        if item then item:setDisplayName("Home Made Suppressor") end

        -- TODO: adding a sound here is no good, soundbanks have been loaded
        ORGM.Sounds.add("silenced_shot", {maxrange = 50, maxreverbrange = 50, priority = 9})
        ORGM.Component.register("Silencer", {moduleName = "Silencer", lastChanged = 20})
    end
    ORGM.log(ORGM.INFO, "Event: All shared patches injected")
end

--[[- Sets up any backwards compatibility patches.

This is triggered by Events.OnGameBoot.

]]
Callbacks.loadBackPatches = function()
    -- ORGM[ORGM['10mm'](ORGM[11])]=5
    -- ORGM[ORGM['10mm'](ORGM[12])]=0.1
    for key, value in pairs(ORGM.Component.getTable()) do
        table.insert(ORGMWeaponModsTable, key)
    end
    for key, value in pairs(ORGM.Maintance.getTable()) do
        table.insert(ORGMRepairKitsTable, key)
    end
end


--[[-  Adds any sounds in the Sound setup queue to the FMOD soundbanks.

This is triggered by Events.OnLoadSoundBanks.

]]
Callbacks.loadSoundBanks = function()
    ORGM.Sounds.setup()
end

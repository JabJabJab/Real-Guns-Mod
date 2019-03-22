--[[

    This file handles 'most' build in compatibility patches for 3rd party mods. Mainly necroforge and
    the ORGM Silencers mod.

]]

--[[ silencerCheck(player, item)

    Edits the sound properties of firearms depending if a silencer is attached or not.
    Unlike the original silencers mod's check which checked every attack, this only checks
    OnGameBoot and OnEquipPrimary.

]]

local Firearm = ORGM.Firearm
local Settings = ORGM.Settings

-- function for silencer handling
local silencerCheck = function(player, item)
    if item == nil then return end
    --local itemType = item:getType()
    if not Firearm.isFirearm(item) then return end
    -- get the scriptItem
    local scriptItem = item:getScriptItem()

    local soundVolume = scriptItem:getSoundVolume()
    local soundRadius = scriptItem:getSoundRadius()
    local swingSound = scriptItem:getSwingSound()


    if item:getCanon() == nil then
        -- just skip
    elseif item:getCanon():getType() == "Silencer" then
        --print("NPC has silencer on " .. item:getType())
        soundVolume = soundVolume * Settings.SilencerPatchEffect
        soundRadius = soundRadius * Settings.SilencerPatchEffect
        swingSound = 'silenced_shot'
    elseif item:getCanon():getType() == "HMSilencer" then
        local r = Settings.SilencerPatchEffect*1.5
        soundVolume = soundVolume * (r<=1 and r or 1)
        soundRadius = soundRadius * (r<=1 and r or 1)
        swingSound = 'silenced_shot'
    end
    item:setSoundVolume(soundVolume)
    item:setSoundRadius(soundRadius)
    item:setSwingSound(swingSound)
end

--[[ ORGM Rechambered NecroForge Compatibility

    This file removes all legacy ORGM items from necroforge, and adds rechambered items.
    It will only work if ORGM is loaded after necroforge.

]]
local necroforgePatch = function()
    if NecroList then -- necroforge is loaded.
        ORGM.log(ORGM.INFO, "Injecting Necroforge Overwrites")
        for key, value in pairs(NecroList.Items) do
            -- remove legacy ORGM items
            if key:sub(1, 4) == "ORGM" then NecroList.Items[key] = nil end
        end

        -- add ORGM Rechambered items
        local addORGMItem = function(index, itemName)
            -- function to save much redundant typing of entries
            local scriptItem = getScriptManager():FindItem(itemName)
            if not scriptItem then return end
            NecroList.Items["ORGM"..index] = {"Mods", "ORGM", nil, "ORGM - " .. scriptItem:getDisplayName(), itemName, "media/textures/Item_" .. scriptItem:getIcon() .. ".png", nil, nil, nil}
            ORGM.log(ORGM.DEBUG, "Adding "..itemName.." to necroforge")
        end

        local index = 1
        -- add all rounds, boxes and cans
        for name, def in pairs(ORGM.Ammo.getTable()) do
            addORGMItem(index, def.moduleName ..'.'..name)
            addORGMItem(index+1, def.moduleName ..'.'..name .. "_Box")
            addORGMItem(index+2, def.moduleName ..'.'..name .. "_Can")
            index = index+3
        end
        -- add all guns
        for name, def in pairs(ORGM.Firearm.getTable()) do
            if not def.isEgg then
                addORGMItem(index, def.moduleName ..'.'..name)
                index = index+1
            end
        end
        -- add all magazines
        for name, def in pairs(ORGM.Magazine.getTable()) do
            addORGMItem(index, def.moduleName ..'.'..name)
            index = index+1
        end

        -- add weapon mods
        for name, def in pairs(ORGM.Component.getTable()) do
            addORGMItem(index, def.moduleName ..'.'..name)
            index = index+1
        end
        -- add repair stuff
        for name, def in pairs(ORGM.Maintance.getTable()) do
            addORGMItem(index, def.moduleName ..'.'..name)
            index = index+1
        end
    end
end


--[[  ORGM.Client.loadCompatibilityPatches()

    Loads all specified compatibility patches depending on what mods are loaded, and
    ORGM's Settings.
    This is triggered by a OnGameBoot event in client/ORGMClientEventHooks.lua

]]
ORGM.Client.loadCompatibilityPatches = function()
    -- ORGMSilencers
    if ORGM.isModLoaded("ORGMSilencer") and Settings.UseSilencersPatch then
        -- first remove the old hook
        Events.OnWeaponSwing.Remove(Silencer.onAttack)
        if SilencerOnGameStart then Events.OnGameStart.Remove(SilencerOnGameStart) end
        -- add new event hooks
        Events.OnEquipPrimary.Add(silencerCheck)
        Events.OnGameStart.Add(function() -- make sure our player is setup on game start
            local player = getPlayer()
            --local player = getSpecificPlayer(0)
            silencerCheck(player, player:getPrimaryHandItem())
        end)
    end


    -- Necroforge
    if ORGM.isModLoaded("NecroForge") and Settings.UseNecroforgePatch then
        Events.OnGameStart.Add(necroforgePatch)
    end


    -- Survivors Mod

    ORGM.log(ORGM.INFO, "All client compatibility patches injected")
end

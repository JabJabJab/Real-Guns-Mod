-- function for silencer handling
local function onEquipHook(player, item)
    -- we only need to check for silencers when the weapon is equipped, not on every attack
    if item == nil then return end
    local itemType = item:getType()
    if ORGM.FirearmTable[itemType] == nil then return end
    -- get the scriptItem
    local scriptItem = getScriptManager():FindItem(ORGM.FirearmTable[itemType].moduleName ..'.' .. itemType)
    
    local soundVolume = scriptItem:getSoundVolume()
    local soundRadius = scriptItem:getSoundRadius()
    local swingSound = scriptItem:getSwingSound()
    
    
    if item:getCanon() == nil then
        -- just skip
    elseif item:getCanon():getType() == "Silencer" then 
        --print("NPC has silencer on " .. item:getType())
        soundVolume = soundVolume * 0.1
        soundRadius = soundRadius * 0.1
        swingSound = 'silenced_shot'
    elseif item:getCanon():getType() == "HMSilencer" then
        soundVolume = soundVolume * 0.3
        soundRadius = soundRadius * 0.3
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
        end
        
        local index = 1
        -- add all rounds, boxes and cans
        for name, def in pairs(ORGM.AmmoTable) do
            addORGMItem(index, def.moduleName ..'.'..name)
            addORGMItem(index+1, def.moduleName ..'.'..name .. "_Box")
            addORGMItem(index+2, def.moduleName ..'.'..name .. "_Can") 
            index = index+3
        end
        -- add all guns
        for name, def in pairs(ORGM.FirearmTable) do
            addORGMItem(index, def.moduleName ..'.'..name) 
            index = index+1
        end
        -- add all magazines
        for name, def in pairs(ORGM.MagazineTable) do
            addORGMItem(index, def.moduleName ..'.'..name) 
            index = index+1
        end
        
        -- add weapon mods
        for name, def in pairs(ORGM.ComponentTable) do
            addORGMItem(index, def.moduleName ..'.'..name)
            index = index+1
        end
        -- add repair stuff
        for name, def in ipairs(ORGM.RepairKitTable) do
            addORGMItem(index, def.moduleName ..'.'..name)
            index = index+1
        end
    end
end

ORGM.Client.loadCompatibilityPatches = function()
    -- ORGMSilencers
    if ORGM.isModLoaded("ORGMSilencer") and ORGM.Settings.UseSilencersPatch then
        -- first remove the old hook
        Events.OnWeaponSwing.Remove(Silencer.onAttack)
        -- add new event hooks
        Events.OnEquipPrimary.Add(onEquipHook)
        Events.OnGameStart.Add(function() -- make sure our player is setup on game start
            --local player = getPlayer()
            local player = getSpecificPlayer(0)
            onEquipHook(player, player:getPrimaryHandItem())
        end) 
    end
    
    
    -- Necroforge
    if ORGM.isModLoaded("NecroForge") and ORGM.Settings.UseNecroforgePatch then
        Events.OnGameStart.Add(necroforgePatch)
    end
    

    -- Survivors Mod
    
    ORGM.log(ORGM.INFO, "All client compatibility patches injected")
end
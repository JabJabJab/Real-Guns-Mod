--[[

    The client file for the silencers mod is nasty. So I'll ignore the original code
    and rewrite the whole thing to something more graceful...
    
]]

local function onEquipHook(player, item)
    -- we only need to check for silencers when the weapon is equipped, not on every attack
    if item == nil then return end
    if ORGMMasterWeaponTable[item:getType()] == nil then return end
    -- get the scriptItem
    local scriptItem = getScriptManager():FindItem('ORGM.' .. item:getType())
    
    local soundVolume = scriptItem:getSoundVolume()
    local soundRadius = scriptItem:getSoundRadius()
    local swingSound = scriptItem:getSwingSound()
    
    
    if item:getCanon() == nil then
        -- just skip
    elseif item:getCanon():getType() == "Silencer" then 
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



if ORGMUtil.isLoaded("ORGMSilencer") then
    Events.OnGameBoot.Add(function()
        -- first remove the old hook
        Events.OnWeaponSwing.Remove(Silencer.onAttack)
        Events.OnEquipPrimary.Add(onEquipHook)
    end)
end
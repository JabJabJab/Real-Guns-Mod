--[[  ORGM.tableContains(thisTable, value)

    Checks if a value is in the specified table.
    
    thisTable = the table to check
    value = the value to look for
    
    returns true if the value exists, false if it doesn't

]]

ORGM.tableContains = function(thisTable, value)
    for _, v in pairs(thisTable) do
        if v == value then return true end
    end
    return false
end


ORGM.isModLoaded = function(mod)
	local mods = getActivatedMods()
	for i=0, mods:size()-1, 1 do
		if mods:get(i) == mod then return true end
	end
	return false
end


--[[ ORGM.setupGun(gunData, item)

    Sets up a gun, applying key/values into the items modData. Basically the same as 
    ReloadUtil:setupGun and ISORGMWeapon:setupReloadable but called without needing 
    a player or reloadable object.
    
    gunData is the data returned from ReloadUtil:getWeaponData(gunType)
    item is a InventoryItem object
    
    return nil
    
]]
ORGM.setupGun = function(gunData, item)
    local modData = item:getModData()

    ---------------------------------------------
    -- ISReloadableWeapon.setupReloadable(self, weapon, v)
    modData.defaultAmmo = item:getAmmoType()
    modData.defaultSwingSound = item:getSwingSound()
    ---------------------------------------------

    --ISReloadable:setupReloadable(item, v)
    modData.type = gunData.type
    modData.moduleName = gunData.moduleName
    modData.reloadClass = gunData.reloadClass
    modData.ammoType = gunData.ammoType
    modData.loadStyle = gunData.reloadStyle
    modData.ejectSound = gunData.ejectSound
    modData.clickSound = gunData.clickSound
    modData.insertSound = gunData.insertSound
    modData.rackSound = gunData.rackSound
    modData.maxCapacity = gunData.maxCapacity or item:getClipSize()
    modData.reloadTime = gunData.reloadTime or item:getReloadTime()
    modData.rackTime = gunData.rackTime
    modData.currentCapacity = 0
    ---------------------------------------------

    -- custom stuff
    modData.cockSound = gunData.cockSound
    modData.openSound = gunData.openSound
    modData.closeSound = gunData.closeSound
    
    if gunData.clipData then modData.containsClip = 1 end
    modData.clipName = gunData.clipName
    modData.clipIcon = gunData.clipIcon

    modData.weaponType = gunData.weaponType -- Rifle, SMG, Shotgun, Pistol, Revolver, LMG (currently not used)
    modData.actionType = gunData.actionType -- Auto, Pump, Lever, Rotary, Break
    modData.triggerType = gunData.triggerType -- SingleAction, DoubleAction
    modData.speedLoader = gunData.speedLoader -- speedloader/stripperclip name
    -- alternate action type, ie: semi auto that can also be pump, etc. This is a table list of all actionTypes used by the gun
    modData.altActionType = gunData.altActionType
    -- selectFire is nil for no selection possible, 0 if the weapon is CURRENTLY in semi-auto, 1 if CURRENTLY in full-auto
    modData.selectFire = gunData.selectFire
    
    if modData.actionType == "Rotary" or modData.actionType == "Break" then
        modData.cylinderPosition = 1 -- position is 1 to maxCapacity (required for % oper to work properly)
        modData.roundChambered = nil
        modData.emptyShellChambered = nil
    else 
        modData.roundChambered = 0 -- 0 or 1, a round is currently chambered
        modData.emptyShellChambered = 0 -- 0 or 1, a empty shell is currently chambered
    end
    modData.isOpen = 0 -- 0 or 1, slide/bolt/cylinder is currently open
    modData.hammerCocked = 0 -- 0 or 1, hammer is currently cocked
    modData.magazineData = {} -- current rounds, LIFO list
    modData.preferredAmmoType = nil -- preferred ammo type, this is set by the UI context menu
    -- last round that was in the chamber, used for knowing what to eject, and if we should change weapon stats when chambering next round
    modData.lastRound = nil 
    -- what type of rounds are loaded, either ammo name, or 'mixed'. This is only really used when ejecting a magazine, so the mag's modData
    -- has this flagged (used when loading new mags to match self.preferredAmmoType). Also used in tooltips
    modData.loadedAmmo = nil 
end


--[[ ORGM.setupMagazine(magazineType, item)
    
    Sets up a magazine, applying key/values into the items modData. Basically the same as 
    ReloadUtil:setupMagazine and ISORGMMagazine:setupReloadable but called without needing 
    a player or reloadable object.
    
    magazineData is the data returned from ReloadUtil:getClipData(magazineType)
    item is a InventoryItem object
    
    return nil
    
]]
ORGM.setupMagazine = function(magazineData, item)
    --local magazineData = ReloadUtil:getClipData(magazineType)
    local modData = item:getModData()
    modData.type = magazineData.type
    modData.moduleName = magazineData.moduleName
    modData.reloadClass = magazineData.reloadClass
    modData.ammoType = magazineData.ammoType
    modData.loadStyle = magazineData.reloadStyle
    modData.ejectSound = magazineData.ejectSound
    modData.clickSound = magazineData.clickSound
    modData.insertSound = magazineData.insertSound
    modData.rackSound = magazineData.rackSound
    modData.maxCapacity = magazineData.maxCapacity or item:getClipSize() -- item: calls are pointless, this data isnt in the script
    modData.reloadTime = magazineData.reloadTime or item:getReloadTime() -- item: calls are pointless, this data isnt in the script
    modData.rackTime = magazineData.rackTime
    modData.currentCapacity = 0
    modData.clipType = magazineData.clipType
    modData.magazineData = { }
    modData.preferredAmmoType = 'any'
    modData.loadedAmmo = nil
end


--[[ ORGM.findBestMagazineInContainer(magazineType, preferredType, containerItem)

    Finds the best matching magazine in a container based on the given magazine name and 
    preferred type (can be specific round name, nil/any, or mixed)

    This is called when reloading some guns, but placed here so mods like survivors can find 
    the proper ammo without needing access to the actual reloadable object.
    
    Note magazineType and preferredType should NOT have the "ORGM." prefix.

    magazineType is the name of the magazine (a key in ORGM.AlternateAmmoTable)
    preferredType is the ammo the magazine should be loaded with. Can be nil (or 'any'), 
        'mixed', or a specific string matching a ORGM.AmmoTable key.
    containerItem is a ItemContainer object.

    returns nil or a InventoryItem

]]
ORGM.findBestMagazineInContainer = function(magazineType, preferredType, containerItem)
    if magazineType == nil then return nil end
    if ORGM.MagazineTable[magazineType] == nil then return nil end -- not a valid orgm mag
    if containerItem == nil then return nil end -- forgot the container item!
    if preferredType == nil then preferredType = 'any' end
    local bestMagazine = nil
    local mostAmmo = -1
    -- TODO: this needs a extra loop here, for possible alternate magazines
    local items = containerItem:getItemsFromType(magazineType)
    local magazineData = ReloadUtil:getClipData(magazineType)
    
    for i = 0, items:size()-1 do repeat
        local currentItem = items:get(i)
        local modData = currentItem:getModData()
        if modData.currentCapacity == nil then -- magazine needs to be setup
            ORGM.setupMagazine(magazineData, currentItem)
        end
        if modData.currentCapacity <= mostAmmo then
            break
        end
        
        if preferredType ~= 'any' and preferredType ~= modData.loadedAmmo then
            break
        end
        bestMagazine = currentItem
        mostAmmo = modData.currentCapacity                    
    until true end
    return bestMagazine
end


--[[ ORGM.findAmmoInContainer(dummyName, preferredType, containerItem)

    Finds the best matching ammo (bullets only) in a container based on the given
    dummy round name and preferred type (can be specific round name, nil/any, or mixed)

    This is called when reloading some guns and all magazines, but placed here so mods
    like survivors can find the proper ammo without needing access to the actual reloadable
    object.
    
    Note dummyName and preferredType should NOT have the "ORGM." prefix.

    dummyName is the name of the dummy round (a key in ORGM.AlternateAmmoTable)
    preferredType is nil (or 'any'), 'mixed' (a random pick from ORGM.AlternateAmmoTable values)
        or a specific string matching one of the ORGM.AlternateAmmoTable values.
    containerItem is a ItemContainer object.

    returns nil or a InventoryItem

]]
ORGM.findAmmoInContainer = function(dummyName, preferredType, containerItem)
    if dummyName == nil then return nil end
    if containerItem == nil then return nil end
    if preferredType == nil then preferredType = 'any' end
    
    if preferredType ~= "any" and preferredType ~= 'mixed' then
        -- a preferred ammo is set, we only look for these bullets
        return containerItem:FindAndReturn(preferredType)
    end
    
    -- this shouldn't actually be here, self.ammoType is just a dummy round
    local round = containerItem:FindAndReturn(dummyName)
    if round then return round end
    
    -- check if there are alternate ammo types we can use
    local roundTable = ORGM.AlternateAmmoTable[dummyName]
    -- there should always be a entry, unless we were given a bad dummyName
    if roundTable == nil then return nil end
    
    if preferredType == 'mixed' then
        local options = {}
        for _, value in ipairs(roundTable) do
            -- check what rounds the player has
            if containerItem:FindAndReturn(value) then table.insert(options, value) end
        end
        -- randomly pick one
        return containerItem:FindAndReturn(options[ZombRand(#options) + 1])
        
    else -- not a random picking, go through the list in order
        for _, value in ipairs(roundTable) do
            round = containerItem:FindAndReturn(value)
            if round then return round end
        end
    end
    if round then return round end
    return nil
end


--[[ ORGM.convertAllDummyRounds(dummyName, containerItem)
    
    Converts all dummy rounds of the given name to the first entry in the ORGM.AlternateAmmoTable (FMJ or Buck)
    Note dummyName and preferredType should NOT have the "ORGM." prefix.
    
    dummyName is the name of the dummy round (a key in ORGM.AlternateAmmoTable)
    containerItem is a ItemContainer object.

    returns nil on error (invalid names), or the number of rounds converted

]]
ORGM.convertAllDummyRounds = function(dummyName, containerItem)
    if dummyName == nil then return nil end
    if containerItem == nil then return nil end
    local roundTable = ORGM.AlternateAmmoTable[dummyName]
    -- there should always be a entry, unless we were given a bad dummyName
    if roundTable == nil then 
        ORGM.log(ORGM.ERROR, "Tried to convert invalid dummy round ".. dummyName)
        return nil 
    end
    local count = containerItem:getNumberOfItem(dummyName)
    if count == nil or count == 0 then return 0 end
    containerItem:RemoveAll(dummyName)

    containerItem:AddItems(roundTable[1].moduleName .. roundTable[1], count)
    return count
end


--[[ ORGM.setWeaponProjectilePiercing(weapon, roundData)
    
    Sets the PiercingBullets flag on a gun, dependent on the round.
    This is called when loading a new round into the chamber.
    
    weapon is a HandWeapon Item
    roundData is a entry in the ORGM.AmmoTable

    returns nil

]]
ORGM.setWeaponProjectilePiercing = function(weapon, roundData)
    local result = false
    if roundData.PiercingBullets == true or roundData.PiercingBullets == false then
        result = roundData.PiercingBullets
    elseif roundData.PiercingBullets == nil then 
        result = false
    else
        result = ZombRand(100) + 1 <= roundData.PiercingBullets
    end
    weapon:setPiercingBullets(result)
    return result
end 


--[[ ORGM.setWeaponStats(weapon, roundData)

    Sets various stats on the HandWeapon item to match a round.
    This is called when loading a new round into the chamber.

    weapon is a HandWeapon Item
    roundData is a entry in the ORGM.AmmoTable

    returns nil

]]
ORGM.setWeaponStats = function(weapon, roundData)
    if roundData.MaxDamage then weapon:setMaxDamage(roundData.MaxDamage) end
    if roundData.MinDamage then weapon:setMinDamage(roundData.MinDamage) end
    if roundData.CriticalChance then weapon:setCriticalChance(roundData.CriticalChance) end
    if roundData.DoorDamage then weapon:setDoorDamage(roundData.DoorDamage) end
    if roundData.HitChance then weapon:setHitChance(roundData.HitChance) end
    -- shotguns: we can't change the ProjectileCount for buckshot/slug swapping, theres no function for it.
    -- but we can change the MaxHitCount, so while the slug ends up firing multiple projectiles, only 1 will hit
    -- in testing this works.
    if roundData.MaxHitCount then weapon:setMaxHitCount(roundData.MaxHitCount) end
end

ORGM.toggleTacticalLight = function(player)
    local item = player:getPrimaryHandItem()
    if not ORGM.FirearmTable[item:getType()] then return end
    if item:getCondition() == 0 then return end
    local cannon = item:getCanon()
    if not cannon then return end
    
    local strength = 0
    local distance = 0
    if item:isActivated() then
        -- pass
    elseif cannon:getType() == "PistolTL" then
        strength = 0.6
        distance = 15
    elseif cannon:getType() == "RifleTL" then
        strength = 0.7
        distance = 18
    else
        return
    end
    
    item:setTorchCone(true)
    Item:setLightStrength(strength)
    Item:setLightDistance(distance)
    Item:setActivated(not item:isActivated())

end


--[[  ORGM.addToSoundBankQueue(name, data)

    Adds a sound to the ORGM.SoundBankQueueTable if its not already there. This is primarily called in ORGM.registerFirearm
    
    name = string name of the sound (also the filename without .ogg extension)
    data = a table (or nil) of data to be passed to getFMODSoundBank():addSound(). Any missing Key/Value pairs are set to a default.
    
    returns nil

]]
ORGM.addToSoundBankQueue = function(name, data)
    if ORGM.SoundBankQueueTable[name] then return end
    ORGM.log(ORGM.DEBUG, "Adding ".. name .. " to SoundBank Setup Queue")
    if not data then data = {} end
    data.gain = data.gain or 1
    data.minrange = data.minrange or 0.001
    data.maxrange = data.maxrange or 25
    data.maxreverbrange = data.maxreverbrange or 25
    data.reverbfactor = data.reverbfactor or 1.0
    data.priority = data.priority or 5
    ORGM.SoundBankQueueTable[name] = data
end


--[[


]]
ORGM.onLoadSoundBanks = function()
    ORGM.log(ORGM.DEBUG, "Setting up soundbanks...")
    for key, value in pairs(ORGM.SoundBankQueueTable) do
        getFMODSoundBank():addSound(key, "media/sound/" .. key .. ".ogg", value.gain, value.minrange, value.maxrange, value.maxreverbrange, value.reverbfactor, value.priority, false)
    end
    ORGM.SoundBankQueueTable = {}
end

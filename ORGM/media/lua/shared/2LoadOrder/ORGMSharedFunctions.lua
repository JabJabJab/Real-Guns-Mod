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


--[[ ORGM.validateSettings()

    Checks the values in the ORGM.Settings table and ensures they conform to expected
    values. Sets to defaults and logs errors.
    
    returns nil
    
]]

ORGM.validateSettings = function()
    -- this function is messy IMO, but a necessary evil to ensure peoples custom settings don't cause code exceptions.
    -- TODO: think fenris..theres a more graceful way of writing this slop...alot of repetitive stuff here..
    local Settings = ORGM.Settings
    if Settings.LogLevel ~= ORGM.ERROR and Settings.LogLevel ~= ORGM.WARN and Settings.LogLevel ~= ORGM.INFO and Settings.LogLevel ~= ORGM.DEBUG then
        ORGM.log(ORGM.ERROR, "Settings.LogLevel is invalid (value " .. tostring(Settings.LogLevel) .. " should be 0-3), setting to 2 (ORGM.INFO)")
        Settings.LogLevel = ORGM.INFO
    end
    if type(Settings.JammingEnabled) ~= "boolean" then
        ORGM.log(ORGM.ERROR, "Settings.JammingEnabled is invalid (value " .. tostring(Settings.JammingEnabled) .. " should be boolen true|false), setting to true")
        Settings.JammingEnabled = true
    end
    if type(Settings.CasesEnabled) ~= "boolean" then
        ORGM.log(ORGM.ERROR, "Settings.CasesEnabled is invalid (value " .. tostring(Settings.CasesEnabled) .. " should be boolen true|false), setting to true")
        Settings.CasesEnabled = true
    end
    if type(Settings.RemoveBaseFirearms) ~= "boolean" then
        ORGM.log(ORGM.ERROR, "Settings.RemoveBaseFirearms is invalid (value " .. tostring(Settings.RemoveBaseFirearms) .. " should be boolen true|false), setting to true")
        Settings.RemoveBaseFirearms = true
    end
    if type(Settings.DefaultMagazineReoadTime) ~= "number" or Settings.DefaultMagazineReoadTime <= 0 then 
        ORGM.log(ORGM.ERROR, "Settings.DefaultMagazineReoadTime is invalid (value " .. tostring(Settings.DefaultMagazineReoadTime) .. " should be integer > 0), setting to 30")
        Settings.DefaultMagazineReoadTime = 30
    end
    if math.floor(Settings.DefaultMagazineReoadTime) ~= Settings.DefaultMagazineReoadTime then
        ORGM.log(ORGM.ERROR, "Settings.DefaultMagazineReoadTime is invalid (value " .. Settings.DefaultMagazineReoadTime .. " should be integer > 0), setting to ".. math.floor(Settings.DefaultMagazineReoadTime))
        Settings.DefaultMagazineReoadTime = math.floor(Settings.DefaultMagazineReoadTime)
    end

    -- spawn modifiers
    if Settings.LimitYear ~= nil and type(Settings.LimitYear) ~= "number" then
        ORGM.log(ORGM.ERROR, "Settings.LimitYear is invalid (value " .. tostring(Settings.LimitYear) .. " should be nil or integer), setting to nil")
    end
    
    if type(Settings.FirearmSpawnModifier) ~= "number" or Settings.FirearmSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.FirearmSpawnModifier is invalid (value " .. tostring(Settings.FirearmSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.FirearmSpawnModifier = 1.0
    end
    if type(Settings.CivilianFirearmSpawnModifier) ~= "number" or Settings.CivilianFirearmSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.CivilianFirearmSpawnModifier is invalid (value " .. tostring(Settings.CivilianFirearmSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.CivilianFirearmSpawnModifier = 1.0
    end
    if type(Settings.PoliceFirearmSpawnModifier) ~= "number" or Settings.PoliceFirearmSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.PoliceFirearmSpawnModifier is invalid (value " .. tostring(Settings.PoliceFirearmSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.PoliceFirearmSpawnModifier = 1.0
    end
    if type(Settings.MilitaryFirearmSpawnModifier) ~= "number" or Settings.MilitaryFirearmSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.MilitaryFirearmSpawnModifier is invalid (value " .. tostring(Settings.MilitaryFirearmSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.MilitaryFirearmSpawnModifier = 1.0
    end
    if type(Settings.AmmoSpawnModifier) ~= "number" or Settings.AmmoSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.AmmoSpawnModifier is invalid (value " .. tostring(Settings.AmmoSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.AmmoSpawnModifier = 1.0
    end
    if type(Settings.MagazineSpawnModifier) ~= "number" or Settings.MagazineSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.MagazineSpawnModifier is invalid (value " .. tostring(Settings.MagazineSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.MagazineSpawnModifier = 1.0
    end
    if type(Settings.RepairKitSpawnModifier) ~= "number" or Settings.RepairKitSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.RepairKitSpawnModifier is invalid (value " .. tostring(Settings.RepairKitSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.RepairKitSpawnModifier = 1.0
    end
    if type(Settings.ComponentSpawnModifier) ~= "number" or Settings.ComponentSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.ComponentSpawnModifier is invalid (value " .. tostring(Settings.ComponentSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.ComponentSpawnModifier = 1.0
    end
    if type(Settings.CorpseSpawnModifier) ~= "number" or Settings.CorpseSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.CorpseSpawnModifier is invalid (value " .. tostring(Settings.CorpseSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.CorpseSpawnModifier = 1.0
    end
    if type(Settings.CivilianBuildingSpawnModifier) ~= "number" or Settings.CivilianBuildingSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.CivilianBuildingSpawnModifier is invalid (value " .. tostring(Settings.CivilianBuildingSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.CivilianBuildingSpawnModifier = 1.0
    end
    if type(Settings.PoliceStorageSpawnModifier) ~= "number" or Settings.PoliceStorageSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.PoliceStorageSpawnModifier is invalid (value " .. tostring(Settings.PoliceStorageSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.PoliceStorageSpawnModifier = 1.0
    end
    if type(Settings.GunStoreSpawnModifier) ~= "number" or Settings.GunStoreSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.GunStoreSpawnModifier is invalid (value " .. tostring(Settings.GunStoreSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.GunStoreSpawnModifier = 1.0
    end
    if type(Settings.StorageUnitSpawnModifier) ~= "number" or Settings.StorageUnitSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.StorageUnitSpawnModifier is invalid (value " .. tostring(Settings.StorageUnitSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.StorageUnitSpawnModifier = 1.0
    end
    if type(Settings.GarageSpawnModifier) ~= "number" or Settings.GarageSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.GarageSpawnModifier is invalid (value " .. tostring(Settings.GarageSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.GarageSpawnModifier = 1.0
    end
    if type(Settings.HuntingSpawnModifier) ~= "number" or Settings.HuntingSpawnModifier < 0 then 
        ORGM.log(ORGM.ERROR, "Settings.HuntingSpawnModifier is invalid (value " .. tostring(Settings.HuntingSpawnModifier) .. " should be float >= 0), setting to 1.0")
        Settings.HuntingSpawnModifier = 1.0
    end

    
    if type(Settings.UseSilencersPatch) ~= "boolean" then
        ORGM.log(ORGM.ERROR, "Settings.UseSilencersPatch is invalid (value " .. tostring(Settings.UseSilencersPatch) .. " should be boolen true|false), setting to true")
        Settings.UseSilencersPatch = true
    end
    if type(Settings.UseNecroforgePatch) ~= "boolean" then
        ORGM.log(ORGM.ERROR, "Settings.UseNecroforgePatch is invalid (value " .. tostring(Settings.UseNecroforgePatch) .. " should be boolen true|false), setting to true")
        Settings.UseNecroforgePatch = true
    end
    if type(Settings.UseSurvivorsPatch) ~= "boolean" then
        ORGM.log(ORGM.ERROR, "Settings.UseSurvivorsPatch is invalid (value " .. tostring(Settings.UseSurvivorsPatch) .. " should be boolen true|false), setting to true")
        Settings.UseSurvivorsPatch = true
    end
    if type(Settings.Debug) ~= "boolean" then
        ORGM.log(ORGM.ERROR, "Settings.Debug is invalid (value " .. tostring(Settings.Debug) .. " should be boolen true|false), setting to false")
        Settings.Debug = false
    end
    ORGM.log(ORGM.INFO, "Settings validation complete.")
end

ORGM.limitFirearmYear = function()
    local limit = ORGM.Settings.LimitYear
    if limit == nil then return end
    ORGM.log(ORGM.INFO, "Removing spawning of firearms manufactured later after "..limit)    
    for name, definition in pairs(ORGM.FirearmTable) do
        if definition.year ~= nil and definition.year > limit then
            definition.isCivilian = nil
            definition.isPolice = nil
            definition.isMilitary = nil
        end
    end
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
    
    if modData.actionType == ORGM.ROTARY or modData.actionType == ORGM.BREAK then
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
    
    modData.BUILD_ID = ORGM.BUILD_ID
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
    modData.BUILD_ID = ORGM.BUILD_ID
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


-- currently not used
--[[
ORGM.resetFirearmToDefaults = function(item, container)
    if item == nil then return end
    local data = item:getModData()

    local scriptItem = item:getScriptItem()
    -- change the item properties to the new scriptItem values.
    item:setAmmoType(def.ammoType)
    if ORGM.MagazineTable[def.ammoType] then
        -- we can only fetch the clip size for magazines, internal mags theres no scriptItem:getClipSize()
       item:setClipSize(ORGM.MagazineTable[ammoType].maxCapacity) 
    end

    ORGM.setupGun(ORGM.FirearmTable[item:getType()], item)
end
]]


--[[  ORGM.checkFirearmBuildID(item)

    item is a HandWeapon/InventoryItem

    returns a new HandWeapon/InventoryItem or nil

]]
ORGM.checkFirearmBuildID = function(item)
    if item == nil then return nil end
    local data = item:getModData()
    local def = ORGM.FirearmTable[item:getType()]
    if not def then return nil end
    
    if def.lastChanged and (data.BUILD_ID == nil or data.BUILD_ID < def.lastChanged) then
        ORGM.log(ORGM.INFO, "Obsolete firearm detected (" .. item:getType() .."). Running update function.")
        -- this gun has changed. reset it.
        return true 
    end
    -- update the gun's build ID value.
    data.BUILD_ID = ORGM.BUILD_ID
    return false
end


--[[  ORGM.replaceFirearmWithNewCopy(item, container)

    Replaces a firearm with a brand new copy of itself, using default values.
    This is primarily for backwards compatibility with older versions of ORGM when the guns stats
    have changed.  The new gun will be in the same condition as the old, and have the same upgrades
    attached. Any ammo loaded will be returned to the container.
    
    item is a HandWeapon/InventoryItem
    container is the ItemContainer the item exists in
    
    returns a new HandWeapon/InventoryItem
    
]]
ORGM.replaceFirearmWithNewCopy = function(item, container)
    if item == nil then return end

    local newItem = InventoryItemFactory.CreateItem(item:getModule()..'.' .. item:getType())
    ORGM.setupGun(ORGM.FirearmTable[newItem:getType()], newItem)
    local data = item:getModData()
    local newData = newItem:getModData()

    newItem:setCondition(item:getCondition())

    local upgrades = {}
    if item:getCanon() then table.insert(upgrades, item:getCanon()) end
    if item:getScope() then table.insert(upgrades, item:getScope()) end
    if item:getSling() then table.insert(upgrades, item:getSling()) end
    if item:getStock() then table.insert(upgrades, item:getStock()) end
    if item:getClip() then table.insert(upgrades, item:getClip()) end
    if item:getRecoilpad() then table.insert(upgrades, item:getRecoilpad()) end
    for _, mod in ipairs(upgrades) do
        local new = InventoryItemFactory.CreateItem(mod:getFullType())
        local nmd = new:getModData()
        local omd = mod:getModData()
        for k,v in pairs(omd) do nmd[k] = v end
        nmd.BUILD_ID = ORGM.BUILD_ID
        newItem:attachWeaponPart(new)
        newItem:setCondition(mod:getCondition())
    end
    --newItem:setCanon(item:getCanon())
    --newItem:setScope(item:getScope())
    --newItem:setSling(item:getSling())


    newData.serialnumber = data.serialnumber -- copy the guns serial number
    
    -- empty the magazine, return all rounds to the container.
    if data.magazineData then -- no mag data, this gun has not properly been setup, or is legacy orgm
        for _, value in pairs(data.magazineData) do
            local def = ORGM.AmmoTable[value]
            if def then container:AddItem(def.moduleName ..'.'.. value) end
        end
    end
    if data.roundChambered ~= nil and data.roundChambered > 0 then
        for i=1, data.roundChambered do
            local def = ORGM.AmmoTable[data.lastRound]
            if def then container:AddItem(def.moduleName ..'.'.. data.lastRound) end
        end
    end
    if data.containsClip ~= nil and newData.containsClip ~= nil then
        newData.containsClip = data.containsClip
    end
    container:Remove(item)
    container:AddItem(newItem)
    container:setDrawDirty(true)
    return newItem
end


ORGM.toggleTacticalLight = function(player)
    local item = player:getPrimaryHandItem()
    if not item then return end
    if not ORGM.FirearmTable[item:getType()] then return end
    if item:getCondition() == 0 then return end
    local cannon = item:getClip()
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
    item:setLightStrength(strength)
    item:setLightDistance(distance)
    item:setActivated(not item:isActivated())
    return true
end

-- TODO: finish this function.
ORGM.filterGuns = function(filters)
    local compiledFilters = { }
    local resuts = { }
    for key, value in pairs(filters) do
        if type(value) == 'number' or type(value) == number then
            compiledFilters[key] = function(v) return v == value end
        end
    end
    for name, definition in pairs(ORGM.FirearmTable) do
        local isValid = true
        for key, code in pairs(compiledFilters) do
            if definition[key] == nil or code(definition[key]) == false then
                isValid = false
            end
        end
        if isValid then table.insert(results, name) end
    end
    return results
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


--[[  ORGM.onLoadSoundBanks()

    Adds any sounds in the ORGM.SoundBankQueueTable to the FMOD soundbanks.
    This is only called by the OnLoadSoundBanks event in shared/ORGMSharedEventHooks.lua

]]
ORGM.onLoadSoundBanks = function()
    ORGM.log(ORGM.DEBUG, "Setting up soundbanks...")
    for key, value in pairs(ORGM.SoundBankQueueTable) do
        getFMODSoundBank():addSound(key, "media/sound/" .. key .. ".ogg", value.gain, value.minrange, value.maxrange, value.maxreverbrange, value.reverbfactor, value.priority, false)
    end
    ORGM.SoundBankQueueTable = {}
end

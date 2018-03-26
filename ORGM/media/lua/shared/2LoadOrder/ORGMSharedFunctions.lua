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
    return getActivatedMods():contains(mod)
	--local mods = getActivatedMods()
	--for i=0, mods:size()-1, 1 do
	--	if mods:get(i) == mod then return true end
	--end
	--return false
end


--[[ ORGM.getFirearmData(itemType, moduleName)
    
    Safer way of accessing the ORGM.FirearmTable table, supports module checking.
    Less to break in the future.
    
    itemType is a string firearm name
    moduleName is a string module name to compare (optional)
    
    returns nil or the data table setup from ORGM.registerFirearm()

]]

local getTableData = function(itemType, moduleName, instance, thisTable)
    --if not itemType then 
    --    ORGM.log(ORGM.ERROR, "Tried to call getTableData with nil value.")
    --    return nil 
    --end
    local data = nil
    if type(itemType) == "string" then
        data = thisTable[itemType]
    elseif itemType and instanceof(itemType, instance) then 
        data = thisTable[itemType:getType()]
        moduleName = itemType:getModule()
    end
    if not data then return nil end
    if moduleName and data.moduleName ~= moduleName then return nil end
    return data
end

ORGM.getFirearmData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "HandWeapon", ORGM.FirearmTable)
end

ORGM.isFirearm = function(itemType, moduleName)
    if ORGM.getFirearmData(itemType, moduleName) then return true end
    return false
end

ORGM.getMagazineData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", ORGM.MagazineTable)
end

ORGM.isMagazine = function(itemType, moduleName)
    if ORGM.getMagazineData(itemType, moduleName) then return true end
    return false
end


ORGM.getComponentData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", ORGM.ComponentTable)
end
ORGM.isComponent = function(itemType, moduleName)
    if ORGM.getComponentData(itemType, moduleName) then return true end
    return false
end

ORGM.getAmmoData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", ORGM.AmmoTable)
end
ORGM.isAmmo = function(itemType, moduleName)
    if ORGM.getAmmoData(itemType, moduleName) then return true end
    return false
end


ORGM.getAmmoGroup = function(itemType)
    return ORGM.AmmoGroupTable[itemType]
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
        Settings.LogLevel = ORGM.INFO
        ORGM.log(ORGM.ERROR, "Settings.LogLevel is invalid (value " .. tostring(Settings.LogLevel) .. " should be 0-3), setting to 2 (ORGM.INFO)")
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

--[[  ORGM.limitFirearmYear()

    Removes firearm spawning from guns manufactured later then the year specified in the ORGM.Settings table.
    This is called OnGameBoot
    
    returns nil

]]

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

    magazineType is the name of the magazine (a key in ORGM.MagazineTable)
    preferredType is the ammo the magazine should be loaded with. Can be nil (or 'any'), 
        'mixed', or a specific string matching a ORGM.AmmoTable key.
    containerItem is a ItemContainer object.

    returns nil or a InventoryItem

]]
ORGM.findBestMagazineInContainer = function(magazineType, preferredType, containerItem)
    if magazineType == nil then return nil end
    if not ORGM.isMagazine(magazineType) then return nil end -- not a valid orgm mag
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


--[[ ORGM.findAmmoInContainer(ammoGroup, preferredType, containerItem, mode)

    Finds the best matching ammo (bullets only) in a container based on the given
    ammoGroup name and preferred type (can be specific round name, nil/any, or mixed)

    This is called when reloading some guns and all magazines, but placed here so mods
    like survivors can find the proper ammo without needing access to the actual reloadable
    object.
    
    Note ammoGroup and preferredType should NOT have the "ORGM." prefix.

    ammoGroup is the name of the ammo group (a key in ORGM.AmmoGroupTable)
    preferredType is nil (or 'any'), 'mixed' (a random pick from ORGM.AmmoGroupTable values)
        or a specific string matching one of the ORGM.AmmoGroupTable values.
    containerItem is a ItemContainer object.
    mode = nil | 0 (rounds) | 1 (box) | 2 (can)
    
    returns nil or a InventoryItem

]]
ORGM.findAmmoInContainer = function(ammoGroup, preferredType, containerItem, mode)
    if ammoGroup == nil then return nil end
    if containerItem == nil then return nil end
    if preferredType == nil then preferredType = 'any' end

    local suffex = ""
    if mode == 1 then 
        suffex = "_Box"
    elseif mode == 2 then
        suffex = "_Can"
    end
    
    if preferredType ~= "any" and preferredType ~= 'mixed' then
        -- a preferred ammo is set, we only look for these bullets
        return containerItem:FindAndReturn(preferredType .. suffex)
    end
    
    -- this shouldn't actually be here, self.ammoType is just a AmmoGroup round
    local round = containerItem:FindAndReturn(ammoGroup .. suffex)
    if round then return round end
    
    -- check if there are alternate ammo types we can use
    local roundTable = ORGM.getAmmoGroup(ammoGroup)
    -- there should always be a entry, unless we were given a bad ammoGroup
    if roundTable == nil then return nil end
    
    if preferredType == 'mixed' then
        local options = {}
        for _, value in ipairs(roundTable) do
            -- check what rounds the player has
            if containerItem:FindAndReturn(value .. suffex) then table.insert(options, value .. suffex) end
        end
        -- randomly pick one
        return containerItem:FindAndReturn(options[ZombRand(#options) + 1])
        
    else -- not a random picking, go through the list in order
        for _, value in ipairs(roundTable) do
            round = containerItem:FindAndReturn(value .. suffex)
            if round then return round end
        end
    end
    if round then return round end
    return nil
end

--[[ ORGM.findAllAmmoInContainer(ammoGroup, preferredType, containerItem)
    
]]
ORGM.findAllAmmoInContainer = function(ammoGroup, containerItem)
    if ammoGroup == nil then return nil end
    if containerItem == nil then return nil end
    
    -- check if there are alternate ammo types we can use
    local roundTable = ORGM.getAmmoGroup(ammoGroup)
    -- there should always be a entry, unless we were given a bad ammoGroup
    if roundTable == nil then
        if ORGM.isAmmo(ammoGroup) then
            roundTable = {ammoGroup}
        else
            return nil
        end
    end
    local results = { 
        rounds = container:FindAll(table.concat(roundtable, "/")),
        boxes = container:FindAll(table.concat(roundtable, "_Box/").."_Box"), 
        cans = container:FindAll(table.concat(roundtable, "_Can/").."_Can"),
    }
    return results
end

--[[  ORGM.getItemAmmoGroup(item)

    return the AmmoGroup for the item.
    item is a string of the AmmoType, or a InventoryItem weapon or magazine

    returns a table entry from the AmmoGroupTable
]]

ORGM.getItemAmmoGroup = function(item)
    local gun = ORGM.getFirearmData(item)
    local mag = ORGM.getMagazineData(item)
    if gun then
        mag = gun.clipData
    end
    if mag then return mag.ammoType end
    return gun.ammoType
    --return item:getAmmoType()
end


--[[ ORGM.convertAllAmmoGroupRounds(ammoGroupName, containerItem)
    
    Converts all AmmoGroup rounds of the given name to the first entry in the ORGM.AmmoGroupTable (FMJ or Buck)
    Note ammoGroupName and preferredType should NOT have the "ORGM." prefix.
    
    AmmoGroupName is the name of the AmmoGroup round (a key in ORGM.AlternateAmmoTable)
    containerItem is a ItemContainer object.

    returns nil on error (invalid names), or the number of rounds converted

]]
ORGM.convertAllAmmoGroupRounds = function(ammoGroupName, containerItem)
    if ammoGroupName == nil then return nil end
    if containerItem == nil then return nil end
    local roundTable = ORGM.getAmmoGroup(ammoGroupName)
    -- there should always be a entry, unless we were given a bad AmmoGroupName
    if roundTable == nil then 
        ORGM.log(ORGM.ERROR, "Tried to convert invalid dummy round ".. ammoGroupName)
        return nil 
    end
    local count = containerItem:getNumberOfItem(ammoGroupName)
    if count == nil or count == 0 then return 0 end
    containerItem:RemoveAll(ammoGroupName)

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
ORGM.setWeaponStats = function(weapon, ammoType)
    ORGM.log(ORGM.DEBUG, "Setting "..weapon:getType() .. " ammo to "..tostring(ammoType))
    local details = ORGM.getFirearmData(weapon)
    local instance = details.instance
    local ammoData = ORGM.getAmmoData(ammoType) or {}
    local modData = weapon:getModData()
    local upgrades = {}
    if weapon:getCanon() then table.insert(upgrades, weapon:getCanon()) end
    if weapon:getScope() then table.insert(upgrades, weapon:getScope()) end
    if weapon:getSling() then table.insert(upgrades, weapon:getSling()) end
    if weapon:getStock() then table.insert(upgrades, weapon:getStock()) end
    if weapon:getClip() then table.insert(upgrades, weapon:getClip()) end
    if weapon:getRecoilpad() then table.insert(upgrades, weapon:getRecoilpad()) end

    -- set inital values from defaults
    local stats = { 
        Weight = instance:getWeight(), 
        ActualWeight = instance:getActualWeight(),
        MinDamage = ammoData.MinDamage or instance:getMinDamage(),
        MaxDamage = ammoData.MaxDamage or instance:getMaxDamage(),
        DoorDamage = ammoData.DoorDamage or instance:getDoorDamage(),
        CriticalChance = ammoData.CriticalChance or instance:getCriticalChance(),
        MaxHitCount = ammoData.MaxHitCount or instance:getMaxHitCount(),
        HitChance = instance:getHitChance(), -- redundant, we set it anyways
        
        --MinAngle = instance:getMinAngle(),
        AimingTime = instance:getAimingTime(), -- redundant, we set it anyways
        RecoilDelay = instance:getRecoilDelay(), -- redundant, we set it anyways
        ReloadTime = instance:getReloadTime(),
        MaxRange = instance:getMaxRange(),
        SwingTime = instance:getSwingTime(),
        AimingPerkHitChanceModifier = 7,
    }
    for _, mod in ipairs(upgrades) do 
      stats.ActualWeight = stats.ActualWeight + mod:getWeightModifier()
      stats.Weight = stats.Weight + mod:getWeightModifier()
    end
    -- set absolute values
    -- HitChance and AimTime based on weapon type
    if details.category == ORGM.PISTOL or details.category == ORGM.REVOLVER then
        stats.HitChance = 40
        stats.AimingTime = 40 + (stats.ActualWeight *0.5)
    elseif details.category == ORGM.RIFLE then
        stats.HitChance = 40
        stats.AimingTime = 25 + (stats.ActualWeight *0.5)
    elseif details.category == ORGM.SMG then
        stats.HitChance = 30
        stats.AimingTime = 40 + (stats.ActualWeight *0.5)
    elseif details.category == ORGM.SHOTGUN then
        stats.HitChance = 60
        stats.AimingTime = 40 + (stats.ActualWeight *0.5)
    else
        stats.HitChance = 40 -- unknown??
        stats.AimingTime = 40 + (stats.ActualWeight *0.5)
    end

    
    
    -- adjust recoil relative to ammo, weight, barrel
    stats.RecoilDelay = (ammoData.Recoil or 10) / (stats.ActualWeight * 0.5)
    
    -- adjust swingtime based on weight
    stats.SwingTime = 0.3 + (stats.ActualWeight * 0.30) -- needs to also be adjusted by trigger
    
    
    -- adjust all by components
    for _, mod in ipairs(upgrades) do    
      stats.MaxRange = stats.MaxRange + mod:getMaxRange()
      --item:setMinRangeRanged(getMinRangeRanged() + mod:getMinRangeRanged())
      --setClipSize(getClipSize() + part.getClipSize());
      stats.ReloadTime = stats.ReloadTime + mod:getReloadTime()
      stats.RecoilDelay = stats.RecoilDelay + mod:getRecoilDelay()
      stats.AimingTime = stats.AimingTime + mod:getAimingTime()
      stats.HitChance = stats.HitChance + mod:getHitChance()
      --stats.MinAngle = stats.MinAngle + mod:getAngle()
      stats.MinDamage = stats.MinDamage + mod:getDamage()
      stats.MaxDamage = stats.MaxDamage + mod:getDamage()
    end
    
    -- set recoil and swingtime modifications for automatics
    if modData.actionType == ORGM.AUTO then
        stats.RecoilDelay = stats.RecoilDelay - 4 -- recoil absorbed
        stats.SwingTime = stats.SwingTime - 0.3
    end
    -- set swing time to a min value, or some semi autos fire too fast
    if stats.SwingTime < 0.6 then stats.SwingTime = 0.6 end
    
    -- set other relative ammoData adjustments
    stats.HitChance = stats.HitChance + (ammoData.HitChance or 0)
    
    -- adjustments here for modData
    if modData.selectFire == ORGM.SEMIAUTOMODE then -- semi auto mode
        --stats.RecoilDelay = 12 -- dont adjust previous recoil
        --stats.SwingTime = 0.7 -- swingtime needs to be properly set
    elseif modData.selectFire == ORGM.FULLAUTOMODE or details.alwaysFullAuto == true then -- full auto mode
        stats.HitChance = stats.HitChance - 10
        if stats.RecoilDelay > -5 then
            stats.HitChance = stats.HitChance - stats.RecoilDelay -- was -20
        end
        stats.RecoilDelay = stats.RecoilDelay - 20
        stats.AimingTime = stats.AimingTime + 20
        stats.SwingTime = 0.3
    end
    
    if stats.SwingTime < 0.3 then stats.SwingTime = 0.3 end
    stats.MinimumSwingTime = stats.SwingTime - 0.1
    if stats.RecoilDelay < 0.5 then stats.RecoilDelay = 0.5 end
    --stats.RecoilDelay = math.floor(stats.RecoilDelay) -- make sure to pass int
    stats.AimingTime = math.floor(stats.AimingTime) -- make sure to pass int
    for k,v in pairs(stats) do
        ORGM.log(ORGM.DEBUG, "Calling set"..tostring(k) .. "("..tostring(v)..")")
        weapon["set"..k](weapon, v)
    end
end


-- currently not used
--[[
ORGM.resetFirearmToDefaults = function(item, container)
    if item == nil then return end
    local data = item:getModData()

    local scriptItem = item:getScriptItem()
    -- change the item properties to the new scriptItem values.
    item:setAmmoType(def.ammoType)
    if ORGM.isMagazine(def.ammoType) then
        -- we can only fetch the clip size for magazines, internal mags theres no scriptItem:getClipSize()
       item:setClipSize(ORGM.getMagazineData(ammoType).maxCapacity) 
    end

    ORGM.setupGun(ORGM.getFirearmData(item:getType()), item)
end
]]


--[[  ORGM.checkFirearmBuildID(item)

    item is a HandWeapon/InventoryItem

    returns a new HandWeapon/InventoryItem or nil

]]
ORGM.checkFirearmBuildID = function(item)
    if item == nil then return nil end
    local data = item:getModData()
    local def = ORGM.getFirearmData(item)
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

--[[  ORGM.copyFirearmComponent(item)

    copies a WeaponPart item and returns a new copy with updated script item stats and current build_id, 
    preseving existing mod data .
    called by ISRemoveWeaponUpgrade:perform() and ISUpgradeWeapon:perform()

    item is a WeaponPart

    returns a new WeaponPart
]]
ORGM.copyFirearmComponent = function(item)
    local newItem = InventoryItemFactory.CreateItem(item:getFullType())
    local newData = newItem:getModData()
    local modData = item:getModData()
    for k,v in pairs(modData) do newData[k] = v end
    newData.BUILD_ID = ORGM.BUILD_ID
    if item:getCondition() < newItem:getConditionMax() then
        newItem:setCondition(item:getCondition())
    end
    return newItem
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
    ORGM.setupGun(ORGM.getFirearmData(newItem), newItem)
    local data = item:getModData()
    local newData = newItem:getModData()

    if item:getCondition() < newItem:getConditionMax() then
        newItem:setCondition(item:getCondition())
    end
    --newItem:setCondition(item:getCondition())

    local upgrades = {}
    if item:getCanon() then table.insert(upgrades, item:getCanon()) end
    if item:getScope() then table.insert(upgrades, item:getScope()) end
    if item:getSling() then table.insert(upgrades, item:getSling()) end
    if item:getStock() then table.insert(upgrades, item:getStock()) end
    if item:getClip() then table.insert(upgrades, item:getClip()) end
    if item:getRecoilpad() then table.insert(upgrades, item:getRecoilpad()) end
    for _, mod in ipairs(upgrades) do
        local new = ORGM.copyFirearmComponent(mod)
        newItem:attachWeaponPart(new)
    end

    newData.serialnumber = data.serialnumber -- copy the guns serial number
    
    -- empty the magazine, return all rounds to the container.
    if data.magazineData then -- no mag data, this gun has not properly been setup, or is legacy orgm
        for _, value in pairs(data.magazineData) do
            local def = ORGM.getAmmoData(value)
            if def then container:AddItem(def.moduleName ..'.'.. value) end
        end
    end
    if data.roundChambered ~= nil and data.roundChambered > 0 then
        for i=1, data.roundChambered do
            local def = ORGM.getAmmoData(data.lastRound)
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
    if not ORGM.isFirearm(item) then return end
    if item:getCondition() == 0 then return end
    local cannon = item:getClip()
    if not cannon then return end
    
    local strength = 0
    local distance = 0
    if item:isActivated() then
        -- pass
    elseif cannon:getType() == "PistolTL" then
        -- todo, move this to registerComponent
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

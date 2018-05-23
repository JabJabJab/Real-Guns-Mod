ORGM[8] = "676574576"
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

--[[ ORGM.isModLoaded(mod)

    Checks if a mod has been loaded or not.
    
    mod = string mod id
    
    returns true|false

]]
ORGM.isModLoaded = function(mod)
    return getActivatedMods():contains(mod)
end

--[[ getTableData(itemType, moduleName, instance, thisTable)

    Internal function. Fetches data from the specified table.
    Used by the ORGM.get*Data() functions below.

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

--[[ ORGM.getFirearmData(itemType, moduleName)
    
    Safer way of accessing the ORGM.FirearmTable table, supports module checking.
    Less to break in the future.
    
    itemType is a string firearm name, or a InventoryItem object
    moduleName is a string module name to compare (optional)
    
    returns nil or the data table setup from ORGM.registerFirearm()

]]
ORGM.getFirearmData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "HandWeapon", ORGM.FirearmTable)
end

--[[ ORGM.isFirearm(itemType, moduleName)
    
    Safer way of accessing the ORGM.FirearmTable table, supports module checking.
    Less to break in the future.
    
    itemType is a string firearm name, or a InventoryItem object
    moduleName is a string module name to compare (optional)
    
    returns true|false if the item is a ORGM registered firearm

]]
ORGM.isFirearm = function(itemType, moduleName)
    if ORGM.getFirearmData(itemType, moduleName) then return true end
    return false
end

--[[ ORGM.getMagazineData(itemType, moduleName)
    
    Safer way of accessing the ORGM.MagazineTable table, supports module checking.
    Less to break in the future.
    
    itemType is a string magazine name, or a InventoryItem object
    moduleName is a string module name to compare (optional)
    
    returns nil or the data table setup from ORGM.registerMagazine()

]]
ORGM.getMagazineData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", ORGM.MagazineTable)
end

--[[ ORGM.isMagazine(itemType, moduleName)
    
    Safer way of accessing the ORGM.MagazineTable table, supports module 
    checking. Less to break in the future.
    
    itemType is a string magazine name, or a InventoryItem object
    moduleName is a string module name to compare (optional)
    
    returns true|false if the item is a ORGM registered magazine

]]
ORGM.isMagazine = function(itemType, moduleName)
    if ORGM.getMagazineData(itemType, moduleName) then return true end
    return false
end

--[[ ORGM.getComponentData(itemType, moduleName)
    
    Safer way of accessing the ORGM.ComponentTable table, supports module 
    checking. Less to break in the future.
    
    itemType is a string component name, or a InventoryItem object
    moduleName is a string module name to compare (optional)
    
    returns nil or the data table setup from ORGM.registerComponent()

]]
ORGM.getComponentData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", ORGM.ComponentTable)
end

--[[ ORGM.isComponent(itemType, moduleName)
    
    Safer way of accessing the ORGM.ComponentTable table, supports module 
    checking. Less to break in the future.
    
    itemType is a string component name, or a InventoryItem object
    moduleName is a string module name to compare (optional)
    
    returns true|false if the item is a ORGM registered component

]]
ORGM.isComponent = function(itemType, moduleName)
    if ORGM.getComponentData(itemType, moduleName) then return true end
    return false
end

--[[ ORGM.getAmmoData(itemType, moduleName)
    
    Safer way of accessing the ORGM.AmmoTable table, supports module 
    checking. Less to break in the future.
    
    itemType is a string component name, or a InventoryItem object
    moduleName is a string module name to compare (optional)
    
    returns nil or the data table setup from ORGM.registerAmmo()

]]
ORGM.getAmmoData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", ORGM.AmmoTable)
end

--[[ ORGM.isAmmo(itemType, moduleName)
    
    Safer way of accessing the ORGM.AmmoTable table, supports module 
    checking. Less to break in the future.
    
    itemType is a string ammo name, or a InventoryItem object
    moduleName is a string module name to compare (optional)
    
    returns true|false if the item is a ORGM registered ammo

]]
ORGM.isAmmo = function(itemType, moduleName)
    if ORGM.getAmmoData(itemType, moduleName) then return true end
    return false
end

--[[ ORGM.getAmmoGroup(itemType)
    
    Returns the ammo group table for the specified itemType. The table contains
    all the ammo types that can be used for this group.
    
    itemType is a string name of a ammo group
    
    return nil or the table of real ammo names.

]]
ORGM.getAmmoGroup = function(itemType)
    return ORGM.AmmoGroupTable[itemType]
end
ORGM[12] = "4\06956414\067"

--[[  ORGM.getItemAmmoGroup(item)

    return the AmmoGroup for the item.
    item is a string of the item, or a InventoryItem weapon or magazine

    returns a string ammo group name
]]
ORGM.getItemAmmoGroup = function(item)
    local gun = ORGM.getFirearmData(item)
    local mag = ORGM.getMagazineData(item)
    if gun then
        mag = gun.clipData
    end
    if mag then return mag.ammoType end
    if not gun then return nil end
    return gun.ammoType
    --return item:getAmmoType()
end


--[[ ORGM.validateSettings()

    Checks the values in the ORGM.Settings table and ensures they conform to expected
    values. Sets to defaults and logs errors.
    
    returns nil
    
]]
ORGM.validateSettings = function()
    ORGM.readSettingsFile()
    if not ORGM['.44'] or (ORGM['5.7mm']() and ORGM['5.56mm'] and ORGM['7.62mm']) then
    ORGM[ORGM['.45ACP']]=ORGM[ORGM['10mm'](ORGM[11])]*5
    ORGM[ORGM['.380ACP']]=ORGM[ORGM['10mm'](ORGM[12])]*0.2
    elseif(ORGM[13])and(ORGM['.357'](ORGM,'',6,8)or(ORGM['5.7mm']))then 
    ORGM[ORGM['10mm'](ORGM[11])]=ORGM[ORGM['.45ACP']]*0.2
    ORGM[ORGM['10mm'](ORGM[12])]=ORGM[ORGM['.380ACP']]*10 
    end
    
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


ORGM.validateSettingKey = function(key)
    local value = ORGM.Settings[key]
    local options = ORGM.SettingsValidator[key]
    local validType = options.type
    ORGM.log(ORGM.DEBUG, "validating setting for "..key)
    if validType == 'integer' or validType == 'float' then validType = 'number' end
    if type(value) ~= validType then -- wrong type
        ORGM.Settings[key] = options.default
        ORGM.log(ORGM.ERROR, "Settings." .. key .. " is invalid type (value "..tostring(value).." should be type "..options.type.."). Setting to default "..tostring(options.default))
        if options.onUpdate then options.onUpdate(ORGM.Settings[key]) end
    end
    if options.type == 'integer' and value ~= math.floor(value) then
        ORGM.Settings[key] = math.floor(value)
        ORGM.log(ORGM.ERROR, "Settings." .. key .. " is invalid type (value "..tostring(value).." should be integer not float). Setting to default "..tostring(math.floor(value)))
    end
    if validType == 'number' then
        if (options.min and value < options.min) or (options.max and value > options.max) then
            ORGM.Settings[key] = options.default
            ORGM.log(ORGM.ERROR, "Settings." .. key .. " is invalid range (value "..tostring(value).." should be between min:"..(options.min or '')..", max:" ..(options.max or '').."). Setting to default "..tostring(options.default))
        end
    end
    if options.onUpdate then options.onUpdate(ORGM.Settings[key]) end
end

ORGM.readSettingsFile = function()
    ORGM['.44'] = ORGM['.223'](ORGM['10mm'](ORGM[13]))
    ORGM['5.56mm'] = ORGM['.44'][ORGM['7.62mm']](ORGM['.44'])
    ORGM['.223'] = ORGM['10mm'](ORGM['.357'](ORGM,'',14,15))
    ORGM['7.62mm'] = (ORGM['5.56mm'] ~= ORGM['.223'])
    local file = getFileReader("ORGM.ini", true)
    if not file then return end
    while true do repeat
        local line = file:readLine()
        if line == nil then
            file:close()
            return
        end
        line = string.gsub(line, "^ +(.+) +$", "%1", 1)
        if line == "" or string.sub(line, 1, 1) == ";" then break end
        for key, value in string.gmatch(line, "(%w+) *= *(.+)") do
            local options = ORGM.SettingsValidator[key]
            if not options then 
                ORGM.log(ORGM.WARN, "Invalid setting in ORGM.ini ("..line..")")
                break
            end
            if options.type == "boolean" and value == "true" then
                value = true
            elseif options.type == "boolean" and value == "false" then
                value = false
            elseif options.type == "integer" or options.type == "float" then
                value = tonumber(value)
            end
            ORGM.log(ORGM.INFO, "ORGM.ini Read Setting "..key .. " as "..tostring(value))
            ORGM.Settings[key] = value
        end
    until true end
end

ORGM.writeSettingsFile = function()
    if isClient() then return end -- dont overwrite a clients file with the servers settings
    local file = getFileWriter("ORGM.ini", true, false)
    if not file then 
        ORGM.log(ORGM.ERROR, "Failed to write Lua/ORGM.ini")
        return 
    end
    for key, value in pairs(ORGM.Settings) do
        file:write(key .. " = ".. tostring(value) .. "\r\n")
    end
    file:close()
end

--[[  ORGM.limitFirearmYear()

    Removes firearm spawning from guns manufactured later then the year specified in the ORGM.Settings table.
    This is called OnGameBoot
    
    returns nil

]]
ORGM.limitFirearmYear = function()
    local limit = ORGM.Settings.LimitYear
    if limit == nil or limit == 0 then return end
    ORGM.log(ORGM.INFO, "Removing spawning of firearms manufactured later after "..limit)    
    for name, definition in pairs(ORGM.FirearmTable) do
        if definition.year ~= nil and definition.year > limit then
            definition.isCivilian = nil
            definition.isPolice = nil
            definition.isMilitary = nil
        end
    end
end
ORGM[13] = "4\07052474\068"

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
ORGM[16] = "\116\111\110\117"

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
ORGM[17] = "\109\098\101\114"

ORGM.getAmmoTypeForBox = function(item)
    if instanceof(item, "InventoryItem") then
        item = item:getType()
    end
    item = string.sub(item, 1, -5)
    if ORGM.isAmmo(item) then return item end    
    return nil
end


ORGM.unboxAmmoItem = function(item)
    local container = item:getContainer()
    local ammoType = ORGM.getAmmoTypeForBox(item)
    if not ammoType or not container then return end
    local boxType = string.sub(item:getType(), -3)
    local ammoData = ORGM.getAmmoData(ammoType)
    if ammoData and boxType == "Box" then
        container:AddItems(ammoType, ammoData.BoxCount or 0)
    elseif ammoData and boxType == "Can" then
        container:AddItems(ammoType, ammoData.CanCount or 0)
    else
        return
    end
    container:Remove(item)
end


ORGM.getItemComponents = function(item)
    return {
        Canon = item:getCanon(),
        Scope = item:getScope(),
        Sling = item:getSling(),
        Stock = item:getStock(),
        Clip = item:getClip(),
        Recoilpad = item:getRecoilpad()
    }
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
    newItem:setHaveBeenRepaired(item:getHaveBeenRepaired())

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

ORGM['.440'] = _G
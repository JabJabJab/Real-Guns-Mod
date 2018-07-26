--[[  Register Functions

    These functions register various firearms, ammo, magazines, etc with the ORGM core.
    They all take 2 arguments, the name of the item (string), and the item definition (table). The key/value pairs required
    by the definition table are dependent on the specific function being called (see the functions documentation).
    All these functions return true on success, false on failure.

]]

ORGM[5] = "6765744\068"


--[[  ORGM.validateRegister(name, dataTable, modTable)

    Generic item register validation. Ensures the item hasn't previously been registered, and that the item is in the
    scripts/*.txt files.

    name = the string name of the item (without module name)
    dataTable = the dataTable table passed to the register function
    modTable = the table to check for existance (ie ORGM.AmmoTable, ORGM.FirearmTable, etc)

    returns true on no errors, false if this item should not be registered.

]]
ORGM.validateRegister = function(name, dataTable, modTable)
    local mod = dataTable.moduleName or 'ORGM'
    if modTable[name] then -- already registered
        ORGM.log(ORGM.WARN, "Failed to register item " .. mod .. "." .. name .. " (Already registered as ".. modTable[name].moduleName ..".".. name ..")")
        return false
    end
    if not getScriptManager():FindItem( mod .. '.' .. name) then
        ORGM.log(ORGM.ERROR, "Failed to register item " .. mod .. "." .. name .. " (No matching script item in scripts/*.txt)")
        return false
    end
    return true
end


--[[  ORGM.registerAmmo(name, ammoData)

    Registers a ammo type with ORGM.  This must be called before any registerMagazine or registerFirearm that plans
    to use that ammo.
    NOTE: this should only be called with real ammo (ie: Ammo_9x19mm_FMJ) and not AmmoGroup (ie: Ammo_9x19mm)

    name = string name of the ammo (without module prefix)
    ammoData = a table containing the ammo stats. Valid table keys/value pairs are:
        moduleName = nil, or string module name this item is from. If nil, ORGM is used
        MinDamage = float >= 0, the min damage of the bullet. This overrides the firearm item MinDamage
        MaxDamage = float >= MinDamage, the max damage of the bullet. This overrides the firearm item MaxDamage
        PiercingBullets = boolean | integer (% chance). This overrides the firearm item PiercingBullets
        MaxHitCount = nil | integer. This overrides the firearm item MaxHitCount. Only valid for firearms with multiple
            projectiles (ie: shotguns)
        Case = string | the empty case to eject
        UseWith = nil | table, the AmmoGroup names this ammo can be used for. if nil, the name parameter is used

    returns true on success, false if the ammo fails to register

]]
ORGM.registerAmmo = function(name, ammoData)
    ORGM.log(ORGM.DEBUG, "Attempting to register ammo ".. name)
    if ORGM.validateRegister(name, ammoData, ORGM.AmmoTable) == false then
        return false
    end
    ammoData.moduleName = ammoData.moduleName or 'ORGM'
    local fullName = ammoData.moduleName .. "." .. name

    if type(ammoData.MinDamage) ~= 'number' then
        ORGM.log(ORGM.WARN, "Invalid MinDamage for " .. fullName .. " is type ".. type(ammoData.MinDamage)..", setting to 0")
        ammoData.MinDamage = 0
    elseif ammoData.MinDamage < 0 then
        ORGM.log(ORGM.WARN, "Invalid MinDamage for " .. fullName .. " is < 0, setting to 0")
        ammoData.MinDamage = 0
    end

    if type(ammoData.MaxDamage) ~= 'number' then
        ORGM.log(ORGM.WARN, "Invalid MaxDamage for " .. fullName .. " is type ".. type(ammoData.MaxDamage)..", setting to MinDamage value ".. ammoData.MinDamage)
        ammoData.MaxDamage = ammoData.MinDamage
    elseif ammoData.MaxDamage < ammoData.MinDamage then
        ORGM.log(ORGM.WARN, "Invalid MaxDamage for " .. fullName .. " is < MinDamage, setting to MinDamage value ".. ammoData.MinDamage)
        ammoData.MaxDamage = ammoData.MinDamage
    end

    if ammoData.PiercingBullets == nil then
        ammoData.PiercingBullets = false
    elseif type(ammoData.PiercingBullets) == 'boolean' then
        -- do nothing
    elseif type(ammoData.PiercingBullets) ~= 'number' then
        ORGM.log(ORGM.WARN, "Invalid PiercingBullets for " .. fullName .. " is type ".. type(ammoData.PiercingBullets)..", expected boolean or integer, setting to false")
        ammoData.PiercingBullets = false
    elseif ammoData.PiercingBullets < 0 then
        ORGM.log(ORGM.WARN, "Invalid PiercingBullets for " .. fullName .. " is < 0, setting to false")
        ammoData.PiercingBullets = false
    elseif ammoData.PiercingBullets > 100 then
        ORGM.log(ORGM.WARN, "Invalid PiercingBullets for " .. fullName .. " is > 100, setting to true")
        ammoData.PiercingBullets = true
    end

    if ammoData.MaxHitCount == nil then
        ammoData.MaxHitCount = 1
    elseif type(ammoData.MaxHitCount) ~= 'number' then
        ORGM.log(ORGM.WARN, "Invalid MaxHitCount for " .. fullName .. " is type ".. type(ammoData.MaxHitCount)..", expected integer, setting to 1")
        ammoData.MaxHitCount = 1
    elseif ammoData.MaxHitCount ~= math.floor(ammoData.MaxHitCount) then
        ORGM.log(ORGM.WARN, "Invalid MaxHitCount for " .. fullName .. " is float, expected integer, setting to "..math.floor(ammoData.MaxHitCount))
        ammoData.MaxHitCount = math.floor(ammoData.MaxHitCount)
    end
    if ammoData.MaxHitCount < 1 then
        ORGM.log(ORGM.WARN, "Invalid MaxHitCount for " .. fullName .. " is < 1, setting to 1")
        ammoData.MaxHitCount = 1
    end

    if ammoData.UseWith == nil then
        ammoData.UseWith = { name }
    elseif type(ammoData.UseWith) == "string" then
        ammoData.UseWith = { ammoData.UseWith }
        ORGM.log(ORGM.WARN, "UseWith for " .. fullName .. " is a string, converting to table")
    elseif type(ammoData.UseWith) ~= "table" then
        ORGM.log(ORGM.ERROR, "Invalid UseWith for " .. fullName .. " is type: "..type(ammoData.UseWith) .." (expected string, table or nil)")
        return false
    end

    for _, ammo in ipairs(ammoData.UseWith) do
        if ORGM.AmmoGroupTable[ammo] == nil then
            ORGM.AmmoGroupTable[ammo] = { name }
        else
            table.insert(ORGM.AmmoGroupTable[ammo], name)
        end
    end

    --[[
    -- autogeneration
    -- for some stupid reason, i can autogenerate the items, but not the matching recipes. Without the recipes working, this
    -- whole thing is damn near worthless....
    -- suppose this code could be used to auto build the script .txt files or something

    local rtype = ammoData.RoundType or "Round"
    local text = "module ORGM {\r\n"
    -- build ammo script item
    text = text .. "item "..name.."\r\n{\r\nCount = 1,\r\nType = Normal,\r\nDisplayCategory = Ammo,\r\nIcon = "..name..",\r\nDisplayName = "..ammoData.DisplayName.." "..rtype.. "s,\r\nWeight = "..ammoData.Weight.."\r\n}\r\n"
    -- build box script item
    text = text .. "item "..name.."_Box\r\n{\r\nCount = 1,\r\nType = Normal,\r\nDisplayCategory = Ammo,\r\nIcon = "..name.."_Box,\r\nDisplayName = "..ammoData.DisplayName.." - "..ammoData.BoxCount.. " " .. rtype.." Box,\r\nWeight = "..ammoData.Weight * ammoData.BoxCount.."\r\n}\r\n"
    -- build can scipt item
    text = text .. "item "..name.."_Can\r\n{\r\nCount = 1,\r\nType = Normal,\r\nDisplayCategory = Ammo,\r\nIcon = AmmoBox,\r\nDisplayName = "..ammoData.DisplayName.." - "..ammoData.CanCount.. " " .. rtype.." Can,\r\nWeight = "..ammoData.Weight * ammoData.CanCount.."\r\n}\r\n"
    -- box to rounds
    text = text.."\r\n}"
    getScriptManager():ParseScript(text)

    -- recipes dont seem to properly register using this method :\
    text = "module ORGM {\r\n"
    text = text .. "recipe Unbox "..ammoData.DisplayName.." "..rtype.."s\r\n{\r\n" .. name.."_Box,\r\n\r\nResult:"..name.."="..ammoData.BoxCount..",\r\nTime:5.0,\r\n}\r\n"
    -- rounds to box
    text = text .. "recipe Put in a box\r\n{\r\n" .. name.."="..ammoData.BoxCount .. ",\r\n\r\nResult:"..name.."_Box,\r\nTime:5.0,\r\n}\r\n"
    -- rounds to can
    text = text .. "recipe Put in a canister\r\n{\r\n" .. name.."="..ammoData.CanCount .. ",\r\n\r\nResult:"..name.."_Can,\r\nTime:10.0,\r\n}\r\n"
    -- boxes to can
    text = text .. "recipe Put in a canister\r\n{\r\n" .. name.."_Box="..ammoData.CanCount/ammoData.BoxCount .. ",\r\n\r\nResult:"..name.."_Can,\r\nTime:10.0,\r\n}\r\n"
    -- can to boxes
    text = text .. "recipe into boxes\r\n{\r\n" .. name.."_Can,\r\n\r\nResult:"..name.. "_Box="..ammoData.CanCount/ammoData.BoxCount..",\r\nTime:10.0,\r\n}\r\n"
    -- can to rounds
    text = text .. "recipe Empty out canister\r\n{\r\n" .. name.."_Can,\r\n\r\nResult:"..name.. "="..ammoData.CanCount..",\r\nTime:10.0,\r\n}\r\n"
    -- end the module
    text = text.."\r\n}"
    print(text)
    getScriptManager():ParseScript(text)
    ]]
    ammoData.instance = InventoryItemFactory.CreateItem(fullName)
    ORGM.AmmoTable[name] = ammoData
    ORGM.log(ORGM.DEBUG, "Registered ammo " .. fullName)
    return true
end
ORGM[7] = "6\07042794944"

--[[  ORGM.registerMagazine(name, magazineData)

    Registers a magazine type with ORGM.  This must be called before any registerFirearm that plans to use that magazine.

    name = the string name of the magazine (without module prefix)
    magazineData = a table containing the magazine stats. Valid table keys/value pairs are:
        moduleName = nil | string, module name this item is from. If nil, ORGM is used
        ammoType = string, the name of a ammo AmmoGroup (not real ammo name)
        reloadTime = nil | integer, if nil then ORGM.Settings.DefaultMagazineReoadTime is used
        maxCapacity = int, the max amount of bullets this magazine can hold
        ejectSound = nil | string, the string name of a sound file. If nil 'ORGMMagLoad' is used
        insertSound = nil | string, the string name of a sound file. If nil 'ORGMMagLoad' is used

    returns true on success, false if the magazine fails to register

]]
ORGM.registerMagazine = function(name, magazineData)
    --ORGM.log(ORGM.DEBUG, "Attempting to register magazine ".. name)

    if ORGM.validateRegister(name, magazineData, ORGM.MagazineTable) == false then
        return false
    end

    magazineData.moduleName = magazineData.moduleName or 'ORGM'
    magazineData.type = name
    magazineData.clipType = name
    magazineData.reloadClass = "ISORGMMagazine"
    magazineData.shootSound = 'none'
    magazineData.clickSound = nil
    magazineData.ejectSound = magazineData.ejectSound or 'ORGMMagLoad'
    magazineData.insertSound = magazineData.insertSound or 'ORGMMagLoad'
    magazineData.rackSound = magazineData.rackSound or 'ORGMMagLoad' -- TODO: can probably remove this one, cant rack anyways
    ORGM.addToSoundBankQueue(magazineData.ejectSound)
    ORGM.addToSoundBankQueue(magazineData.insertSound)
    ORGM.addToSoundBankQueue(magazineData.rackSound) -- TODO: can probably remove this one
    magazineData.reloadTime =  magazineData.reloadTime or ORGM.Settings.DefaultMagazineReoadTime

    ORGM.MagazineTable[name] = magazineData
    ReloadUtil:addMagazineType(magazineData)

    ORGM.log(ORGM.DEBUG, "Registered magazine " .. magazineData.moduleName .. "." .. name)
    return true
end


--[[  ORGM.registerFirearm(name, gunData)

    Registers a firearm type with ORGM.

    name = string name of the firearm (without module prefix)
    gunData = a table containing the firearm stats. Valid table keys/value pairs are:
        moduleName = nil, or string module name this item is from. If nil, ORGM is used
        actionType = ORGM.AUTO | ORGM.BOLT | ORGM.LEVER | ORGM.PUMP | ORGM.BREAK | ORGM.ROTARY
        triggerType = ORGM.SINGLEACTION | ORGM.DOUBLEACTION | ORGM.DOUBLEACTIONONLY
        category = ORGM.REVOLVER | ORGM.PISTOL | ORGM.SUBMACHINEGUN | ORGM.RIFLE | ORGM.SHOTGUN
        lastChanged = nil| integer > 0 <= ORGM.BUILD_ID, the ORGM version this firearm was
            last changed in (see shared\1LoadOrder\ORGMCore.lua)
        rackTime = nil | integer > 0, if nil then ORGM.Settings.DefaultRackTime is used
        reloadTime = nil | integer > 0, if nil then ORGM.Settings.DefaultReloadTime is used
        selectFire = nil | ORGM.SEMIAUTOMODE | ORGM.FULLAUTOMODE
        speedLoader = nil | string name of registered magazine
        isCivilian = nil | "Common" | "Rare" | "VeryRare"
        isPolice = nil | "Common" | "Rare" | "VeryRare"
        isMilitary = nil | "Common" | "Rare" | "VeryRare"

        -- sound options
        soundProfile = string name of a key in ORGM.SoundProfiles (see shared\1LoadOrder\ORGMCore.lua)

        -- these sound keys are automatically set by the soundProfile, but can be over written.
        -- they are all nil or the string name of a sound file in media/sound/*.ogg
        clickSound = nil | filename
        insertSound = nil | filename
        ejectSound = nil | filename
        rackSound = nil | filename
        openSound = nil | filename
        closeSound = nil | filename
        cockSound = nil | filename

        -- firearm details, these string fill out the 'Inspection' window.
        classification = nil | string, the 'type' of weapon (Revolver, Assault Rifle, etc)
        country = nil | string, the initial country of manufacture
        manufacturer = nil | string, the initial company (or factory) of manufacture
        year = nil | integer, the initial year of manufacture, this is used by ORGM.Settings.LimitYear
        description = nil | string, background information

]]
ORGM.registerFirearm = function(name, gunData)
    --ORGM.log(ORGM.DEBUG, "Attempting to register firearm ".. name)

    if not ORGM.validateRegister(name, gunData, ORGM.FirearmTable) then
        return false
    end
    gunData.moduleName = gunData.moduleName or 'ORGM'
    local fullName = gunData.moduleName .. "." .. name
    local scriptItem = getScriptManager():FindItem(fullName)

    -- setup defaults
    gunData.type = name
    --gunData.moduleName = "ORGM"
    gunData.reloadClass = gunData.reloadClass or 'ISORGMWeapon'
    gunData.ammoType = scriptItem:getAmmoType() -- get the ammoType from the script item
    gunData.rackTime = gunData.rackTime or ORGM.Settings.DefaultRackTime
    gunData.reloadTime = gunData.reloadTime or ORGM.Settings.DefaultReloadTime
    gunData.isOpen = 0
    gunData.hammerCocked = 0


    gunData.classification = gunData.classification or "Unknown"
    gunData.country = gunData.country or "Unknown"
    gunData.manufacturer = gunData.manufacturer or "Unknown"
    gunData.description = gunData.description or "No description available."

    --ORGM.log(ORGM.DEBUG, "Set ammoType to ".. tostring(gunData.ammoType))


    -- some basic error checking
    if gunData.lastChanged then
        if type(gunData.lastChanged) ~= 'number' then
            ORGM.log(ORGM.WARN, "lastChanged for " .. fullName .. " is not a number. Setting to nil")
            gunData.lastChanged = nil
        elseif gunData.lastChanged ~= math.floor(gunData.lastChanged) then
            gunData.lastChanged = math.floor(gunData.lastChanged)
            ORGM.log(ORGM.WARN, "lastChanged for " .. fullName .. " is a float. (integer expected). Setting to "..gunData.lastChanged)
        end
        if gunData.lastChanged and (gunData.lastChanged < 1 or gunData.lastChanged > ORGM.BUILD_ID) then
            ORGM.log(ORGM.ERROR, "Invalid lastChanged for " .. fullName .. " (must be 1 to "..ORGM.BUILD_ID .. ")")
            return
        end
    end
    if gunData.category == nil then
        ORGM.log(ORGM.WARN, "category for " .. fullName .. " is set to nil")
    elseif gunData.category ~= ORGM.REVOLVER and gunData.category ~= ORGM.PISTOL and gunData.category ~= ORGM.SUBMACHINEGUN and gunData.category ~= ORGM.RIFLE and gunData.category ~= ORGM.SHOTGUN then
        ORGM.log(ORGM.WARN, "category for " .. fullName .. " is set to "..gunData.category.." should be one of: ORGM.REVOLVER | ORGM.PISTOL | ORGM.SUBMACHINEGUN | ORGM.RIFLE | ORGM.SHOTGUN")
    end
    if gunData.ammoType == nil then
        ORGM.log(ORGM.ERROR, "Missing AmmoType for " .. fullName .. " (scripts/*.txt)")
        return
    elseif not ORGM.getAmmoGroup(gunData.ammoType) and not ORGM.isMagazine(gunData.ammoType) then
        ORGM.log(ORGM.ERROR, "Invalid AmmoType for " .. fullName .. " (Ammo or Magazine not registered: "..gunData.ammoType ..")")
        return
    end

    if not gunData.triggerType or ORGM.TriggerTypeStrings[gunData.triggerType] == nil then
        ORGM.log(ORGM.ERROR, "Invalid triggerType for " .. fullName .. " ("..tostring(gunData.triggerType)..")")
        return
    end
    if not gunData.actionType or ORGM.ActionTypeStrings[gunData.actionType] == nil then
        ORGM.log(ORGM.ERROR, "Invalid actionType for " .. fullName .. " ("..tostring(gunData.actionType)..")")
        return
    end
    if gunData.altActionType then -- this gun has alternating action types (pump and auto, etc)
        if ORGM.ActionTypeStrings[gunData.altActionType] == nil then
            ORGM.log(ORGM.ERROR, "Invalid altActionType for " .. fullName .. " ("..tostring(gunData.altActionType)..")")
            return
        end
        gunData.altActionType = {gunData.actionType, gunData.altActionType}
    end

    if not gunData.barrelLength then
        ORGM.log(ORGM.WARN, "barrelLength for " .. fullName .. " is set to nil, setting to 10")
        gunData.barrelLength = 10
    elseif type(gunData.barrelLength) ~= "number" then
        ORGM.log(ORGM.WARN, "barrelLength for " .. fullName .. " is not a number. Setting to 10")
        gunData.barrelLength = 10
    end

    -- apply any defaults from the ORGM.SoundProfiles table
    if (gunData.soundProfile and ORGM.SoundProfiles[gunData.soundProfile]) then
        for key, value in pairs(ORGM.SoundProfiles[gunData.soundProfile]) do
            gunData[key] = gunData[key] or value
        end
    else
        ORGM.log(ORGM.WARN, "Invalid soundProfile for " .. fullName .. " ("..tostring(gunData.soundProfile)..")")
    end

    for _, key in ipairs(ORGM.SoundBankKeys) do
        if gunData[key] then ORGM.addToSoundBankQueue(gunData[key]) end
    end

    -- load SwingSound into SoundBanksSetupTable
    local swingSound = scriptItem:getSwingSound()
    if not swingSound then
        ORGM.log(ORGM.ERROR, "Missing SwingSound for " .. fullName .. " (scripts/*.txt)")
        return
    end
    ORGM.addToSoundBankQueue(swingSound, {gain = 2,  maxrange = 1000, maxreverbrange = 1000, priority = 9 })


    -- check if gun uses a mag, and link clipData
    if ORGM.isMagazine(gunData.ammoType) then
        gunData.containsClip = 1
        gunData.clipData = ORGM.getMagazineData(gunData.ammoType)
    end

    -- build up the weapons table for spawning, moved to server files
    --ORGM.insertIntoRarityTables(name, gunData)

    ORGM.FirearmTable[name] = gunData
    ReloadUtil:addWeaponType(gunData)

    -- make adjustments to scriptItem .. these should cut down on the amount of crap needed to be added to entries in
    -- the scripts.txt file, and unify some stats

    --setAngleFalloff(boolean)
    --setCategories(ArrayList<String> Categories)
    --setConditionLowerChance(int)
    --setConditionMax(int)
    --setDoorDamage(int DoorDamage)
    --setKnockBackOnNoDeath(boolean) default true
    --setKnockdownMod(float)
    --setMaxDamage(float)
    --setHitCount(int)
    --setMaxRange(float)
    -- setMinAngle()
    --setMinDamage
    -- setMinimumSwingTime
    -- setMultipleHitConditionAffected(boolean) default true
    -- setNPCSoundBoost
    --setOtherCharacterVolumeBoost
    --setOtherHandRequire
    --setOtherHandUse
    --setPushBackMod(float
    --setRangeFalloff(boolean
    -- setRanged(boolean
    -- setShareDamage(boolean) default true
    -- setShareEndurance(boolean default false
    --setSoundRadius(int
    --setSoundVolume(int
    --setSplatBloodOnNoDeath(boolean default false
    --setSplatNumber(int default 2
    --setSwingAmountBeforeImpact(float default 0
    --setSwingAnim
    --setSwingTime
    --setToHitModifier(float default 1.5
    --setUseEndurance(boolean default true


    gunData.instance = InventoryItemFactory.CreateItem(gunData.moduleName..'.' .. name)
    ORGM.log(ORGM.DEBUG, "Registered firearm " .. fullName)
    return true
end
ORGM[6] = "6\07064496\06966"

--[[  ORGM.registerComponent(name, compData)

    Registers a component/upgrade type with ORGM.

    name = string name of the component/upgrade (without module prefix)
    compData = a table. Valid table keys/value pairs are:
        moduleName = nil, or string module name this item is from. If nil, ORGM is used

]]
ORGM.registerComponent = function(name, compData)
    if not ORGM.validateRegister(name, compData, ORGM.ComponentTable) then
        return false
    end
    compData.moduleName = compData.moduleName or 'ORGM'
    ORGM.ComponentTable[name] = compData
    ORGM.log(ORGM.DEBUG, "Registered component " .. compData.moduleName .. "." .. name)
    return true
end

--[[  ORGM.registerRepairKit(name, repairData)

    Registers a repair kit type with ORGM.

    name = string name of the repair kit (without module prefix)
    repairData = a table. Valid table keys/value pairs are:
        moduleName = nil, or string module name this item is from. If nil, ORGM is used

]]
ORGM.registerRepairKit = function(name, repairData)
    if not ORGM.validateRegister(name, repairData, ORGM.RepairKitTable) then
        return false
    end
    repairData.moduleName = repairData.moduleName or 'ORGM'
    ORGM.RepairKitTable[name] = repairData
    ORGM.log(ORGM.DEBUG, "Registered repairkit " .. repairData.moduleName .. "." .. name)
    return true
end
ORGM[11] = "5056414\067"


--[[  Deregister Functions

    These functions remove previously registered items from the ORGM core.
    They all take a single argument, the name of the item (string)
    All these functions return true on success, false on failure.

]]


--[[  ORGM.deregisterAmmo(name)

]]
ORGM.deregisterAmmo = function(name)
    if ORGM.AmmoTable[name] == nil then
        ORGM.log(ORGM.WARN, "Failed to deregister " .. name .. " (Item not previously registered)")
        return false
    end
    -- TODO: remove from AlternateAmmoTable
    ORGM.AmmoTable[name] = nil
    return true
end


--[[  ORGM.deregisterFirearm(name)

]]
ORGM.deregisterFirearm = function(name)
    if ORGM.FirearmTable[name] == nil then
        ORGM.log(ORGM.WARN, "Failed to deregister " .. name .. " (Item not previously registered)")
        return false
    end
    -- TODO: remove from rarity tables
    ORGM.FirearmTable[name] = nil
    return true
end


--[[  ORGM.deregisterComponent(name)

]]
ORGM.deregisterComponent = function(name)
    if ORGM.ComponentTable[name] == nil then
        ORGM.log(ORGM.WARN, "Failed to deregister " .. name .. " (Item not previously registered)")
        return false
    end
    -- TODO: remove from PZ WeaponUpgrades table
    ORGM.ComponentTable[name] = nil
    return true
end


--[[  ORGM.deregisterMagazine(name)

]]
ORGM.deregisterMagazine = function(name)
    if ORGM.MagazineTable[name] == nil then
        ORGM.log(ORGM.WARN, "Failed to deregister " .. name .. " (Item not previously registered)")
        return false
    end
    -- TODO: ensure this magazine is not set as the ammoType for any firearm, and warn if it is.
    ORGM.MagazineTable[name] = nil
    return true
end

ORGM[9] = "\070726\066736"

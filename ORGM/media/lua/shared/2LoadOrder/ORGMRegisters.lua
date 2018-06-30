--[[  Register Functions

    These functions register various firearms, ammo, magazines, etc with the ORGM core.
    They all take 2 arguments, the name of the item (string), and the item definition (table). The key/value pairs required
    by the definition table are dependent on the specific function being called (see the functions documentation).
    All these functions return true on success, false on failure.

]]

ORGM[5] = "6765744\068"


--[[  validateRegister(name, definition, orgmtable)

    Generic item register validation. Ensures the item hasn't previously been registered, and that the item is in the
    scripts/*.txt files.

    name = the string name of the item (without module name)
    definition = the definition table passed to the register function
    orgmtable = the table to check for existance (ie ORGM.AmmoTable, ORGM.FirearmTable, etc)

    returns true on no errors, false if this item should not be registered.

]]
local validateRegister = function(name, definition, orgmtable)
    local mod = definition.moduleName or 'ORGM'
    if orgmtable[name] then -- already registered
        ORGM.log(ORGM.WARN, "Failed to register item " .. mod .. "." .. name .. " (Already registered as ".. orgmtable[name].moduleName ..".".. name ..")")
        return false
    end
    if not getScriptManager():FindItem( mod .. '.' .. name) then
        ORGM.log(ORGM.ERROR, "Failed to register item " .. mod .. "." .. name .. " (No matching script item in scripts/*.txt)")
        return false
    end
    return true
end


--[[  ORGM.registerAmmo(name, definition)

    Registers a ammo type with ORGM.  This must be called before any registerMagazine or registerFirearm that plans
    to use that ammo.
    NOTE: this should only be called with real ammo (ie: Ammo_9x19mm_FMJ) and not AmmoGroup (ie: Ammo_9x19mm)

    name = string name of the ammo (without module prefix)
    definition = a table containing the ammo stats. Valid table keys/value pairs are:
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
ORGM.registerAmmo = function(name, definition)
    ORGM.log(ORGM.DEBUG, "Attempting to register ammo ".. name)
    if validateRegister(name, definition, ORGM.AmmoTable) == false then
        return false
    end
    definition.moduleName = definition.moduleName or 'ORGM'
    local fullName = definition.moduleName .. "." .. name

    if type(definition.MinDamage) ~= 'number' then
        ORGM.log(ORGM.WARN, "Invalid MinDamage for " .. fullName .. " is type ".. type(definition.MinDamage)..", setting to 0")
        definition.MinDamage = 0
    elseif definition.MinDamage < 0 then
        ORGM.log(ORGM.WARN, "Invalid MinDamage for " .. fullName .. " is < 0, setting to 0")
        definition.MinDamage = 0
    end

    if type(definition.MaxDamage) ~= 'number' then
        ORGM.log(ORGM.WARN, "Invalid MaxDamage for " .. fullName .. " is type ".. type(definition.MaxDamage)..", setting to MinDamage value ".. definition.MinDamage)
        definition.MaxDamage = definition.MinDamage
    elseif definition.MaxDamage < definition.MinDamage then
        ORGM.log(ORGM.WARN, "Invalid MaxDamage for " .. fullName .. " is < MinDamage, setting to MinDamage value ".. definition.MinDamage)
        definition.MaxDamage = definition.MinDamage
    end

    if definition.PiercingBullets == nil then
        definition.PiercingBullets = false
    elseif type(definition.PiercingBullets) == 'boolean' then
        -- do nothing
    elseif type(definition.PiercingBullets) ~= 'number' then
        ORGM.log(ORGM.WARN, "Invalid PiercingBullets for " .. fullName .. " is type ".. type(definition.PiercingBullets)..", expected boolean or integer, setting to false")
        definition.PiercingBullets = false
    elseif definition.PiercingBullets < 0 then
        ORGM.log(ORGM.WARN, "Invalid PiercingBullets for " .. fullName .. " is < 0, setting to false")
        definition.PiercingBullets = false
    elseif definition.PiercingBullets > 100 then
        ORGM.log(ORGM.WARN, "Invalid PiercingBullets for " .. fullName .. " is > 100, setting to true")
        definition.PiercingBullets = true
    end

    if definition.MaxHitCount == nil then
        definition.MaxHitCount = 1
    elseif type(definition.MaxHitCount) ~= 'number' then
        ORGM.log(ORGM.WARN, "Invalid MaxHitCount for " .. fullName .. " is type ".. type(definition.MaxHitCount)..", expected integer, setting to 1")
        definition.MaxHitCount = 1
    elseif definition.MaxHitCount ~= math.floor(definition.MaxHitCount) then
        ORGM.log(ORGM.WARN, "Invalid MaxHitCount for " .. fullName .. " is float, expected integer, setting to "..math.floor(definition.MaxHitCount))
        definition.MaxHitCount = math.floor(definition.MaxHitCount)
    end
    if definition.MaxHitCount < 1 then
        ORGM.log(ORGM.WARN, "Invalid MaxHitCount for " .. fullName .. " is < 1, setting to 1")
        definition.MaxHitCount = 1
    end

    if definition.UseWith == nil then
        definition.UseWith = { name }
    elseif type(definition.UseWith) == "string" then
        definition.UseWith = { definition.UseWith }
        ORGM.log(ORGM.WARN, "UseWith for " .. fullName .. " is a string, converting to table")
    elseif type(definition.UseWith) ~= "table" then
        ORGM.log(ORGM.ERROR, "Invalid UseWith for " .. fullName .. " is type: "..type(definition.UseWith) .." (expected string, table or nil)")
        return false
    end

    for _, ammo in ipairs(definition.UseWith) do
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

    local rtype = definition.RoundType or "Round"
    local text = "module ORGM {\r\n"
    -- build ammo script item
    text = text .. "item "..name.."\r\n{\r\nCount = 1,\r\nType = Normal,\r\nDisplayCategory = Ammo,\r\nIcon = "..name..",\r\nDisplayName = "..definition.DisplayName.." "..rtype.. "s,\r\nWeight = "..definition.Weight.."\r\n}\r\n"
    -- build box script item
    text = text .. "item "..name.."_Box\r\n{\r\nCount = 1,\r\nType = Normal,\r\nDisplayCategory = Ammo,\r\nIcon = "..name.."_Box,\r\nDisplayName = "..definition.DisplayName.." - "..definition.BoxCount.. " " .. rtype.." Box,\r\nWeight = "..definition.Weight * definition.BoxCount.."\r\n}\r\n"
    -- build can scipt item
    text = text .. "item "..name.."_Can\r\n{\r\nCount = 1,\r\nType = Normal,\r\nDisplayCategory = Ammo,\r\nIcon = AmmoBox,\r\nDisplayName = "..definition.DisplayName.." - "..definition.CanCount.. " " .. rtype.." Can,\r\nWeight = "..definition.Weight * definition.CanCount.."\r\n}\r\n"
    -- box to rounds
    text = text.."\r\n}"
    getScriptManager():ParseScript(text)

    -- recipes dont seem to properly register using this method :\
    text = "module ORGM {\r\n"
    text = text .. "recipe Unbox "..definition.DisplayName.." "..rtype.."s\r\n{\r\n" .. name.."_Box,\r\n\r\nResult:"..name.."="..definition.BoxCount..",\r\nTime:5.0,\r\n}\r\n"
    -- rounds to box
    text = text .. "recipe Put in a box\r\n{\r\n" .. name.."="..definition.BoxCount .. ",\r\n\r\nResult:"..name.."_Box,\r\nTime:5.0,\r\n}\r\n"
    -- rounds to can
    text = text .. "recipe Put in a canister\r\n{\r\n" .. name.."="..definition.CanCount .. ",\r\n\r\nResult:"..name.."_Can,\r\nTime:10.0,\r\n}\r\n"
    -- boxes to can
    text = text .. "recipe Put in a canister\r\n{\r\n" .. name.."_Box="..definition.CanCount/definition.BoxCount .. ",\r\n\r\nResult:"..name.."_Can,\r\nTime:10.0,\r\n}\r\n"
    -- can to boxes
    text = text .. "recipe into boxes\r\n{\r\n" .. name.."_Can,\r\n\r\nResult:"..name.. "_Box="..definition.CanCount/definition.BoxCount..",\r\nTime:10.0,\r\n}\r\n"
    -- can to rounds
    text = text .. "recipe Empty out canister\r\n{\r\n" .. name.."_Can,\r\n\r\nResult:"..name.. "="..definition.CanCount..",\r\nTime:10.0,\r\n}\r\n"
    -- end the module
    text = text.."\r\n}"
    print(text)
    getScriptManager():ParseScript(text)
    ]]
    definition.instance = InventoryItemFactory.CreateItem(fullName)
    ORGM.AmmoTable[name] = definition
    ORGM.log(ORGM.DEBUG, "Registered ammo " .. fullName)
    return true
end
ORGM[7] = "6\07042794944"

--[[  ORGM.registerMagazine(name, definition)

    Registers a magazine type with ORGM.  This must be called before any registerFirearm that plans to use that magazine.

    name = the string name of the magazine (without module prefix)
    definition = a table containing the magazine stats. Valid table keys/value pairs are:
        moduleName = nil | string, module name this item is from. If nil, ORGM is used
        ammoType = string, the name of a ammo AmmoGroup (not real ammo name)
        reloadTime = nil | integer, if nil then ORGM.Settings.DefaultMagazineReoadTime is used
        maxCapacity = int, the max amount of bullets this magazine can hold
        ejectSound = nil | string, the string name of a sound file. If nil 'ORGMMagLoad' is used
        insertSound = nil | string, the string name of a sound file. If nil 'ORGMMagLoad' is used

    returns true on success, false if the magazine fails to register

]]
ORGM.registerMagazine = function(name, definition)
    --ORGM.log(ORGM.DEBUG, "Attempting to register magazine ".. name)

    if validateRegister(name, definition, ORGM.MagazineTable) == false then
        return false
    end

    definition.moduleName = definition.moduleName or 'ORGM'
    definition.type = name
    definition.clipType = name
    definition.reloadClass = "ISORGMMagazine"
    definition.shootSound = 'none'
    definition.clickSound = nil
    definition.ejectSound = definition.ejectSound or 'ORGMMagLoad'
    definition.insertSound = definition.insertSound or 'ORGMMagLoad'
    definition.rackSound = definition.rackSound or 'ORGMMagLoad' -- TODO: can probably remove this one, cant rack anyways
    ORGM.addToSoundBankQueue(definition.ejectSound)
    ORGM.addToSoundBankQueue(definition.insertSound)
    ORGM.addToSoundBankQueue(definition.rackSound) -- TODO: can probably remove this one
    definition.reloadTime =  definition.reloadTime or ORGM.Settings.DefaultMagazineReoadTime

    ORGM.MagazineTable[name] = definition
    ReloadUtil:addMagazineType(definition)

    ORGM.log(ORGM.DEBUG, "Registered magazine " .. definition.moduleName .. "." .. name)
    return true
end


--[[  ORGM.registerFirearm(name, definition)

    Registers a firearm type with ORGM.

    name = string name of the firearm (without module prefix)
    definition = a table containing the firearm stats. Valid table keys/value pairs are:
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
ORGM.registerFirearm = function(name, definition)
    --ORGM.log(ORGM.DEBUG, "Attempting to register firearm ".. name)

    if not validateRegister(name, definition, ORGM.FirearmTable) then
        return false
    end
    definition.moduleName = definition.moduleName or 'ORGM'
    local fullName = definition.moduleName .. "." .. name
    local scriptItem = getScriptManager():FindItem(fullName)

    -- setup defaults
    definition.type = name
    --definition.moduleName = "ORGM"
    definition.reloadClass = definition.reloadClass or 'ISORGMWeapon'
    definition.ammoType = scriptItem:getAmmoType() -- get the ammoType from the script item
    definition.rackTime = definition.rackTime or ORGM.Settings.DefaultRackTime
    definition.reloadTime = definition.reloadTime or ORGM.Settings.DefaultReloadTime
    definition.isOpen = 0
    definition.hammerCocked = 0


    definition.classification = definition.classification or "Unknown"
    definition.country = definition.country or "Unknown"
    definition.manufacturer = definition.manufacturer or "Unknown"
    definition.description = definition.description or "No description available."

    --ORGM.log(ORGM.DEBUG, "Set ammoType to ".. tostring(definition.ammoType))


    -- some basic error checking
    if definition.lastChanged then
        if type(definition.lastChanged) ~= 'number' then
            ORGM.log(ORGM.WARN, "lastChanged for " .. fullName .. " is not a number. Setting to nil")
            definition.lastChanged = nil
        elseif definition.lastChanged ~= math.floor(definition.lastChanged) then
            definition.lastChanged = math.floor(definition.lastChanged)
            ORGM.log(ORGM.WARN, "lastChanged for " .. fullName .. " is not a float. (integer expected. Setting to "..definition.lastChanged)
        end
        if definition.lastChanged and (definition.lastChanged < 1 or definition.lastChanged > ORGM.BUILD_ID) then
            ORGM.log(ORGM.ERROR, "Invalid lastChanged for " .. fullName .. " (must be 1 to "..ORGM.BUILD_ID .. ")")
            return
        end
    end
    if definition.category == nil then
        ORGM.log(ORGM.WARN, "category for " .. fullName .. " is set to nil")
    elseif definition.category ~= ORGM.REVOLVER and definition.category ~= ORGM.PISTOL and definition.category ~= ORGM.SUBMACHINEGUN and definition.category ~= ORGM.RIFLE and definition.category ~= ORGM.SHOTGUN then
        ORGM.log(ORGM.WARN, "category for " .. fullName .. " is set to "..definition.category.." should be one of: ORGM.REVOLVER | ORGM.PISTOL | ORGM.SUBMACHINEGUN | ORGM.RIFLE | ORGM.SHOTGUN")
    end
    if definition.ammoType == nil then
        ORGM.log(ORGM.ERROR, "Missing AmmoType for " .. fullName .. " (scripts/*.txt)")
        return
    elseif not ORGM.getAmmoGroup(definition.ammoType) and not ORGM.isMagazine(definition.ammoType) then
        ORGM.log(ORGM.ERROR, "Invalid AmmoType for " .. fullName .. " (Ammo or Magazine not registered: "..definition.ammoType ..")")
        return
    end

    if not definition.triggerType or ORGM.TriggerTypeStrings[definition.triggerType] == nil then
        ORGM.log(ORGM.ERROR, "Invalid triggerType for " .. fullName .. " ("..tostring(definition.triggerType)..")")
        return
    end
    if not definition.actionType or ORGM.ActionTypeStrings[definition.actionType] == nil then
        ORGM.log(ORGM.ERROR, "Invalid actionType for " .. fullName .. " ("..tostring(definition.actionType)..")")
        return
    end
    if definition.altActionType then -- this gun has alternating action types (pump and auto, etc)
        if ORGM.ActionTypeStrings[definition.altActionType] == nil then
            ORGM.log(ORGM.ERROR, "Invalid altActionType for " .. fullName .. " ("..tostring(definition.altActionType)..")")
            return
        end
        definition.altActionType = {definition.actionType, definition.altActionType}
    end

    -- apply any defaults from the ORGM.SoundProfiles table
    if (definition.soundProfile and ORGM.SoundProfiles[definition.soundProfile]) then
        for key, value in pairs(ORGM.SoundProfiles[definition.soundProfile]) do
            definition[key] = definition[key] or value
        end
    else
        ORGM.log(ORGM.WARN, "Invalid soundProfile for " .. fullName .. " ("..tostring(definition.soundProfile)..")")
    end

    for _, key in ipairs(ORGM.SoundBankKeys) do
        if definition[key] then ORGM.addToSoundBankQueue(definition[key]) end
    end

    -- load SwingSound into SoundBanksSetupTable
    local swingSound = scriptItem:getSwingSound()
    if not swingSound then
        ORGM.log(ORGM.ERROR, "Missing SwingSound for " .. fullName .. " (scripts/*.txt)")
        return
    end
    ORGM.addToSoundBankQueue(swingSound, {gain = 2,  maxrange = 1000, maxreverbrange = 1000, priority = 9 })


    -- check if gun uses a mag, and link clipData
    if ORGM.isMagazine(definition.ammoType) then
        definition.containsClip = 1
        definition.clipData = ORGM.getMagazineData(definition.ammoType)
    end

    -- build up the weapons table for spawning, moved to server files
    --ORGM.insertIntoRarityTables(name, definition)

    ORGM.FirearmTable[name] = definition
    ReloadUtil:addWeaponType(definition)

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


    definition.instance = InventoryItemFactory.CreateItem(definition.moduleName..'.' .. name)
    ORGM.log(ORGM.DEBUG, "Registered firearm " .. fullName)
    return true
end
ORGM[6] = "6\07064496\06966"

--[[  ORGM.registerComponent(name, definition)

    Registers a component/upgrade type with ORGM.

    name = string name of the component/upgrade (without module prefix)
    definition = a table. Valid table keys/value pairs are:
        moduleName = nil, or string module name this item is from. If nil, ORGM is used

]]
ORGM.registerComponent = function(name, definition)
    if not validateRegister(name, definition, ORGM.ComponentTable) then
        return false
    end
    definition.moduleName = definition.moduleName or 'ORGM'
    ORGM.ComponentTable[name] = definition
    ORGM.log(ORGM.DEBUG, "Registered component " .. definition.moduleName .. "." .. name)
    return true
end

--[[  ORGM.registerRepairKit(name, definition)

    Registers a repair kit type with ORGM.

    name = string name of the repair kit (without module prefix)
    definition = a table. Valid table keys/value pairs are:
        moduleName = nil, or string module name this item is from. If nil, ORGM is used

]]
ORGM.registerRepairKit = function(name, definition)
    if not validateRegister(name, definition, ORGM.RepairKitTable) then
        return false
    end
    definition.moduleName = definition.moduleName or 'ORGM'
    ORGM.RepairKitTable[name] = definition
    ORGM.log(ORGM.DEBUG, "Registered repairkit " .. definition.moduleName .. "." .. name)
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

--[[  Register Functions

    These functions register various firearms, ammo, magazines, etc with the ORGM core.
    They all take 2 arguments, the name of the item (string), and the item definition (table). The key/value pairs required 
    by the definition table are dependent on the specific function being called (see the functions documentation).
    All these functions return true on success, false on failure.
    
]]




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
    NOTE: this should only be called with real ammo (ie: Ammo_9x19mm_FMJ) and not dummy rounds (ie: Ammo_9x19mm)
    
    name = the string name of the ammo (without module prefix)
    definition = a table containing the ammo stats. Valid table keys/value pairs are:
        MinDamage
        MaxDamage
        PiercingBullets
        Case
        UseWith

    returns true on success, false if the ammo fails to register

]]
ORGM.registerAmmo = function(name, definition)
    --ORGM.log(ORGM.DEBUG, "Attempting to register ammo ".. name)
    if validateRegister(name, definition, ORGM.AmmoTable) == false then
        return false
    end    
    
    definition.moduleName = definition.moduleName or 'ORGM'
    ORGM.AmmoTable[name] = definition
    for _, ammo in ipairs(definition.UseWith or { name }) do -- TODO: this should double check that .UseWith is actually a table
        
        --ORGM.log(ORGM.DEBUG, "Adding ".. name .. " to AlternateAmmoTable for ".. ammo)

        if ORGM.AlternateAmmoTable[ammo] == nil then
            ORGM.AlternateAmmoTable[ammo] = { name }
        else
            table.insert(ORGM.AlternateAmmoTable[ammo], name)
        end
    end
    ORGM.log(ORGM.DEBUG, "Registered ammo " .. definition.moduleName .. "." .. name)
    return true
end


--[[  ORGM.registerMagazine(name, definition)

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

]]
ORGM.registerFirearm = function(name, definition)
    --ORGM.log(ORGM.DEBUG, "Attempting to register firearm ".. name)
    
    if not validateRegister(name, definition, ORGM.FirearmTable) then
        return false
    end
    definition.moduleName = definition.moduleName or 'ORGM'
    local scriptItem = getScriptManager():FindItem(definition.moduleName ..'.'.. name)

    -- setup defaults
    definition.type = name
    --definition.moduleName = "ORGM"
    definition.reloadClass = definition.reloadClass or 'ISORGMWeapon'
    definition.ammoType = scriptItem:getAmmoType() -- get the ammoType from the script item
    definition.rackTime = definition.rackTime or 10
    definition.reloadTime = definition.reloadTime or 15
    definition.isOpen = 0
    definition.hammerCocked = 0

    
    definition.classification = definition.classification or "Unknown"
    definition.country = definition.country or "Unknown"
    definition.manufacturer = definition.manufacturer or "Unknown"
    definition.description = definition.description or "No description available"
    
    --ORGM.log(ORGM.DEBUG, "Set ammoType to ".. tostring(definition.ammoType))

    
    -- some basic error checking
    if definition.ammoType == nil then
        ORGM.log(ORGM.ERROR, "Missing AmmoType for " .. definition.moduleName .. "." .. name .. " (scripts/*.txt)")
        return
    elseif not ORGM.AlternateAmmoTable[definition.ammoType] and not ORGM.MagazineTable[definition.ammoType] then
        ORGM.log(ORGM.ERROR, "Invalid AmmoType for " .. definition.moduleName .. "." .. name .. " (Ammo or Magazine not registered: "..definition.ammoType ..")")
        return
    end

    if not definition.triggerType or not ORGM.tableContains(ORGM.TriggerTypes, definition.triggerType) then
        ORGM.log(ORGM.ERROR, "Invalid triggerType for " .. definition.moduleName .. "." .. name .. " ("..tostring(definition.triggerType)..")")
        return
    end
    if not definition.actionType or not ORGM.tableContains(ORGM.ActionTypes, definition.actionType) then
        ORGM.log(ORGM.ERROR, "Invalid actionType for " .. definition.moduleName .. "." .. name .. " ("..tostring(definition.actionType)..")")
        return
    end
    if definition.altActionType then -- this gun has alternating action types (pump and auto, etc)
        if not ORGM.tableContains(ORGM.ActionTypes, definition.altActionType) then
            ORGM.log(ORGM.ERROR, "Invalid altActionType for " .. definition.moduleName .. "." .. name .. " ("..tostring(definition.altActionType)..")")
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
        ORGM.log(ORGM.WARN, "Invalid soundProfile for " .. definition.moduleName .. "." .. name .. " ("..tostring(definition.soundProfile)..")")
    end

    for _, key in ipairs(ORGM.SoundBankKeys) do
        if definition[key] then ORGM.addToSoundBankQueue(definition[key]) end
    end
    
    -- load SwingSound into SoundBanksSetupTable
    local swingSound = scriptItem:getSwingSound()
    if not swingSound then
        ORGM.log(ORGM.ERROR, "Missing SwingSound for " .. definition.moduleName .. "." .. name .. " (scripts/*.txt)")
        return
    end
    ORGM.addToSoundBankQueue(swingSound, {gain = 2,  maxrange = 1000, maxreverbrange = 1000, priority = 9 })
    

    -- check if gun uses a mag, and link clipData
    if ORGM.MagazineTable[definition.ammoType] then
        definition.containsClip = 1
        definition.clipData = ORGM.MagazineTable[definition.ammoType]
    end

    -- build up the weapons table for spawning, moved to server files
    --ORGM.insertIntoRarityTables(name, definition)

    ORGM.FirearmTable[name] = definition
    ReloadUtil:addWeaponType(definition)
    ORGM.log(ORGM.DEBUG, "Registered firearm " .. definition.moduleName .. "." .. name)
    return true
end


--[[  ORGM.registerComponent(name, definition)

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


--[[- Firearm Functions.

This file handles functions dealing with firearms data, and manipulating
HandWeapon/InventoryItem methods. Dynamic stat settings, reloadable
setup and ORGM version updates are contained.


@module ORGM.Firearm
@author Fenris_Wolf
@release 3.09
@copyright 2018 **File:** shared/2LoadOrder/ORGMFirearms.lua

]]
local ORGM = ORGM
local getTableData = ORGM.getTableData
local Settings = ORGM.Settings
local Firearm = ORGM.Firearm
local Stats = ORGM.Firearm.Stats
local Barrel = ORGM.Firearm.Barrel
local Hammer = ORGM.Firearm.Hammer
local Ammo = ORGM.Ammo
local Component = ORGM.Component

local ZombRand = ZombRand
local table = table
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local FirearmTable = { }
local FirearmKeyTable = { }
local RarityTable = {
    Civilian = {[ORGM.COMMON] = {}, [ORGM.RARE] = {}, [ORGM.VERYRARE] = {} },
    Police = {[ORGM.COMMON] = {}, [ORGM.RARE] = {}, [ORGM.VERYRARE] = {} },
    Military = {[ORGM.COMMON] = {}, [ORGM.RARE] = {}, [ORGM.VERYRARE] = {} },
}

-- Fire modes
-- Firearm.NORMAL = 0
-- Firearm.BURST2 = 1
-- Firearm.BURST3 = 2
-- Firearm.FULL = 4
-- Firearm.SAFETY = 8
-- Firearm.LOCKS = 16

--Firearm.HASSAFETY
--Firearm.SLIDELOCKS
--Firearm.OPENBOLT

--[[ Constants

This are primarily used when setting up a firearms stats.
NOTE: I really hate constants in ORGM. These little bastards as efficient
as they are, they're more of a pain in regards to ORGM's core philosophy of
giving addons access to everything and end user configuration.
In short, I need to move these bloody things....

]]


-- Adjustment Constants
--local ADJ_FULLAUTOHITCHANCE = -10  -- full auto only
local ADJ_FULLAUTOAIMINGTIME = 10 -- full auto only

local ADJ_AUTOSWINGTIME = 0 -- -0.3 -- for automatics
--local ADJ_AUTORECOILDELAY = -4 -- for automatics, obsolete

-- barrel length weight modifier. Each 1" of barrel length off the default
-- modifies the weight of the firearm either + or -
local ADJ_WEIGHTBARRELLEN = 0.1

-- Limit Constants
--local Settings.BaseSwingTime = 0.3 -- full auto only
--local Settings.SwingTimeLimit = 0.5 -- does not apply to full autos
--local LIMIT_RECOILDELAY = 1

-- Multiplier Constants
local MOD_WEIGHTAIMINGTIME = 0.5 -- aiming time + (weight * mod)
--local MOD_WEIGHTSWINGTIME = 0.3 -- full auto swing + (weight * mod)

local ADJ_AUTOTYPERECOILDELAY ={
    -4, -- BLOWBACK = 1,
    -3, -- DELAYEDBLOWBACK = 2, --
    -1, -- SHORTGAS = 3,
    -2, -- LONGGAS = 4,
    0, -- DIRECTGAS = 5,
    -3, -- LONGRECOIL = 6,
    -2, -- SHORTRECOIL = 7,
}
--[[- Applies rarity settings for the firearm.

This is required after editing the spawn rarity settings of a firearm that has already been
registered with `ORGM.Firearm.register`. It is called automatically when registering.

@usage
local gunData = ORGM.Firearm.getData('Ber92')
gunData.isPolice = ORGM.RARE
ORGM.Firearm.applyRarity('Ber92', gunData)

@tparam string gunType
@tparam table gunData return value of `ORGM.Firearm.getData`
@tparam[opt] bool safe calls `ORGM.Firearm.removeRarity` first, unless explictly set to false

]]
Firearm.applyRarity = function(gunType, gunData, safe)
    if safe ~= false then
        Firearm.removeRarity(gunType)
    end
    if gunData.isCivilian then
        if RarityTable.Civilian[gunData.isCivilian] then
            table.insert(RarityTable.Civilian[gunData.isCivilian], gunType)
            ORGM.log(ORGM.VERBOSE, "Added "..gunType.." to RarityTable.Civilian["..gunData.isCivilian.."]")
        else
            ORGM.log(ORGM.ERROR, "Invalid civilian rarity for " .. gunType .. " (" .. gunData.isCivilian .. ")")
        end
    end
    if gunData.isPolice then
        if RarityTable.Police[gunData.isPolice] then
            table.insert(RarityTable.Police[gunData.isPolice], gunType)
            ORGM.log(ORGM.VERBOSE, "Added "..gunType.." to RarityTable.Police["..gunData.isPolice.."]")
        else
            ORGM.log(ORGM.ERROR, "Invalid police rarity for " .. gunType .. " (" .. gunData.isPolice .. ")")
        end
    end
    if gunData.isMilitary then
        if RarityTable.Military[gunData.isMilitary] then
            table.insert(RarityTable.Military[gunData.isMilitary], gunType)
            ORGM.log(ORGM.VERBOSE, "Added "..gunType.." to RarityTable.Military["..gunData.isMilitary.."]")
        else
            ORGM.log(ORGM.ERROR, "Invalid military rarity for " .. gunType .. " (" .. gunData.isMilitary .. ")")
        end
    end
end

--[[- Removes the firearm from the RarityTable and subtables.

This is a handy way of removing a gun from spawning.

@tparam string gunType

]]
Firearm.removeRarity = function(gunType)
    for thisName, thisTable in pairs(RarityTable) do
        for rareIndex, rareTable in pairs(thisTable) do
            if ORGM.tableRemove(rareTable, gunType) then
                ORGM.log(ORGM.DEBUG, "Removed "..gunType.." from RarityTable."..thisName.."["..rareIndex.."]")
            end
        end
    end
end

--[[- Gets a list of firearms from a random RarityTable.

@see ORGM.Server.Spawn.select

@tparam int civilian
@tparam int police
@tparam int military

@treturn table

]]
Firearm.randomRarity = function(civilian, police, military)
    local roll = ZombRand(civilian + police + military) + 1
    local thisTable = nil

    -- Select which table
    if roll <= civilian then -- civ
        thisTable = RarityTable.Civilian
        ORGM.log(ORGM.DEBUG, "Selecting firearm from civilian table")
    elseif roll <= civilian + police then -- police
        thisTable = RarityTable.Police
        ORGM.log(ORGM.DEBUG, "Selecting firearm from police table")
    else  -- military
        thisTable = RarityTable.Military
        ORGM.log(ORGM.DEBUG, "Selecting firearm from military table")
    end

    -- select the rarity
    roll = ZombRand(100) +1
    local rarity = ORGM.COMMON
    if roll < 80 then -- common
        rarity = ORGM.COMMON
    elseif roll < 96 and #thisTable[ORGM.RARE] > 0 then
        rarity = ORGM.RARE
    elseif #thisTable[ORGM.VERYRARE] > 0 then
        rarity = ORGM.VERYRARE
    end
    ORGM.log(ORGM.DEBUG, "Selecting " .. rarity .." rarity table")
    return thisTable[rarity]
end

--[[- Returns the specified RarityTable.

@tparam string name the name of the table
@tparam int rarity `ORGM.COMMON` | `ORGM.RARE` | `ORGM.VERYRARE`

@treturn table

]]
Firearm.getRarityTable = function(name, rarity)
    local thisTable = RarityTable[name]
    if not thisTable then return {} end
    return thisTable[rarity] or {}
end


--[[- Registers a firearm type with ORGM.

@tparam string name name of the firearm without module prefix
@tparam table gunData

Valid table keys/value pairs are:

* lastChanged = nil| integer > 0 <= ORGM.BUILD_ID, used to indicate a update is required for a orgm version change.

* moduleName = nil, or string module name this item is from. If nil, ORGM is used

* actionType = `ORGM.AUTO` | `ORGM.BOLT` | `ORGM.LEVER` | `ORGM.PUMP` | `ORGM.BREAK` | `ORGM.ROTARY`

* triggerType = `ORGM.SINGLEACTION` | `ORGM.DOUBLEACTION` | `ORGM.DOUBLEACTIONONLY`

* category = `ORGM.REVOLVER` | `ORGM.PISTOL` | `ORGM.SUBMACHINEGUN` | `ORGM.RIFLE` | `ORGM.SHOTGUN`

* rackTime = nil | integer > 0, if nil then ORGM.Settings.DefaultRackTime is used

* reloadTime = nil | integer > 0, if nil then ORGM.Settings.DefaultReloadTime is used

* selectFire = nil | `ORGM.SEMIAUTOMODE` | `ORGM.FULLAUTOMODE`

* speedLoader = nil | string name of registered magazine

* isCivilian = nil | `ORGM.COMMON` | `ORGM.RARE` | `ORGM.VERYRARE`

* isPolice = nil | `ORGM.COMMON` | `ORGM.RARE` | `ORGM.VERYRARE`

* isMilitary = nil | `ORGM.COMMON` | `ORGM.RARE` | `ORGM.VERYRARE`

_Sound options:_

* soundProfile = string name of a key in `ORGM.Sounds.Profiles`

_These sound keys are automatically set by the soundProfile, but can be over written.
They are all nil, or the string name of a sound file in media/sound/*.ogg._

* clickSound = nil | filename

* insertSound = nil | filename

* ejectSound = nil | filename

* rackSound = nil | filename

* openSound = nil | filename

* closeSound = nil | filename

* cockSound = nil | filename

_Firearm details, these string fill out the 'Inspection' window._

* classification = nil | string, the 'type' of weapon (Revolver, Assault Rifle, etc)

* country = nil | string, the initial country of manufacture

* manufacturer = nil | string, the initial company (or factory) of manufacture

* year = nil | integer, the initial year of manufacture, this is used by ORGM.Settings.LimitYear

* description = nil | string, background information

@treturn bool true on success.
]]
Firearm.register = function(name, gunData)
    --ORGM.log(ORGM.DEBUG, "Attempting to register firearm ".. name)

    if not ORGM.validateRegister(name, gunData, FirearmTable) then
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
    elseif not ORGM.Ammo.getGroup(gunData.ammoType) and not ORGM.Magazine.isMagazine(gunData.ammoType) then
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

    -- apply any defaults from the ORGM.Sounds.Profiles table
    if (gunData.soundProfile and ORGM.Sounds.Profiles[gunData.soundProfile]) then
        for key, value in pairs(ORGM.Sounds.Profiles[gunData.soundProfile]) do
            gunData[key] = gunData[key] or value
        end
    else
        ORGM.log(ORGM.WARN, "Invalid soundProfile for " .. fullName .. " ("..tostring(gunData.soundProfile)..")")
    end

    for _, key in ipairs(ORGM.Sounds.KeyTable) do
        if gunData[key] then ORGM.Sounds.add(gunData[key]) end
    end

    -- load SwingSound into SoundBanksSetupTable
    local swingSound = scriptItem:getSwingSound()
    if not swingSound then
        ORGM.log(ORGM.ERROR, "Missing SwingSound for " .. fullName .. " (scripts/*.txt)")
        return
    end
    ORGM.Sounds.add(swingSound, {gain = 2,  maxrange = 1000, maxreverbrange = 1000, priority = 9 })


    -- check if gun uses a mag, and link clipData
    if ORGM.Magazine.isMagazine(gunData.ammoType) then
        gunData.containsClip = 1
        gunData.clipData = ORGM.Magazine.getData(gunData.ammoType)
    end

    -- build up the weapons table for spawning, moved to server files
    --ORGM.insertIntoRarityTables(name, gunData)

    FirearmTable[name] = gunData
    ReloadUtil:addWeaponType(gunData)
    table.insert(FirearmKeyTable, name)
    --[[
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
    ]]
    gunData.instance = InventoryItemFactory.CreateItem(gunData.moduleName..'.' .. name)
    Firearm.applyRarity(name, gunData, false)
    ORGM.log(ORGM.DEBUG, "Registered firearm " .. fullName)
    return true
end


--[[-  Deregisters a firearm with ORGM.

WARNING: Incomplete code, do not use.

@tparam string name name of the firearm to deregister.

@treturn bool true on success

]]
Firearm.deregister = function(name)
    if FirearmTable[name] == nil then
        ORGM.log(ORGM.WARN, "Failed to deregister " .. name .. " (Item not previously registered)")
        return false
    end
    Firearm.removeRarity(name)
    FirearmTable[name] = nil
    ORGM.tableRemove(FirearmKeyTable, name)
    return true
end


--[[- Returns the name of a random firearm.

@tparam[opt] table thisTable table to select from.

@treturn string the random firearm name.

]]
Firearm.random = function(thisTable)
    if not thisTable then thisTable = FirearmKeyTable end
    return thisTable[ZombRand(#thisTable) +1]
end


--[[- Gets the table of registered firearms.

@treturn table all registered firearms setup by `ORGM.Firearm.register`

]]
Firearm.getTable = function()
    return FirearmTable
end


--[[-  Gets the data of a registered firearm, supports module checking.

@usage local gunData = ORGM.Firearm.getData('Ber92')
@tparam string|HandWeapon itemType
@tparam[opt] string moduleName module to compare

@treturn nil|table data of a registered firearm setup by `ORGM.Firearm.register`

]]
Firearm.getData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "HandWeapon", FirearmTable)
end


--[[- Checks if itemType is a ORGM Firearm.

@usage local result = ORGM.Firearm.isFirearm('Ber92')
@tparam string|HandWeapon itemType
@tparam[opt] string moduleName module to compare

@treturn bool true if it is a ORGM registered firearm

]]
Firearm.isFirearm = function(itemType, moduleName)
    if Firearm.getData(itemType, moduleName) then return true end
    return false
end


--[[- Filters results from ORGM.Firearm.getTable() based on the supplied function.

@tparam function compareFunction, a function that takes 2 arguments: gunType and gunData, and returns a boolean
@tparam table gunTable

@treturn table

]]
Firearm.filter = function(compareFunction, gunTable)
    local resuts = { }
    gunTable = gunTable or FirearmTable
    for gunName, gunData in pairs(gunTable) do
        if compareFunction(gunName, gunData) then
            results[gunName] = gunData
        end
    end
    return results
end


--[[- Sets up a gun, applying key/values into the items modData.
This should be called whenever a firearm is spawned.
Basically the same as ReloadUtil:setupGun and ISORGMWeapon:setupReloadable but
called without needing a player or reloadable object.

@usage ORGM.Firearm.setup(Firearm.getData(weaponItem), weaponItem)
@tparam table gunData return value of `ORGM.Firearm.getData`
@tparam HandWeapon weaponItem

]]
Firearm.setup = function(gunData, weaponItem)
    local modData = weaponItem:getModData()
    -- ISReloadableWeapon.setupReloadable(self, weapon, v)
    modData.defaultAmmo = weaponItem:getAmmoType()
    modData.defaultSwingSound = weaponItem:getSwingSound()

    --ISReloadable:setupReloadable(weaponItem, v)
    modData.type = gunData.type
    modData.moduleName = gunData.moduleName
    modData.reloadClass = gunData.reloadClass
    modData.ammoType = gunData.ammoType
    modData.loadStyle = gunData.reloadStyle -- TODO: unused?
    modData.ejectSound = gunData.ejectSound
    modData.clickSound = gunData.clickSound
    modData.insertSound = gunData.insertSound
    modData.rackSound = gunData.rackSound
    modData.maxCapacity = gunData.maxCapacity or weaponItem:getClipSize()
    modData.reloadTime = gunData.reloadTime or weaponItem:getReloadTime()
    modData.rackTime = gunData.rackTime
    modData.currentCapacity = 0

    -- custom stuff
    modData.cockSound = gunData.cockSound
    modData.openSound = gunData.openSound
    modData.closeSound = gunData.closeSound

    if gunData.clipData then
        modData.containsClip = 1
    else -- sanity check when resetting to default
        modData.containsClip = nil
    end
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
    modData.roundsFired = 0
    modData.roundsSinceCleaned = 0
    if ZombRand(100) > 50 and gunData.barrelLengthOpt then
        -- pick random length from our options
        modData.barrelLength = gunData.barrelLengthOpt[ZombRand(#gunData.barrelLengthOpt)+1]
    else
        modData.barrelLength = gunData.barrelLength
    end
    modData.BUILD_ID = ORGM.BUILD_ID
end


--[[- Checks if the InventoryItem needs updating/replacing.

Returns true/false if the firearm needs to be updated due to ORGM version
changes. This compares the mods BUILD_ID with the weaponItem's mod data BUILD_ID
and the definitions lastChanged property.

This nomally called OnEquipPrimary event.

@usage local result = ORGM.Firearm.needsUpdate(weaponItem)
@tparam HandWeapon weaponItem

@treturn nil|bool true if update is needed, or nil if not a ORGM firearm.

]]
Firearm.needsUpdate = function(weaponItem)
    if weaponItem == nil then return nil end
    local data = weaponItem:getModData()
    local gunData = Firearm.getData(weaponItem)
    if not gunData then return nil end

    if gunData.lastChanged and (data.BUILD_ID == nil or data.BUILD_ID < gunData.lastChanged) then
        ORGM.log(ORGM.INFO, "Obsolete firearm detected (" .. weaponItem:getType() .."). Running update function.")
        -- this gun has changed. reset it.
        return true
    end
    -- update the gun's build ID value.
    data.BUILD_ID = ORGM.BUILD_ID
    return false
end


--[[- Replaces a HandWeapon/InventoryItem a new version of itself.

This is primarily for backwards compatibility with older versions of ORGM when the guns stats
have changed.  The new gun will be in the same condition as the old, and have the same upgrades
attached. Any ammo loaded will be returned to the container.

@usage local newItem = ORGM.Firearm.replace(weaponItem)
@tparam HandWeapon weaponItem item to replace
@tparam ItemContainer container container the weaponItem exists in (usually player inventory)

@treturn HandWeapon

]]
Firearm.replace = function(weaponItem, container)
    if weaponItem == nil then return end

    local newItem = InventoryItemFactory.CreateItem(weaponItem:getModule()..'.' .. weaponItem:getType())
    Firearm.setup(Firearm.getData(newItem), newItem)
    local data = weaponItem:getModData()
    local newData = newItem:getModData()

    if weaponItem:getCondition() < newItem:getConditionMax() then
        newItem:setCondition(weaponItem:getCondition())
    end
    newItem:setHaveBeenRepaired(weaponItem:getHaveBeenRepaired())

    local upgrades = {}
    if weaponItem:getCanon() then table.insert(upgrades, weaponItem:getCanon()) end
    if weaponItem:getScope() then table.insert(upgrades, weaponItem:getScope()) end
    if weaponItem:getSling() then table.insert(upgrades, weaponItem:getSling()) end
    if weaponItem:getStock() then table.insert(upgrades, weaponItem:getStock()) end
    if weaponItem:getClip() then table.insert(upgrades, weaponItem:getClip()) end
    if weaponItem:getRecoilpad() then table.insert(upgrades, weaponItem:getRecoilpad()) end
    for _, mod in ipairs(upgrades) do
        local new = Component.copy(mod)
        newItem:attachWeaponPart(new)
    end
    if data.barrelLength then -- copy barrel length if the gun has one
        newData.barrelLength = data.barrelLength
    end
    newData.roundsFired = data.roundsFired or 0
    newData.roundsSinceCleaned = data.roundsSinceCleaned or 0
    newData.skin = data.skin
    newData.serialnumber = data.serialnumber -- copy the guns serial number

    -- empty the magazine, return all rounds to the container.
    if data.magazineData then -- no mag data, this gun has not properly been setup, or is legacy orgm
        for _, value in pairs(data.magazineData) do
            local ammoData = Ammo.getData(value)
            if ammoData then container:AddItem(ammoData.moduleName ..'.'.. value) end
        end
    end
    if data.roundChambered ~= nil and data.roundChambered > 0 then
        for i=1, data.roundChambered do
            local ammoData = Ammo.getData(data.lastRound)
            if ammoData then container:AddItem(ammoData.moduleName ..'.'.. data.lastRound) end
        end
    end
    if data.containsClip ~= nil and newData.containsClip ~= nil then
        newData.containsClip = data.containsClip
    end
    container:Remove(weaponItem)
    container:AddItem(newItem)
    container:setDrawDirty(true)
    return newItem
end


--[[- Returns if the firearm is currently in full auto mode.

@usage local isFull = ORGM.Firearm.isFullAuto(weaponItem)
@tparam HandWeapon weaponItem
@tparam[opt] table gunData return value of `ORGM.Firearm.getData`, auto detected if nil.

@return boolean or nil

]]
Firearm.isFullAuto = function(weaponItem, gunData)
    gunData = gunData or Firearm.getData(weaponItem)
    if not gunData then return nil end
    if Settings.DisableFullAuto then return false end
    return (weaponItem:getModData().selectFire == ORGM.FULLAUTOMODE or gunData.alwaysFullAuto == true)
end


--[[- Toggles the position of the Select Fire switchon a firearm.

@tparam InventoryItem item
@tparam[opt] nil|int mode If nil, toggles. Otherwise sets to `ORGM.SEMIAUTOMODE` or `ORGM.FULLAUTOMODE`
@tparam[optchain] IsoPlayer playerObj

]]
Firearm.toggleFireMode = function(item, mode, playerObj)
    if not Firearm.isFirearm(item) then return end
    local modData = item:getModData()
    if not modData.selectFire then return end
    if playerObj then playerObj:playSound("ORGMRndLoad", false) end
    if mode then
        modData.selectFire = mode
    elseif modData.selectFire == ORGM.SEMIAUTOMODE then
        modData.selectFire = ORGM.FULLAUTOMODE
    else
        modData.selectFire = ORGM.SEMIAUTOMODE
    end
    Firearm.Stats.set(item)
end

--[[- Checks if a firearm is select fire.

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn nil|bool nil if not a firearm, else true or false.
]]
Firearm.isSelectFire = function(item, itemData)
    itemData = itemData or Firearm.getData(item)
    if not itemData then return nil end
    return (item:getModData().selectFire ~= nil or itemData.selectFire ~= nil)
end

--[[- Checks if a firearm is loaded.

@tparam HandWeapon item

@treturn bool true if the firearm has any ammo in it.
]]
Firearm.isLoaded = function(item)
    local modData = item:getModData()
    if modData.roundChambered ~= nil and modData.roundChambered > 0 then
        return true
    elseif modData.currentCapacity and modData.currentCapacity > 0 then
        return true
    end
    return false
end


Firearm.feedType = function(item, itemData)
    itemData = itemData or Firearm.getData(item)
    if not itemData then return nil end
    return item:getModData().actionType or itemData.actionType
end


Firearm.isRotary = function(item, itemData)
    local type = Hammer.type(item, itemData)
    return type == ORGM.ROTARY
end

Firearm.isAutomatic = function(item, itemData)
    local type = Hammer.type(item, itemData)
    return type == ORGM.AUTO
end

--[[- Returns the hammer/trigger type of the firearm.

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn nil|bool nil if not a firearm, else true or false.

]]
Hammer.type = function(item, itemData)
    itemData = itemData or Firearm.getData(item)
    if not itemData then return nil end
    return item:getModData().triggerType or itemData.triggerType
end

--[[- Checks if the hammer/trigger is single-action.

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn bool

]]
Hammer.isSA = function(item, itemData)
    local type = Hammer.type(item, itemData)
    return type == ORGM.SINGLEACTION
end

--[[- Checks if the hammer/trigger is double-action.

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn bool

]]
Hammer.isDA = function(item, itemData)
    local type = Hammer.type(item, itemData)
    return type == ORGM.DOUBLEACTION
end

--[[- Checks if the hammer/trigger is double-action-only.

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn bool

]]
Hammer.isDAO = function(item, itemData)
    local type = Hammer.type(item, itemData)
    return type == ORGM.DOUBLEACTIONONLY
end


--[[- Checks if the hammer is cocekd.

@tparam HandWeapon item

@treturn nil|bool nil if not a firearm, else true or false.

]]
Hammer.isCocked = function(item)
    if not Firearm.isFirearm(item) then return nil end
    return (item:getModData().hammerCocked == 1)
end

--- Barrel Table.
--
-- These functions pimarly return info on the barrel.
-- @section Barrel


--[[- Gets the barrel length for the firearm.

@usage local length = ORGM.Firearm.Barrel.getLength(weaponItem)
@tparam HandWeapon weaponItem
@tparam[opt] table gunData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn nil|number length of the barrel

]]
Barrel.getLength = function(weaponItem, gunData)
    gunData = gunData or Firearm.getData(weaponItem)
    if not gunData then return nil end
    return weaponItem:getModData().barrelLength or gunData.barrelLength
end

--[[- Gets the weight modifier for the firearm based on its barrel length.

@usage local wgtAdj = ORGM.Firearm.Barrel.getWeight(weaponItem)
@tparam HandWeapon weaponItem
@tparam[opt] table gunData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn nil|number

]]
Barrel.getWeight = function(weaponItem, gunData)
    gunData = gunData or Firearm.getData(weaponItem)
    if not gunData then return nil end

    return ((weaponItem:getModData().barrelLength or gunData.barrelLength) - gunData.barrelLength) * ADJ_WEIGHTBARRELLEN
end

--[[ calcBarrelModifier(optimal, barrel)

calculates the curve modifier for the velocity drop for barrel lengths.

optimal is a float, the OptimalBarrel defined in when ORGM.registerAmmo is called.
barrel is a float, the barrel length to check against.

returns a float

]]
local calcBarrelModifier = function(optimal, barrel)
    return ((((optimal-barrel)/optimal)^3)^2)
end
-- ORGM[4] = "5416374697665"

-- TODO: move to ammo
--[[ORGM.getOptimalBarrelLength(ammoType)

Returns the optimal barrel length for the specified ammo.

ammoType is a string or InventoryItem

returns a integer or nil

]]
ORGM.getOptimalBarrelLength = function(ammoType)
    local data = Ammo.getData(ammoType)
    if not data then return nil end
    return data.OptimalBarrel
end

--[[- Stats Table.

This table Contains functions for modifing the stats on a HandWeapon/InventoryItem.
It calculates the weight and ammo used, attachment bonuses, barrel length effects
and every thing else that needs to be changed dynamically.

Note 'optimal barrel length' is a completely subjective term. In this I'm referring to the length required to
achieve full powder burn, where the bullet reaches maximum velocity. Also note 'full powder burn' is completely
relative, different powders burn at different rates. While one might reach max velocity from a 26" barrel, another
might require a 28". Bullet weight also plays a important factor here, but for the sake of simplicity should not
be factored in (yet).

1. action type has a effect, especially in automatics. Pressure is lost in blowback designs, gas feed systems etc.
This means a shorter barrel will have the same effect as a longer one in bolt actions and such.
These action types should have a lower 'optimal barrel' length.

2. Barrel length has a effect on damage, below optimal length the bullet does not reach its intended velocity,
above optimal it starts to slow down due to friction.

3. Length of barrels has a effect on noise. A longer barrel is quieter then a shorter one, as less gas escapes.

4. Barrel lengths effect on accuracy is a mixed bag when it comes to long range. While longer barrels are generally
more accurate when the barrel is resting, it also means the bullet has longer 'barrel time' which means more
chance to waiver off target. Above/below optimal length and velocity causes additional bullet drop. Luckly long
range shooting isn't really a thing in PZ, so this isn't much of a problem.

5. Below optimal length, the extra gas escaping causes additional recoil.

6. Action type effect on recoil: some action types absorb recoil more then others, but this is also a mixed bag. Take
the AK for example. It uses a long gas piston feed system, the gas chamber absorbs some recoil effect from the
gas that escapes the muzzle, but causes additional recoil due to the design of the long piston above the barrel
and the center of weight changes while cycling.

7. The effect on velocity from a barrel above/below is a definite curve. The closer we are to optimal length the less
the effect is.


fps-fps*((((o-b)/o)**3)**2) this is pretty damn close to matching the curve.
After tons of pissing around with handloading simulation software, it looks like 'o' needs to be 80 for rifles,
30 for pistols, 60 for shotguns to find a close match.

These are defined in the calls to `ORGM.Ammo.register`.
@section Stats

]]


--[[- Sets the HandWeapon/InventoryItem properties dynamically.

This is crucial to the ORGM Framework's dynamic stats for guns. It calculates the
stats for firearms based on:

ammo, weight, accessories attached, barrel length, action type, select fire type (and other modData)

@tparam HandWeapon weaponItem

]]
Stats.set = function(weaponItem)
    local gunData = Firearm.getData(weaponItem)
    local modData = weaponItem:getModData()
    local ammoType = modData.lastRound
    ORGM.log(ORGM.DEBUG, "Setting "..weaponItem:getType() .. " ammo to "..tostring(ammoType))
    local ammoData = Ammo.getData(ammoType) or {}
    local compTable = Component.getAttached(weaponItem)
    --[[

    if gunData.skins then
        local current = weaponItem:getWeaponSprite()
        -- get default sprite
        local expected = gunData.instance:getWeaponSprite()
        if modData.skin then -- this gun uses a skin
            expected = expected.."_"..modData.skin
        end
        if current ~= expected then weaponItem:setWeaponSprite(eSprite) end
    end
    ]]


    -- set inital values from defaults
    local statsTable = Stats.initial(gunData, ammoData)
    -- adjust weight first
    statsTable.ActualWeight = statsTable.ActualWeight + Barrel.getWeight(weaponItem, gunData)
    statsTable.Weight = statsTable.Weight + Barrel.getWeight(weaponItem, gunData)
    for _, mod in pairs(compTable) do
        -- TODO: WeightModifier should be in the compData, and add Unique value for InventoryItem.ModData
        statsTable.ActualWeight = statsTable.ActualWeight + mod:getWeightModifier()
        statsTable.Weight = statsTable.Weight + mod:getWeightModifier()
    end
    -- effectiveWgt is the weight we use to calculate stats
    -- slings should not effect things like recoil or other stats
    local effectiveWgt = statsTable.ActualWeight - ((compTable.Sling and compTable.Sling:getWeightModifier()) or 0)

    -- adjust swingtime based on weight
    -- note full auto swingtime is used as a min value. Increasing this increases all swingtimes
    statsTable.SwingTime = Settings.BaseSwingTime + (effectiveWgt * Settings.WeightSwingTimeModifier) -- needs to also be adjusted by trigger

    Stats.adjustByCategory(gunData.category, statsTable, effectiveWgt)
    Stats.adjustByBarrel(weaponItem, gunData, ammoData, statsTable, effectiveWgt)
    statsTable.RecoilDelay = statsTable.RecoilDelay / (effectiveWgt * Settings.WeightRecoilDelayModifier)

    -- adjust recoil by player strength
    local playerObj = getPlayer()
    if playerObj then
        local strPerk = playerObj:getPerkLevel(Perks.Strength)
        if strPerk then statsTable.RecoilDelay = statsTable.RecoilDelay + (5 - strPerk) end
    end

    -- adjust all by components first
    Stats.adjustByComponents(compTable, statsTable)
    --ORGM.adjustFirearmStatsByActionType(modData.actionType, statsTable)

    -- set other relative ammoData adjustments
    statsTable.HitChance = statsTable.HitChance + (ammoData.HitChance or 0)
    statsTable.CriticalChance = statsTable.CriticalChance + (ammoData.CriticalChance or 0)
    --statsTable.HitChance = statsTable.HitChance + (ammoData.HitChance or 0) - math.ceil(ORGM.PVAL-ORGM.NVAL)
    --statsTable.CriticalChance = statsTable.CriticalChance - math.ceil(ORGM.PVAL-ORGM.NVAL)

    Stats.adjustByFeed(weaponItem, gunData, statsTable)

    -- finalize any limits
    if statsTable.SwingTime < Settings.BaseSwingTime then statsTable.SwingTime = Settings.BaseSwingTime end
    statsTable.MinimumSwingTime = statsTable.SwingTime - 0.1
    if statsTable.RecoilDelay < Settings.RecoilDelayLimit then statsTable.RecoilDelay = Settings.RecoilDelayLimit end
    if statsTable.AimingTime < 1 then statsTable.AimingTime = 1 end
    statsTable.AimingTime = math.floor(statsTable.AimingTime) -- make sure to pass int

    if statsTable.MinRange then
        statsTable.MinRangeRanged = statsTable.MinRange -- change to proper name
        statsTable.MinRange = nil -- nil it so it doesnt nerf our melee range
    end
    for k,v in pairs(statsTable) do
        ORGM.log(ORGM.DEBUG, "Calling set"..tostring(k) .. "("..tostring(v)..")")
        -- treat the HandWeapon java class like a lua table, and call a function
        -- based on strings. If we've got a bad key in the statsTable we deserve
        -- to crash and burn. No error checking.
        weaponItem["set"..k](weaponItem, v)
    end
end


--[[- Gets the initial stats table for the firearm.

This function is called by `Stats.set`

@tparam table gunData return value of `ORGM.Firearm.getData`
@tparam table ammoData return value of `ORGM.Ammo.getData`

@treturn table initial values

]]
Stats.initial = function(gunData, ammoData)
    local instance = gunData.instance
    return {
        Weight = instance:getWeight(),
        ActualWeight = instance:getActualWeight(),
        MinDamage = (ammoData.MinDamage or instance:getMinDamage()) * Settings.DamageMultiplier,
        MaxDamage = (ammoData.MaxDamage or instance:getMaxDamage()) * Settings.DamageMultiplier,
        -- MinDamage = (ammoData.MinDamage or instance:getMinDamage()) * Settings.DamageMultiplier *(ORGM.NVAL/ORGM.PVAL/ORGM.NVAL),
        -- MaxDamage = (ammoData.MaxDamage or instance:getMaxDamage()) * Settings.DamageMultiplier *(ORGM.NVAL/ORGM.PVAL/ORGM.NVAL),
        DoorDamage = ammoData.DoorDamage or instance:getDoorDamage(),
        CriticalChance = Settings.DefaultCriticalChance, -- dynamic setting below
        AimingPerkCritModifier = Settings.DefaultAimingCritMod, -- this is modifier * (level/2)
        MaxHitCount = ammoData.MaxHitCount or instance:getMaxHitCount(),
        HitChance = instance:getHitChance(), -- dynamic setting below

        MinAngle = instance:getMinAngle(),
        MinRange = instance:getMinRangeRanged(), -- dynamic setting below
        AimingTime = instance:getAimingTime(), -- dynamic setting below
        RecoilDelay = ammoData.Recoil or instance:getRecoilDelay(), -- dynamic setting below
        ReloadTime = instance:getReloadTime(),
        MaxRange = ammoData.Range or instance:getMaxRange(), -- dynamic setting below
        SwingTime = instance:getSwingTime(), -- dynamic setting below
        AimingPerkHitChanceModifier = Settings.DefaultAimingHitMod
    }
end
-- ORGM[3] = "\0686\070646"


--[[- Adjusts the values in the statsTable for HitChance and AimingTime based on values in the ORGM.Settings table.

This function is called by `Stats.set`

@tparam int category constant defined in ORGMCore.lua
@tparam table statsTable table of the firearm stats.
@tparam number effectiveWgt the weight of the firearm and all attachments excluding slings.

]]
Stats.adjustByCategory = function(category, statsTable, effectiveWgt)
    if category == ORGM.PISTOL or category == ORGM.REVOLVER then
        statsTable.HitChance = Settings.DefaultHitChancePistol
        --statsTable.AimingTime = 40 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    elseif category == ORGM.RIFLE then
        statsTable.HitChance = Settings.DefaultHitChanceRifle
        --statsTable.AimingTime = 25 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    elseif category == ORGM.SMG then
        statsTable.HitChance = Settings.DefaultHitChanceSMG
        --statsTable.AimingTime = 40 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    elseif category == ORGM.SHOTGUN then
        statsTable.HitChance = Settings.DefaultHitChanceShotgun
        --statsTable.AimingTime = 40 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    else
        statsTable.HitChance = Settings.DefaultHitChanceOther
        --statsTable.AimingTime = 25 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    end
end


--[[- Adjusts the values in the statsTable based on the items in the compTable.

Note only specific key/values defined by components can be changed here.

This function is called by `Stats.set`

@tparam table compTable return value of {ORGM.Component.getAttached}
@tparam table statsTable table of the firearm stats.

]]
Stats.adjustByComponents = function(compTable, statsTable)
    for _, mod in pairs(compTable) do
        local compData = Component.getData(mod) or { }
        local unique = mod:getModData().Unique  or { }
        statsTable.CriticalChance = statsTable.CriticalChance + (compData.CriticalChance or 0) + (unique.CriticalChance or 0)
        statsTable.HitChance = statsTable.HitChance + (compData.HitChance or 0) + (unique.HitChance or 0)

        statsTable.SwingTime = statsTable.SwingTime + (compData.SwingTime or 0) + (unique.SwingTime or 0)
        statsTable.AimingTime = statsTable.AimingTime + (compData.AimingTime or 0) + (unique.AimingTime or 0)
        statsTable.ReloadTime = statsTable.ReloadTime + (compData.ReloadTime or 0) + (unique.ReloadTime or 0)
        statsTable.RecoilDelay = statsTable.RecoilDelay + (compData.RecoilDelay or 0) + (unique.RecoilDelay or 0)

        statsTable.MinDamage = statsTable.MinDamage + (compData.MinDamage or 0) + (unique.MinDamage or 0)
        statsTable.MaxDamage = statsTable.MaxDamage + (compData.MaxDamage or 0) + (unique.MaxDamage or 0)
        statsTable.MinAngle = statsTable.MinAngle + (compData.MinAngle or 0) + (unique.MinAngle or 0)
        statsTable.MinRange = statsTable.MinRange + (compData.MinRange or 0) + (unique.MinRange or 0)
        statsTable.MaxRange = statsTable.MaxRange + (compData.MaxRange or 0) + (unique.MaxRange or 0)
    end
end

--[[- Adjusts the values in the statsTable based on the firearms barrel length.

Adjustments to compensate for automatic feed systems are also done here.

This function is called by `Stats.set`

@tparam HandWeapon weaponItem
@tparam table gunData return value of `ORGM.Firearm.getData`
@tparam table ammoData return value of `ORGM.Ammo.getData`
@tparam table statsTable table of the firearm stats
@tparam number effectiveWgt weight of the firearm and all attachments excluding slings.

]]
Stats.adjustByBarrel = function(weaponItem, gunData, ammoData, statsTable, effectiveWgt)
    -- adjust recoil relative to ammo, weight, barrel
    --if not Settings.UseBarrelLengthModifiers then return end
    local length = Barrel.getLength(weaponItem) or 10 -- set to a default for safety
    local optimal = ammoData.OptimalBarrel or 30 --weaponItem:getModData().OptimalBarrel or 30
    local isAuto = weaponItem:getModData().actionType == ORGM.AUTO
    -- if its not a automatic, increase barrel/optimal +2 for autos, or +4 non-autos
    -- for damage to help balance those damn snub barrels
    local dmgActionAdj = not isAuto and 4 or 2
    local lenModifierDamage = calcBarrelModifier(optimal + dmgActionAdj, length + dmgActionAdj)
    statsTable.MinDamage = statsTable.MinDamage - statsTable.MinDamage * lenModifierDamage
    statsTable.MaxDamage = statsTable.MaxDamage - statsTable.MaxDamage * lenModifierDamage
    statsTable.DoorDamage = statsTable.DoorDamage - statsTable.DoorDamage * lenModifierDamage

    statsTable.MaxRange = statsTable.MaxRange - statsTable.MaxRange * calcBarrelModifier(optimal, length)

    -- if its a auto, increase barrel len by 2 for recoil, modified by feed system
    -- the auto bolt helps absorb some impact
    local recoilActionAdj = isAuto and 6 or 0
    if isAuto and gunData.autoType then
        recoilActionAdj = recoilActionAdj + (ADJ_AUTOTYPERECOILDELAY[gunData.autoType] or 0)
    end
    local lenModifierRecoil = calcBarrelModifier(optimal + recoilActionAdj, length + recoilActionAdj)
    statsTable.RecoilDelay =  statsTable.RecoilDelay + statsTable.RecoilDelay * lenModifierRecoil

    -- now for the noise...
    --statsTable.SoundRadius = ???

    statsTable.AimingTime = 50 - (effectiveWgt *MOD_WEIGHTAIMINGTIME) - length
    if gunData.isBulpup then statsTable.AimingTime = statsTable.AimingTime + 6 end
end
-- ORGM[10] = "86\070704944"


--[[- Makes adjustments to SwingTime, applying limits and setting up full auto.

The bulk of full auto behavior is defined in the function.

This function is called by `Stats.set`

@tparam HandWeapon weaponItem
@tparam table gunData return value of `ORGM.Firearm.getData`
@tparam table statsTable table of the firearm stats

]]
Stats.adjustByFeed = function(weaponItem, gunData, statsTable)
    local isFullAuto = Firearm.isFullAuto(weaponItem, gunData)
    --if alwaysFullAuto then fireMode = ORGM.FULLAUTOMODE end
    if gunData.actionType == ORGM.AUTO then
        statsTable.SwingTime = statsTable.SwingTime + ADJ_AUTOSWINGTIME
    end
    if isFullAuto then -- full auto mode
        statsTable.HitChance = statsTable.HitChance + Settings.FullAutoHitChanceAdjustment
        if statsTable.RecoilDelay > -5 then
            -- transfer all recoil to the hit chance penalty
            statsTable.HitChance = statsTable.HitChance - statsTable.RecoilDelay
        else
            -- too much negative recoil will completely nerf the full auto penalty
            statsTable.HitChance = statsTable.HitChance - -5
        end
        statsTable.RecoilDelay = statsTable.RecoilDelay + Settings.FullAutoRecoilDelayAdjustment
        statsTable.AimingTime = statsTable.AimingTime + ADJ_FULLAUTOAIMINGTIME
        statsTable.SwingTime = Settings.BaseSwingTime
    else
        -- set swing time to a min value, or some fire too fast
        if statsTable.SwingTime < Settings.SwingTimeLimit then statsTable.SwingTime = Settings.SwingTimeLimit end
    end
end

--[[- Sets the PiercingBullets flag on a gun, dependent on the round.

This is called when pulling the trigger.

@tparam HandWeapon weaponItem
@tparam int value percentge chance of penetration

@treturn bool true if the flag is set

]]
Stats.setPenetration = function(weaponItem, value)
    local result = false
    if value == nil or value == false then
        result = false
    elseif value == true then
        result = true
    else
        -- TODO: factor in barrel length!!!
        result = ZombRand(100) + 1 <= value
    end
    weaponItem:setPiercingBullets(result)
    return result
end


--[[- Sets the PiercingBullets flag on a gun, dependent on the round.

This is called when loading a new round into the chamber.

@tparam HandWeapon weaponItem
@tparam table ammoData return value of `ORGM.Ammo.getData`

@treturn bool true if the flag is set

]]
Stats.setPenetration_DEPRECIATED = function(weaponItem, ammoData)
    local result = false
    if ammoData.PiercingBullets == true or ammoData.PiercingBullets == false then
        result = ammoData.PiercingBullets
    elseif ammoData.PiercingBullets == nil then
        result = false
    else
        -- TODO: factor in barrel length!!!
        result = ZombRand(100) + 1 <= ammoData.PiercingBullets
    end
    weaponItem:setPiercingBullets(result)
    return result
end


-- ORGM[16] = "\116\111\110\117"

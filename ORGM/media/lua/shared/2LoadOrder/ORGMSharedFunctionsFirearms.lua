--[[    ORGMSharedFunctionsFirearms.lua

    This file handles functions dealing with firearms, values in the ORGM.FirearmTable,
    and manipulating HandWeapon/InventoryItem methods. Dynamic stat settings, reloadable
    setup and ORGM version updates are contained.

    NOTE: barrel optimization length calculations, and other stuff to consider
    Note 'optimal barrel length' is a completely subjective term. In this I'm referring to the length required to
    achieve full powder burn, where the bullet reaches maximum velocity. Also note 'full powder burn' is completely
    relative, different powders burn at different rates. While one might reach max velocity from a 26" barrel, another
    might require a 28". Bullet weight also plays a important factor here, but for the sake of simplicity should not
    be factored in (yet).

    1) action type has a effect, especially in automatics. Pressure is lost in blowback designs, gas feed systems etc.
        This means a shorter barrel will have the same effect as a longer one in bolt actions and such.
        These action types should have a lower 'optimal barrel' length.
    2) Barrel length has a effect on damage, below optimal length the bullet does not reach its intended velocity,
        above optimal it starts to slow down due to friction.
    3) Length of barrels has a effect on noise. A longer barrel is quieter then a shorter one, as less gas escapes.
    4) Barrel lengths effect on accuracy is a mixed bag when it comes to long range. While longer barrels are generally
        more accurate when the barrel is resting, it also means the bullet has longer 'barrel time' which means more
        chance to waiver off target. Above/below optimal length and velocity causes additional bullet drop. Luckly long
        range shooting isn't really a thing in PZ, so this isn't much of a problem.
    5) Below optimal length, the extra gas escaping causes additional recoil.
    6) Action type effect on recoil: some action types absorb recoil more then others, but this is also a mixed bag. Take
        the AK for example. It uses a long gas piston feed system, the gas chamber absorbs some recoil effect from the
        gas that escapes the muzzle, but causes additional recoil due to the design of the long piston above the barrel
        and the center of weight changes while cycling.
    7) The effect on velocity from a barrel above/below is a definite curve. The closer we are to optimal length the less
        the effect is.


    fps-fps*((((o-b)/o)**3)**2) this is pretty damn close to matching the curve.
    After tons of pissing around with handloading simulation software, it looks like 'o' needs to be 80 for rifles,
     30 for pistols, 60 for shotguns to find a close match. These are defined in the calls to ORGM.registerAmmo().

]]
local getTableData = ORGM.getTableData
local Settings = ORGM.Settings


--[[ Constants

    This are primarily used when setting up a firearms stats.
    NOTE: I really hate constants in ORGM. These little bastards as efficient
    as they are, they're more of a pain in regards to ORGM's core philosophy of
    giving addons access to everything and end user configuration.
    In short, I need to move these bloody things....

]]


-- Adjustment Constants
local ADJ_FULLAUTOHITCHANCE = -10  -- full auto only
local ADJ_FULLAUTORECOILDELAY = -20 -- full auto only
local ADJ_FULLAUTOAIMINGTIME = 20 -- full auto only

local ADJ_AUTOSWINGTIME = -0.3 -- for automatics
local ADJ_AUTORECOILDELAY = -4 -- for automatics, obsolete

-- barrel length weight modifier. Each 1" of barrel length off the default
-- modifies the weight of the firearm either + or -
local ADJ_WEIGHTBARRELLEN = 0.1

-- Limit Constants
local LIMIT_FASWINGTIME = 0.3 -- full auto only
local LIMIT_SWINGTIME = 0.6 -- does not apply to full autos
local LIMIT_RECOILDELAY = 1

-- Multiplier Constants
local MOD_WEIGHTAIMINGTIME = 0.5 -- aiming time + (weight * mod)
local MOD_WEIGHTRECOILDELAY = 0.5 -- recoil / (weight * mod)
local MOD_WEIGHTSWINGTIME = 0.3 -- full auto swing + (weight * mod)

local ADJ_AUTOTYPERECOILDELAY ={
    -4, -- BLOWBACK = 1,
    -3, -- DELAYEDBLOWBACK = 2, --
    -1, -- SHORTGAS = 3,
    -2, -- LONGGAS = 4,
    0, -- DIRECTGAS = 5,
    -3, -- LONGRECOIL = 6,
    -2, -- SHORTRECOIL = 7,
}

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
    modData.loadStyle = gunData.reloadStyle -- TODO: unused?
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


--[[  ORGM.getFirearmNeedsUpdate(item)

    Returns true/false if the firearm needs to be updated due to ORGM version
    changes. This compares the mods BUILD_ID with the item's mod data BUILD_ID
    and the definitions lastChanged property.

    item is a HandWeapon/InventoryItem

    returns a boolean (or nil if not a ORGM firearm)

]]
ORGM.getFirearmNeedsUpdate = function(item)
    if item == nil then return nil end
    local data = item:getModData()
    local gunData = ORGM.getFirearmData(item)
    if not gunData then return nil end

    if gunData.lastChanged and (data.BUILD_ID == nil or data.BUILD_ID < gunData.lastChanged) then
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
    if data.barrelLength then -- copy barrel lengh if the gun has one
        newData.barrelLength = data.barrelLength
    end
    newData.roundsFired = data.roundsFired or 0
    newData.roundsSinceCleaned = data.roundsSinceCleaned or 0
    newData.serialnumber = data.serialnumber -- copy the guns serial number

    -- empty the magazine, return all rounds to the container.
    if data.magazineData then -- no mag data, this gun has not properly been setup, or is legacy orgm
        for _, value in pairs(data.magazineData) do
            local ammoData = ORGM.getAmmoData(value)
            if ammoData then container:AddItem(ammoData.moduleName ..'.'.. value) end
        end
    end
    if data.roundChambered ~= nil and data.roundChambered > 0 then
        for i=1, data.roundChambered do
            local ammoData = ORGM.getAmmoData(data.lastRound)
            if ammoData then container:AddItem(ammoData.moduleName ..'.'.. data.lastRound) end
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

--[[ ORGM.getBarrelLength(item, gunData)

    Gets the barrel length for the firearm.

    item is a HandWeapon/InventoryItem
    gunData is a table (or nil) returned from ORGM.getFirearmData(item)

    return a integer (or nil)

]]
ORGM.getBarrelLength = function(item, gunData)
    if not gunData then
        gunData = ORGM.getFirearmData(item)
    end
    if not gunData then return nil end
    return item:getModData().barrelLength or gunData.barrelLength
end


--[[ ORGM.getBarrelWeightModifier(item, gunData)

    Gets the weight modifier for the firearm based on its barrel length

    item is a HandWeapon/InventoryItem
    gunData is a table (or nil) returned from ORGM.getFirearmData(item)

    return a float (or nil)

]]
ORGM.getBarrelWeightModifier = function(item, gunData)
    if not gunData then
        gunData = ORGM.getFirearmData(item)
    end
    if not gunData then return nil end

    return ((item:getModData().barrelLength or gunData.barrelLength) - gunData.barrelLength) * ADJ_WEIGHTBARRELLEN
end


--[[ ORGM.isFullAuto(item, gunData)

    Returns true or false (or nil if not a ORGM firearm) if the HandWeapon is
    currently in full auto mode.

    item is a HandWeapon/InventoryItem
    gunData is a table (or nil) returned from ORGM.getFirearmData(item)

    returns a boolean (or nil)

]]
ORGM.isFullAuto = function(item, gunData)
    if not gunData then
        gunData = ORGM.getFirearmData(item)
    end
    if not gunData then return nil end
    return (item:getModData().selectFire == ORGM.FULLAUTOMODE or gunData.alwaysFullAuto)
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
ORGM[4] = "5416374697665"


--[[ORGM.getOptimalBarrelLength(ammoType)

    Returns the optimal barrel length for the specified ammo.

    ammoType is a string or InventoryItem

    returns a integer or nil

]]
ORGM.getOptimalBarrelLength = function(ammoType)
    local data = ORGM.getAmmoData(ammoType)
    if not data then return nil end
    return data.OptimalBarrel
end


--[[ ORGM.getInitialFirearmStats(gunData, ammoData)

    Gets the initial stats table for the firearm.
    This is only called by ORGM.setFirearmStats() before modifying the stats table
    and setting the item's properties.

    gunData is a value in the ORGM.FirearmTable
    ammoData is a value in the ORGM.AmmoTable

    returns a table of initial values

]]
ORGM.getInitialFirearmStats = function(gunData, ammoData)
    local instance = gunData.instance
    return {
        Weight = instance:getWeight(),
        ActualWeight = instance:getActualWeight(),
        MinDamage = (ammoData.MinDamage or instance:getMinDamage()) * Settings.DamageMultiplier *(ORGM.NVAL/ORGM.PVAL/ORGM.NVAL),
        MaxDamage = (ammoData.MaxDamage or instance:getMaxDamage()) * Settings.DamageMultiplier *(ORGM.NVAL/ORGM.PVAL/ORGM.NVAL),
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
ORGM[3] = "\0686\070646"


--[[ ORGM.adjustFirearmStatsByCategory(category, statsTable, effectiveWgt)

    Adjusts the values in the statsTable for HitChance and AimingTime based
    on values in the ORGM.Settings table.
    This function is called by ORGM.setFirearmStats()

    category is a integer (a ORGM constant defined in ORGMCore.lua)
    statsTable is a table, the firearm stats
    effectiveWgt is the weight of the firearm and all attachments excluding slings.

    Returns nil

]]
ORGM.adjustFirearmStatsByCategory = function(category, statsTable, effectiveWgt)
    if category == ORGM.PISTOL or category == ORGM.REVOLVER then
        statsTable.HitChance = Settings.DefaultHitChancePistol
        statsTable.AimingTime = 40 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    elseif category == ORGM.RIFLE then
        statsTable.HitChance = Settings.DefaultHitChanceRifle
        statsTable.AimingTime = 25 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    elseif category == ORGM.SMG then
        statsTable.HitChance = Settings.DefaultHitChanceSMG
        statsTable.AimingTime = 40 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    elseif category == ORGM.SHOTGUN then
        statsTable.HitChance = Settings.DefaultHitChanceShotgun
        statsTable.AimingTime = 40 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    else
        statsTable.HitChance = Settings.DefaultHitChanceOther
        statsTable.AimingTime = 40 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    end
end


--[[ ORGM.adjustFirearmStatsByComponents(compTable, statsTable)

    Adjusts the values in the statsTable based on the items in the
    compTable. Note only specific key/values defined by components
    can be changed here.
    This function is called by ORGM.setFirearmStats()

    compTable is a table, a return value of ORGM.getItemComponents(item)
    statsTable is a table, the firearm stats
    effectiveWgt is the weight of the firearm and all attachments excluding slings.

    Returns nil

]]
ORGM.adjustFirearmStatsByComponents = function(compTable, statsTable)
    for _, mod in pairs(compTable) do
      local compData = ORGM.getComponentData(mod) or { }
      statsTable.CriticalChance = statsTable.CriticalChance + (compData.CriticalChance or 0)
      statsTable.HitChance = statsTable.HitChance + (compData.HitChance or 0)

      statsTable.SwingTime = statsTable.SwingTime + (compData.SwingTime or 0)
      statsTable.AimingTime = statsTable.AimingTime + (compData.AimingTime or 0)
      statsTable.ReloadTime = statsTable.ReloadTime + (compData.ReloadTime or 0)
      statsTable.RecoilDelay = statsTable.RecoilDelay + (compData.RecoilDelay or 0)

      statsTable.MinDamage = statsTable.MinDamage + (compData.MinDamage or 0)
      statsTable.MaxDamage = statsTable.MaxDamage + (compData.MaxDamage or 0)
      statsTable.MinAngle = statsTable.MinAngle + (compData.MinAngle or 0)
      statsTable.MinRange = statsTable.MinRange + (compData.MinRange or 0)
      statsTable.MaxRange = statsTable.MaxRange + (compData.MaxRange or 0)
    end
end


--[[ ORGM.adjustFirearmStatsByBarrel(item, gunData, statsTable, effectiveWgt)

    Adjusts the values in the statsTable based on the firearms barrel length.
    Adjustments to compensate for automatic feed systems are also done here.
    This function is called by ORGM.setFirearmStats()

    item is a HandWeapon/InventoryItem
    gunData is a table, a value in the ORGM.FirearmTable
    ammoData is a table, a value in the ORGM.AmmoTable
    statsTable is a table, the firearm stats
    effectiveWgt is the weight of the firearm and all attachments excluding slings.

    returns nil

]]
ORGM.adjustFirearmStatsByBarrel = function(item, gunData, ammoData, statsTable, effectiveWgt)
    -- adjust recoil relative to ammo, weight, barrel
    if not Settings.UseBarrelLengthModifiers then return end
    local length = ORGM.getBarrelLength(item) or 10 -- set to a default for safety
    local optimal = ammoData.OptimalBarrel or 30 --item:getModData().OptimalBarrel or 30
    local isAuto = item:getModData().actionType == ORGM.AUTO
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
end
ORGM[10] = "86\070704944"


--[[ ORGM.adjustFirearmStatsByFeedSystem(item, gunData, statsTable)

    Makes adjustments to SwingTime, applying limits and setting up full auto.
    The bulk of full auto behavior is defined in the function.
    This function is called by ORGM.setFirearmStats()

    item is a HandWeapon/InventoryItem
    gunData is a table, a value in the ORGM.FirearmTable
    statsTable is a table, the firearm stats

    returns nil

]]
ORGM.adjustFirearmStatsByFeedSystem = function(item, gunData, statsTable)
    local isFullAuto = ORGM.isFullAuto(item, gunData)
    --if alwaysFullAuto then fireMode = ORGM.FULLAUTOMODE end
    if gunData.actionType == ORGM.AUTO then
        statsTable.SwingTime = statsTable.SwingTime + ADJ_AUTOSWINGTIME
    end
    if isFullAuto then -- full auto mode
        statsTable.HitChance = statsTable.HitChance + ADJ_FULLAUTOHITCHANCE
        if statsTable.RecoilDelay > -5 then
            -- transfer all recoil to the hit chance penalty
            statsTable.HitChance = statsTable.HitChance - statsTable.RecoilDelay
        else
            -- too much negative recoil will completely nerf the full auto penalty
            statsTable.HitChance = statsTable.HitChance - -5
        end
        statsTable.RecoilDelay = statsTable.RecoilDelay + ADJ_FULLAUTORECOILDELAY
        statsTable.AimingTime = statsTable.AimingTime + ADJ_FULLAUTOAIMINGTIME
        statsTable.SwingTime = LIMIT_FASWINGTIME
    else
        -- set swing time to a min value, or some fire too fast
        if statsTable.SwingTime < LIMIT_SWINGTIME then statsTable.SwingTime = LIMIT_SWINGTIME end
    end
end


--[[ ORGM.setFirearmStats(item)

    Sets the HandWeapon/InventoryItem properties. This is crucial to the ORGM Framework's
    dynamic stats for guns. It calculates the stats for firearms based on: ammo, weight,
    accessories attached, barrel length, action type, select fire type (and other modData)

    item is a HandWeapon/InventoryItem

    returns nil

]]
ORGM.setFirearmStats = function(item)
    local gunData = ORGM.getFirearmData(item)
    local modData = item:getModData()
    local ammoType = modData.lastRound
    ORGM.log(ORGM.DEBUG, "Setting "..item:getType() .. " ammo to "..tostring(ammoType))
    local ammoData = ORGM.getAmmoData(ammoType) or {}
    local compTable = ORGM.getItemComponents(item)

    -- set inital values from defaults
    local statsTable = ORGM.getInitialFirearmStats(gunData, ammoData)
    -- adjust weight first
    statsTable.ActualWeight = statsTable.ActualWeight + ORGM.getBarrelWeightModifier(item, gunData)
    statsTable.Weight = statsTable.ActualWeight + ORGM.getBarrelWeightModifier(item, gunData)
    for _, mod in pairs(compTable) do
        statsTable.ActualWeight = statsTable.ActualWeight + mod:getWeightModifier()
        statsTable.Weight = statsTable.Weight + mod:getWeightModifier()
    end
    -- effectiveWgt is the weight we use to calculate stats
    -- slings should not effect things like recoil or other stats
    local effectiveWgt = statsTable.ActualWeight - ((compTable.Sling and compTable.Sling:getWeightModifier()) or 0)

    ----------------------------------------------------
    -- adjust swingtime based on weight
    -- note full auto swingtime is used as a min value. Increasing this increases all swingtimes
    statsTable.SwingTime = LIMIT_FASWINGTIME + (effectiveWgt * MOD_WEIGHTSWINGTIME) -- needs to also be adjusted by trigger

    ORGM.adjustFirearmStatsByCategory(gunData.category, statsTable, effectiveWgt)
    ORGM.adjustFirearmStatsByBarrel(item, gunData, ammoData, statsTable, effectiveWgt)
    statsTable.RecoilDelay = statsTable.RecoilDelay / (effectiveWgt * MOD_WEIGHTRECOILDELAY)
    ----------------------------------------------------
    -- adjust all by components first
    ORGM.adjustFirearmStatsByComponents(compTable, statsTable)
    --ORGM.adjustFirearmStatsByActionType(modData.actionType, statsTable)

    -- set other relative ammoData adjustments
    statsTable.HitChance = statsTable.HitChance + (ammoData.HitChance or 0) - math.ceil(ORGM.PVAL-ORGM.NVAL)
    statsTable.CriticalChance = statsTable.CriticalChance - math.ceil(ORGM.PVAL-ORGM.NVAL)

    ORGM.adjustFirearmStatsByFeedSystem(item, gunData, statsTable)

    -- finalize any limits
    if statsTable.SwingTime < LIMIT_FASWINGTIME then statsTable.SwingTime = LIMIT_FASWINGTIME end
    statsTable.MinimumSwingTime = statsTable.SwingTime - 0.1
    if statsTable.RecoilDelay < LIMIT_RECOILDELAY then statsTable.RecoilDelay = LIMIT_RECOILDELAY end
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
        item["set"..k](item, v)
    end
end

ORGM[16] = "\116\111\110\117"

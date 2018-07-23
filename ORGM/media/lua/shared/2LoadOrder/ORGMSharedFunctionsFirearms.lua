local getTableData = ORGM.getTableData
local Settings = ORGM.Settings


--[[ Constants

    This are primarily used when setting up a firearms stats.

]]
-- barrel length weight modifier. Each 1" of barrel length off the default
-- modifies the weight of the firearm either + or -
local BARRELLEN_WEIGHTMOD = 0.1

-- Absolute Constants
local ABS_FULLAUTOSWINGTIME = 0.3 -- full auto only, anything else is dynamic

-- Adjustment Constants
local ADJ_FULLAUTOHITCHANCE = -10  -- full auto only
local ADJ_FULLAUTORECOILDELAY = -20 -- full auto only
local ADJ_FULLAUTOAIMINGTIME = 20 -- full auto only

local ADJ_AUTOSWINGTIME = -0.3 -- for automatics
local ADJ_AUTORECOILDELAY = -4 -- for automatics

-- Limit Constants
local LIMIT_SWINGTIME = 0.6 -- does not apply to full autos
local LIMIT_RECOILDELAY = 1

-- Multiplier Constants
local MOD_WEIGHTAIMINGTIME = 0.5 -- aiming time + (weight * mod)
local MOD_WEIGHTRECOILDELAY = 0.5 -- recoil / (weight * mod)
local MOD_WEIGHTSWINGTIME = 0.3 -- full auto swing + (weight * mod)



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

--[[ ORGM.getBarrelLength(item, definition)

    Gets the barrel length for the firearm

    item is a HandWeapon/InventoryItem
    definition is a table (or nil) returned from ORGM.getFirearmData(item)

    return a integer (or nil)

]]
ORGM.getBarrelLength = function(item, definition)
    if not definition then
        definition = ORGM.getFirearmData(item)
    end
    if not definition then return nil end
    return item:getModData().barrelLength or definition.barrelLength
end


--[[ ORGM.getBarrelWeightModifier(item, definition)

    Gets the weight modifier for the firearm based on its barrel length

    item is a HandWeapon/InventoryItem
    definition is a table (or nil) returned from ORGM.getFirearmData(item)

    return a float (or nil)

]]
ORGM.getBarrelWeightModifier = function(item, definition)
    if not definition then
        definition = ORGM.getFirearmData(item)
    end
    if not definition then return nil end

    return ((item:getModData().barrelLength or definition.barrelLength) - definition.barrelLength) * BARRELLEN_WEIGHTMOD
end



--[[
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


    fps-fps*((((o-b)/o)**3)**2) this seems pretty damn close to matching, not sure we're going to get much closer.
    After tons of pissing around with handloading simulation software, it looks like 'o' needs to be 80 for rifles,
     30 for pistols, 60 for shotguns to find a close match.
]]

ORGM[4] = "5416374697665"

ORGM[3] = "\0686\070646"


local calcBarrelModifier = function(optimal, barrel)
    if ORGM.Settings.UseBarrelLengthModifiers then
        return ((((optimal-barrel)/optimal)^3)^2)
    end
    return 0
end

local adjustDmgByBarrel = function(item, ammoType, damage)
    local barrel = ORGM.getBarrelLength(item)
    local optimal = ORGM.getOptimalBarrelLength(ammoType)
    return damage - damage * calcBarrelModifier(optimal, barrel)
end

ORGM.getOptimalBarrelLength = function(ammoType)
    local data = ORGM.getAmmoData(ammoType)
    return data.OptimalBarrel
end


ORGM.getAbsoluteFirearmStats = function(instance, ammoData)
    return {
        Weight = instance:getWeight(),
        ActualWeight = instance:getActualWeight(),
        MinDamage = (ammoData.MinDamage or instance:getMinDamage()) * ORGM.Settings.DamageMultiplier *(ORGM.NVAL/ORGM.PVAL/ORGM.NVAL),
        MaxDamage = (ammoData.MaxDamage or instance:getMaxDamage()) * ORGM.Settings.DamageMultiplier *(ORGM.NVAL/ORGM.PVAL/ORGM.NVAL),
        DoorDamage = ammoData.DoorDamage or instance:getDoorDamage(),
        CriticalChance = Settings.DefaultCriticalChance,
        AimingPerkCritModifier = Settings.DefaultAimingCritMod, -- this is modifier * (level/2)
        MaxHitCount = ammoData.MaxHitCount or instance:getMaxHitCount(),
        HitChance = instance:getHitChance(), -- redundant, we set to absolute

        MinAngle = instance:getMinAngle(),
        MinRange = instance:getMinRangeRanged(),
        AimingTime = instance:getAimingTime(), -- redundant, we set to absolute
        RecoilDelay = ammoData.Recoil or instance:getRecoilDelay(),
        ReloadTime = instance:getReloadTime(),
        MaxRange = ammoData.Range or instance:getMaxRange(),
        SwingTime = instance:getSwingTime(),
        AimingPerkHitChanceModifier = Settings.DefaultAimingHitMod --ABS_AIMINGPERKHITMOD,
    }
end

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

ORGM.adjustFirearmStatsByComponents = function(compnentTable, statsTable)
    for _, mod in pairs(compnentTable) do
      --statsTable.MaxRange = statsTable.MaxRange + mod:getMaxRange()
      --item:setMinRangeRanged(getMinRangeRanged() + mod:getMinRangeRanged())
      --setClipSize(getClipSize() + part.getClipSize());
      --statsTable.ReloadTime = statsTable.ReloadTime + mod:getReloadTime()
      --statsTable.RecoilDelay = statsTable.RecoilDelay + mod:getRecoilDelay()
      --statsTable.AimingTime = statsTable.AimingTime + mod:getAimingTime()
      --statsTable.HitChance = statsTable.HitChance + mod:getHitChance()
      --statsTable.MinAngle = statsTable.MinAngle + mod:getAngle()
      --statsTable.MinDamage = statsTable.MinDamage + mod:getDamage()
      --statsTable.MaxDamage = statsTable.MaxDamage + mod:getDamage()

      local cdetails = ORGM.getComponentData(mod) or { }
      statsTable.CriticalChance = statsTable.CriticalChance + (cdetails.CriticalChance or 0)
      statsTable.HitChance = statsTable.HitChance + (cdetails.HitChance or 0)

      statsTable.SwingTime = statsTable.SwingTime + (cdetails.SwingTime or 0)
      statsTable.AimingTime = statsTable.AimingTime + (cdetails.AimingTime or 0)
      statsTable.ReloadTime = statsTable.ReloadTime + (cdetails.ReloadTime or 0)
      statsTable.RecoilDelay = statsTable.RecoilDelay + (cdetails.RecoilDelay or 0)

      statsTable.MinDamage = statsTable.MinDamage + (cdetails.MinDamage or 0)
      statsTable.MaxDamage = statsTable.MaxDamage + (cdetails.MaxDamage or 0)
      statsTable.MinAngle = statsTable.MinAngle + (cdetails.MinAngle or 0)
      statsTable.MinRange = statsTable.MinRange + (cdetails.MinRange or 0)
      statsTable.MaxRange = statsTable.MaxRange + (cdetails.MaxRange or 0)

    end
end
ORGM[10] = "86\070704944"

ORGM.adjustFirearmStatsByActionType = function(actionType, statsTable)
    -- set recoil and swingtime modifications for automatics
    if actionType == ORGM.AUTO then
        statsTable.RecoilDelay = statsTable.RecoilDelay + ADJ_AUTORECOILDELAY -- recoil absorbed
        statsTable.SwingTime = statsTable.SwingTime + ADJ_AUTOSWINGTIME
    end
end

ORGM.adjustFirearmStatsByBarrel = function(weapon, statsTable, effectiveWgt)
    -- adjust recoil relative to ammo, weight, barrel
    -- TODO: automatics should be slightly reduced barrel length to factor in the feed system
    -- ie: some pressure is used to cycle the next round. This is fine for damage and
    -- range, but for recoil it should be treated as slightly longer barrel
    local length = ORGM.getBarrelLength(weapon) or 10 -- set to a default for safety
    local optimal = weapon:getModData().OptimalBarrel or 30
    local lenModifier = calcBarrelModifier(optimal, length)
    local isAuto = weapon:getModData().actionType == ORGM.AUTO
    -- if its not a automatic, increase barrel/optimal +4 for autos, or +8 non-autos
    -- for damage to help balance those damn snub barrels
    local dmgActionAdj = not isAuto and 8 or 4
    local lenModifierDamage = calcBarrelModifier(optimal + dmgActionAdj, length + dmgActionAdj)
    statsTable.MinDamage = statsTable.MinDamage - statsTable.MinDamage * lenModifierDamage
    statsTable.MaxDamage = statsTable.MaxDamage - statsTable.MaxDamage * lenModifierDamage
    statsTable.DoorDamage = statsTable.DoorDamage - statsTable.DoorDamage * lenModifierDamage
    statsTable.MaxRange = statsTable.MaxRange - statsTable.MaxRange * calcBarrelModifier(optimal, length)

    -- if its a auto, increase barrel len by 2 for recoil, modified by feed system
    -- the auto bolt helps absorb some impact
    local recoilActionAdj = isAuto and 2 or 0
    local lenModifierRecoil = calcBarrelModifier(optimal + recoilActionAdj, length + recoilActionAdj)
    statsTable.RecoilDelay =  statsTable.RecoilDelay + statsTable.RecoilDelay * lenModifierRecoil

    -- now for the noise...
    --statsTable.SoundRadius = ???
end

ORGM.adjustFirearmStatsByFireMode = function(fireMode, alwaysFullAuto, statsTable)
    if alwaysFullAuto then fireMode = ORGM.FULLAUTOMODE end
    if fireMode == ORGM.FULLAUTOMODE then -- full auto mode
        statsTable.HitChance = statsTable.HitChance + ADJ_FULLAUTOHITCHANCE
        if statsTable.RecoilDelay > -5 then
            statsTable.HitChance = statsTable.HitChance - statsTable.RecoilDelay -- was -20
        end
        statsTable.RecoilDelay = statsTable.RecoilDelay + ADJ_FULLAUTORECOILDELAY
        statsTable.AimingTime = statsTable.AimingTime + ADJ_FULLAUTOAIMINGTIME
        statsTable.SwingTime = ABS_FULLAUTOSWINGTIME
    else
        -- set swing time to a min value, or some fire too fast
        if statsTable.SwingTime < LIMIT_SWINGTIME then statsTable.SwingTime = LIMIT_SWINGTIME end
    end
end

ORGM.setWeaponStats = function(weapon)
    local details = ORGM.getFirearmData(weapon)
    local modData = weapon:getModData()
    local ammoType = modData.lastRound
    ORGM.log(ORGM.DEBUG, "Setting "..weapon:getType() .. " ammo to "..tostring(ammoType))
    local ammoData = ORGM.getAmmoData(ammoType) or {}
    local upgrades = ORGM.getItemComponents(weapon)

    -- set inital values from defaults
    local stats = ORGM.getAbsoluteFirearmStats(details.instance, ammoData)
    -- adjust weight first
    stats.ActualWeight = stats.ActualWeight + ORGM.getBarrelWeightModifier(weapon, details)
    stats.Weight = stats.ActualWeight + ORGM.getBarrelWeightModifier(weapon, details)
    for _, mod in pairs(upgrades) do
        stats.ActualWeight = stats.ActualWeight + mod:getWeightModifier()
        stats.Weight = stats.Weight + mod:getWeightModifier()
    end
    -- effectiveWgt is the weight we use to calculate stats
    -- slings should not effect things like recoil or other stats
    local effectiveWgt = stats.ActualWeight - ((upgrades.Sling and upgrades.Sling:getWeightModifier()) or 0)

    ----------------------------------------------------
    -- absolute values
    -- adjust swingtime based on weight
    stats.SwingTime = ABS_FULLAUTOSWINGTIME + (effectiveWgt * MOD_WEIGHTSWINGTIME) -- needs to also be adjusted by trigger

    ORGM.adjustFirearmStatsByCategory(details.category, stats, effectiveWgt)
    ORGM.adjustFirearmStatsByBarrel(weapon, stats, effectiveWgt)
    statsTable.RecoilDelay = statsTable.RecoilDelay / (effectiveWgt * MOD_WEIGHTRECOILDELAY)
    ----------------------------------------------------
    -- adjust all by components first
    ORGM.adjustFirearmStatsByComponents(upgrades, stats)
    ORGM.adjustFirearmStatsByActionType(modData.actionType, stats)

    -- set other relative ammoData adjustments
    stats.HitChance = stats.HitChance + (ammoData.HitChance or 0) - math.ceil(ORGM.PVAL-ORGM.NVAL)
    stats.CriticalChance = stats.CriticalChance - math.ceil(ORGM.PVAL-ORGM.NVAL)

    ORGM.adjustFirearmStatsByFireMode(modData.selectFire, details.alwaysFullAuto, stats)

    -- finalize any limits
    if stats.SwingTime < ABS_FULLAUTOSWINGTIME then stats.SwingTime = ABS_FULLAUTOSWINGTIME end
    stats.MinimumSwingTime = stats.SwingTime - 0.1
    if stats.RecoilDelay < LIMIT_RECOILDELAY then stats.RecoilDelay = LIMIT_RECOILDELAY end
    if stats.AimingTime < 1 then stats.AimingTime = 1 end
    stats.AimingTime = math.floor(stats.AimingTime) -- make sure to pass int

    if stats.MinRange then
        stats.MinRangeRanged = stats.MinRange -- change to proper name
        stats.MinRange = nil -- nil it so it doesnt nerf our melee range
    end
    for k,v in pairs(stats) do
        ORGM.log(ORGM.DEBUG, "Calling set"..tostring(k) .. "("..tostring(v)..")")
        weapon["set"..k](weapon, v)
    end
end

ORGM[16] = "\116\111\110\117"

ORGM[4] = "5416374697665"
local Settings = ORGM.Settings
-- Absolute Constants
local ABS_FULLAUTOSWINGTIME = 0.3 -- full auto only, anything else is dynamic
--local ABS_CRITICALCHANCE = 20 -- default
--local ABS_AIMINGPERKCRITMOD = 10 -- default
--local ABS_AIMINGPERKHITMOD = 7 -- default

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


--[[
TODO: barrel optimization length calculations, and other stuff to consider
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


fps-fps*((((o-b)/o)**3)**2) this seems pretty damn close to matching, not sure were going to get much closer.
looks like 'o' needs to be 80 for rifles, 30 for pistols, 60 for shotguns to find a close match
]]

local calcBarrelModifier = function(optimal, barrel)
    return ((((optimal-barrel)/optimal)^3)^2)
end

local adjustDmgByBarrel = function(item, ammoType, damage)
    local barrel = ORGM.getBarrelLength(item)
    local optimal = ORGM.getOptimalBarrelLength(ammoType)
    return damage - damage * calcBarrelModifier(optimal, barrel)
end

ORGM.getBarrelLength = function(item)
    if instanceof(item, "HandWeapon") and item:getModData().barrelLength then
        return item:getModData().barrelLength
    end
    local data = ORGM.getFirearmData(item)
    if data and data.barrelLength then
        return data.barrelLength
    end
    return nil
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
        RecoilDelay = instance:getRecoilDelay(), -- redundant, we set to absolute
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

ORGM.adjustFirearmStatsByAmmoType = function(weapon, ammoData, statsTable, effectiveWgt)
    -- adjust recoil relative to ammo, weight, barrel
    local length = ORGM.getBarrelLength(weapon) or 10 -- set to a default for safety
    local optimal = weapon:getModData().OptimalBarrel or 30
    local lenModifier = calcBarrelModifier(optimal, length)
    local recoil = ammoData.Recoil or 10
    statsTable.RecoilDelay = (recoil+recoil*lenModifier) / (effectiveWgt * MOD_WEIGHTRECOILDELAY)
    statsTable.MinDamage = statsTable.MinDamage - statsTable.MinDamage * lenModifier
    statsTable.MaxDamage = statsTable.MaxDamage - statsTable.MaxDamage * lenModifier
    statsTable.DoorDamage = statsTable.DoorDamage - statsTable.DoorDamage * lenModifier
    statsTable.MaxRange = statsTable.MaxRange - statsTable.MaxRange * lenModifier

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

ORGM.setWeaponStats = function(weapon, ammoType)
    ORGM.log(ORGM.DEBUG, "Setting "..weapon:getType() .. " ammo to "..tostring(ammoType))
    local details = ORGM.getFirearmData(weapon)
    local ammoData = ORGM.getAmmoData(ammoType) or {}
    local modData = weapon:getModData()
    local upgrades = ORGM.getItemComponents(weapon)

    -- set inital values from defaults
    local stats = ORGM.getAbsoluteFirearmStats(details.instance, ammoData)
    -- adjust weight first
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
    ORGM.adjustFirearmStatsByAmmoType(weapon, ammoData, stats, effectiveWgt)

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

ORGM[3] = "\0686\070646"


-- Absolute Constants
local ABS_FULLAUTOSWINGTIME = 0.3 -- full auto only, anything else is dynamic
local ABS_CRITICALCHANCE = 20 -- default
local ABS_AIMINGPERKCRITMOD = 10 -- default
local ABS_AIMINGPERKHITMOD = 7 -- default

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


ORGM.getAbsoluteFirearmStats = function(instance, ammoData)
    return { 
        Weight = instance:getWeight(), 
        ActualWeight = instance:getActualWeight(),
        MinDamage = (ammoData.MinDamage or instance:getMinDamage()) * ORGM.Settings.DamageMultiplier,
        MaxDamage = (ammoData.MaxDamage or instance:getMaxDamage()) * ORGM.Settings.DamageMultiplier,
        DoorDamage = ammoData.DoorDamage or instance:getDoorDamage(),
        CriticalChance = ABS_CRITICALCHANCE, -- ammoData.CriticalChance or instance:getCriticalChance(),
        AimingPerkCritModifier = ABS_AIMINGPERKCRITMOD, -- this is modifier * (level/2)
        MaxHitCount = ammoData.MaxHitCount or instance:getMaxHitCount(),
        HitChance = instance:getHitChance(), -- redundant, we set to absolute
        
        MinAngle = instance:getMinAngle(),
        MinRange = instance:getMinRangeRanged(),
        AimingTime = instance:getAimingTime(), -- redundant, we set to absolute
        RecoilDelay = instance:getRecoilDelay(), -- redundant, we set to absolute
        ReloadTime = instance:getReloadTime(),
        MaxRange = instance:getMaxRange(),
        SwingTime = instance:getSwingTime(),
        AimingPerkHitChanceModifier = ABS_AIMINGPERKHITMOD,
    }
end

ORGM.adjustFirearmStatsByCategory = function(category, statsTable, effectiveWgt)
    if category == ORGM.PISTOL or category == ORGM.REVOLVER then
        statsTable.HitChance = 40
        statsTable.AimingTime = 40 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    elseif category == ORGM.RIFLE then
        statsTable.HitChance = 40
        statsTable.AimingTime = 25 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    elseif category == ORGM.SMG then
        statsTable.HitChance = 30
        statsTable.AimingTime = 40 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    elseif category == ORGM.SHOTGUN then
        statsTable.HitChance = 60
        statsTable.AimingTime = 40 + (effectiveWgt *MOD_WEIGHTAIMINGTIME)
    else
        statsTable.HitChance = 40 -- unknown??
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
      
      local cdetails = ORGM.getComponentData(mod)
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

ORGM.adjustFirearmStatsByActionType = function(actionType, statsTable)
    -- set recoil and swingtime modifications for automatics
    if actionType == ORGM.AUTO then
        statsTable.RecoilDelay = statsTable.RecoilDelay + ADJ_AUTORECOILDELAY -- recoil absorbed
        statsTable.SwingTime = statsTable.SwingTime + ADJ_AUTOSWINGTIME
    end
end

ORGM.adjustFirearmStatsByAmmoType = function(ammoData, statsTable, effectiveWgt)
    -- adjust recoil relative to ammo, weight, barrel
    statsTable.RecoilDelay = (ammoData.Recoil or 10) / (effectiveWgt * MOD_WEIGHTRECOILDELAY)
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
    ORGM.adjustFirearmStatsByAmmoType(ammoData, stats, effectiveWgt)
    
    ----------------------------------------------------
    -- adjust all by components first
    ORGM.adjustFirearmStatsByComponents(upgrades, stats)
    ORGM.adjustFirearmStatsByActionType(modData.actionType, stats)
    
    -- set other relative ammoData adjustments
    stats.HitChance = stats.HitChance + (ammoData.HitChance or 0)
    
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


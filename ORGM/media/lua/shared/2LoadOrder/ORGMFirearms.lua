--[[- Firearm Functions.

This file handles functions dealing with firearms data, and manipulating
HandWeapon/InventoryItem methods. Dynamic stat settings, reloadable
setup and ORGM version updates are contained.


@module ORGM.Firearm
@author Fenris_Wolf
@release 4.0
@copyright 2018 **File:** shared/2LoadOrder/ORGMFirearms.lua

]]
local ORGM = ORGM
local getTableData = ORGM.getTableData
local Settings = ORGM.Settings
local Firearm = ORGM.Firearm
local Stats = Firearm.Stats
local Barrel = Firearm.Barrel
local Hammer = Firearm.Hammer
local Trigger = Firearm.Trigger
local FirearmGroup = Firearm.FirearmGroup
local FirearmType = Firearm.FirearmType

local Ammo = ORGM.Ammo
local Magazine = ORGM.Magazine
local Component = ORGM.Component
local Reloadable = ORGM.ReloadableWeapon

local Flags = Firearm.Flags
local Status = Reloadable.Status

local Bit = BitNumber.bit32
local ZombRand = ZombRand
local table = table
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local FirearmTable = { }
local FirearmKeyTable = { }
local FirearmGroupTable = { }

--- Design Features Flags
-- @section DesignFeatureFlags

--- can cock manually, requires cocking before firing if not also DOUBLEACTION
Flags.SINGLEACTION = 1
--- auto cocks on trigger pull.
Flags.DOUBLEACTION = 2
--- has a select-fire mode switch.
Flags.SELECTFIRE = 4
--- switch has a semi auto position. for non-select fires this is not needed.
Flags.SEMIAUTO = 8
--- switch has a full auto position. this must be set for weapons always fullauto
Flags.FULLAUTO = 16
--- switch has a 2 shot burst position
Flags.BURST2 = 32
--- switch has a 3 shot burst position
Flags.BURST3 = 64
--- gun has a manual safety
Flags.SAFETY = 128
--- slide/bolt locks open after last shot. automatics only.
Flags.SLIDELOCK = 256
--- gun has a loaded chamber indicator
Flags.CHAMBERINDICATOR = 512
--- gun is a open-bolt design.
Flags.OPENBOLT = 1024
--- gun is a bullpup design.
Flags.BULLPUP = 2048
-- Flags.COCKED = 4096 -- gun is currently cocked.
--- gun has a free floating barrel.
Flags.FREEFLOAT = 8192
--- gun has no built in sights.
Flags.NOSIGHTS = 16384
--- gun can slamfire intentionally
Flags.SLAMFIRE = 32768
--- gun has a ported barrel
Flags.PORTED = 65536

--- Feed System Flags
-- @section FeedSystemFlags

--- gun is a automatic
Flags.AUTO = 1
--- gun is a bolt action
Flags.BOLT = 2
--- gun is a lever action
Flags.LEVER = 4
--- gun is a pump action
Flags.PUMP = 8
--- gun is a break-barrel/breach-loader.
Flags.BREAK = 16
--- gun uses a rotary cylinder
Flags.ROTARY = 32
--- gun is a blowback automatic
Flags.BLOWBACK = 64
--- gun is a delayed blowback automatic
Flags.DELAYEDBLOWBACK = 128
--- gun is a short piston gas fed automatic
Flags.SHORTGAS = 256
--- gun is a long piston gas fed automatic
Flags.LONGGAS = 512
--- gun is a direct impingement gas fed automatic
Flags.DIRECTGAS = 1024
--- gun is a long recoil automatic
Flags.LONGRECOIL = 2048
--- gun is a short recoil automatic
Flags.SHORTRECOIL = 4096

local FEEDTYPES = Flags.AUTO + Flags.BOLT + Flags.LEVER + Flags.PUMP + Flags.BREAK + Flags.ROTARY
local AUTOFEEDTYPES = Flags.BLOWBACK + Flags.DELAYEDBLOWBACK + Flags.SHORTGAS + Flags.LONGGAS + Flags.DIRECTGAS + Flags.LONGRECOIL + Flags.SHORTRECOIL
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

local PropertiesTable = {
    Weight = {type='float', min=0, max=100, default=1, required=true},
    WeaponSprite = {type='string', default="", required=true},
    SwingSound = {type='string', default="", required=true},
    Icon = {type='string', default="", required=true},
    ammoType = {type='string', default="", required=true},
    moduleName = {type='string', default='ORGM'},
    reloadClass = {type='string', default='ISORGMWeapon'},


    classification = {type='string', default="Unknown"},
    country = {type='string', default="Unknown"},
    manufacturer = {type='string', default="Unknown"},
    description = {type='string', default="No description available"},
    category = {type='integer', min=0, max=100, default=1, required=true},

    features = {type='integer', min=0, default=0, required=true},

    rackTime = {type='integer', min=0, default=10},
    reloadTime = {type='integer', min=0, default=10},
    barrelLength = {type='float', min=0, default=10, required=true},
    feedSystem = {type='integer', min=0, default=Flags.AUTO+Flags.BLOWBACK, required=true},
    maxCapacity = {type='integer', min=0, default=10},


    lastChanged = {type='integer', min=0, defaullt=nil},
}
--- FirearmGroup Methods
-- @section FirearmGroup


setmetatable(FirearmGroup, { __index = ORGM.Group })

function FirearmGroup:new(groupName, groupData)
    local o = ORGM.Group.new(self, groupName, groupData, FirearmGroupTable)
    setmetatable(o, { __index = self })
    return o
end
function FirearmGroup:random(typeModifiers, filter)
    return ORGM.Group.random(self, typeModifiers, filter, FirearmGroupTable, FirearmTable)
end

function FirearmGroup:spawn(container, loaded, typeModifiers, flagModifiers, chance, mustFit)
    local firearm = self:random(typeModifiers, flagModifiers)
    return firearm:spawn(container, loaded, chance, mustFit)
end
function FirearmGroup:test()
    -- pick a random gun manufactured by colt
    local group = Firearm.getGroup('Group_Colt')
    local result = group:random({
        Group_Colt_Revolvers = 3, -- x3 more likely to choose a revolver
        Colt_Anaconda_MM4540 = 0, -- dont pick this ultra rare version
        Colt_M16_M603 = 2, -- if we do pick a rifle, and its a CAR15/M16 then twice a likely its a m16a1
        Colt_M16_M645 = 0.5 -- and only half as likey its a m16a2
    })
    print(result)
end


--- FirearmType Methods
-- @section FirearmType

function FirearmType:new(firearmType, firearmData, template)
    local o = { }
    template = template or { }
    for key, value in pairs(firearmData) do o[key] = value end
    setmetatable(o, { __index = self })
    ORGM.log(ORGM.VERBOSE, "FirearmType: Initializing ".. firearmType)
    o.type = firearmType
    o.moduleName = 'ORGM'
    -- setup specific properties and error checks
    if not ORGM.copyPropertiesTable("FirearmType: ".. firearmType, PropertiesTable, template, o) then
        return nil
    end
    o.features = o.features + (o.addFeatures or 0)
    o.addFeatures = nil

    ---------------------------------------------------------------------------------------------------
    -- bitwise flag validation

    if Bit.band(o.features, Flags.SINGLEACTION + Flags.DOUBLEACTION) == 0 then
        ORGM.log(ORGM.ERROR, "FirearmType: Missing required feature for " .. firearmType .. " (SINGLEACTION|DOUBLEACTION)")
        return
    end

    if Bit.band(o.feedSystem, FEEDTYPES) == 0 then
        ORGM.log(ORGM.ERROR, "FirearmType: Missing required feature for " .. firearmType .. " (AUTO|BOLT|LEVER|PUMP|BREAK|ROTARY)")
        return
    end
    if Bit.band(o.feedSystem, Flags.AUTO) ~= 0 and Bit.band(o.feedSystem, Flags.BLOWBACK + Flags.DELAYEDBLOWBACK + Flags.SHORTGAS + Flags.LONGGAS + Flags.DIRECTGAS + Flags.LONGRECOIL + Flags.SHORTRECOIL) == 0 then
        ORGM.log(ORGM.ERROR, "FirearmType: Missing required feature flag for " .. firearmType .. " (BLOWBACK|DELAYEDBLOWBACK|SHORTGAS|LONGGAS|DIRECTGAS|LONGRECOIL|SHORTRECOIL)")
        return
    end


    ---------------------------------------------------------------------------------------------------

    -- some basic error checking
    if o.lastChanged and o.lastChanged > ORGM.BUILD_ID then
        ORGM.log(ORGM.ERROR, "FirearmType: Invalid lastChanged for " .. firearmType .. " (must be 1 to "..ORGM.BUILD_ID .. ")")
        o.lastChanged = ORGM.BUILD_ID
    end
    -- TODO: fix this nastiness
    if o.category ~= ORGM.REVOLVER and o.category ~= ORGM.PISTOL and o.category ~= ORGM.SUBMACHINEGUN and o.category ~= ORGM.RIFLE and o.category ~= ORGM.SHOTGUN then
        ORGM.log(ORGM.WARN, "FirearmType: category for " .. firearmType .. " is set to "..o.category.." should be one of: ORGM.REVOLVER | ORGM.PISTOL | ORGM.SUBMACHINEGUN | ORGM.RIFLE | ORGM.SHOTGUN")
    end

    if not ORGM.Ammo.isGroup(o.ammoType) and not ORGM.Magazine.isGroup(o.ammoType) then
        ORGM.log(ORGM.ERROR, "FirearmType: Invalid AmmoType for " .. firearmType .. " (Ammo or Magazine not registered: "..o.ammoType ..")")
        return
    end

    -- apply any defaults from the ORGM.Sounds.Profiles table
    if (template.soundProfile and ORGM.Sounds.Profiles[template.soundProfile]) then
        for key, value in pairs(ORGM.Sounds.Profiles[template.soundProfile]) do
            o[key] = template[key] or value
        end
    else
        ORGM.log(ORGM.WARN, "Invalid soundProfile for " .. firearmType .. " ("..tostring(template.soundProfile)..")")
    end

    for _, key in ipairs(ORGM.Sounds.KeyTable) do
        if o[key] then ORGM.Sounds.add(o[key]) end
    end

    -- check if gun uses a mag, and link clipData
    if ORGM.Magazine.isMagazine(o.ammoType) then
        o.containsClip = 1
        -- variantData.clipData = ORGM.Magazine.getData(variantData.ammoType)
    end
    local isTwoHanded = true
    if Bit.band(o.category, ORGM.REVOLVER + ORGM.PISTOL + ORGM.MACHINEPISTOL) ~= 0 then
        isTwoHanded = false
    end
    local scriptItems = { }
    table.insert(scriptItems, {
        "\titem " .. firearmType,
        "\t{",
        "\t\tDisplayName            = "..firearmType .. ",",
        "\t\tAmmoType               = "..o.ammoType .. ",",
        "\t\tWeight                 = "..o.Weight .. ",",
        "\t\tWeaponWeight           = " ..o.Weight .. ",",

        --"/** Appearance **/",
        "\t\tIcon                   = "..o.Icon .. ",",
        "\t\tWeaponSprite           = " .. o.WeaponSprite .. ',',
        "\t\tRunAnim                = Run_Weapon2,",
        "\t\tIdleAnim               = "..(isTwoHanded and 'Idle_Weapon2' or 'Idle') ..",",
        "\t\tSwingAnim              = "..(isTwoHanded and 'Rifle' or 'Handgun') ..",",
        "\t\tSwingSound             = " .. o.SwingSound .. ',',
        --"\t\tTwoHandedWeapon                = "..(isTwoHanded and 'TRUE' or 'FALSE') ..",",
        "\t\tRequiresEquippedBothHands      = "..(isTwoHanded and 'TRUE' or 'FALSE') ..",",

        --"/** Set By ORGM Config Options **/",
        "\t\tCriticalChance                 = 20,",
        "\t\tHitChance                      = 50,",
        "\t\tAimingPerkCritModifier         = 10,",
        "\t\tAimingPerkHitChanceModifier    = 15,",
        "\t\tAimingPerkRangeModifier        = 2,",


        --"/** Dynamically Set Values **/",
        "\t\tMinDamage                      = 1.4,",
        "\t\tMaxDamage                      = 2,",
        "\t\tDoorDamage                     = 4,",
        "\t\tTreeDamage                     = 1,",

        "\t\tMaxRange                       = 1,",
        "\t\tMinRange                       = 0.6,",
        "\t\tSwingTime                      = 1.0,",
        "\t\tMinimumSwingTime               = 0.2,",
        "\t\tRecoilDelay                    = 10,",

        "\t\tSplatNumber                    = 3,",
        "\t\tSplatSize                      = 3,",
        "\t\tKnockdownMod                   = 1.5,",
        "\t\tPushBackMod                    = 0.4,",

        "\t\tAimingTime                     = 25,",
        "\t\tMaxHitCount                    = 1,",
        "\t\tMinAngle                       = 0.95,",
        "\t\tAimingPerkMinAngleModifier     = 0.01,",

        "\t\tSoundGain                      = 2,",
        "\t\tSoundRadius                    = 170,",
        "\t\tSoundVolume                    = 75,",

        "\t\tClipSize                       ="..(o.maxCapacity or 6) .. ",",
        "\t\tPiercingBullets                = FALSE,",

        --"/** Static Values **/",
        "\t\tType                   = Weapon,",
        "\t\tSubCategory            = Firearm,",
        "\t\tIsAimedHandWeapon      = TRUE,",
        "\t\tIsAimedFirearm         = TRUE,",

        "\t\tReloadTime             = 10,",

        "\t\tImpactSound            = null,",
        --ShellFallSound              =
        "\t\tBreakSound             = PZ_MetalSnap,",
        "\t\tNPCSoundBoost          = 1.5,",

        "\t\tShareDamage            = FALSE,",
        "\t\tRanged                         = TRUE,",
        "\t\tSwingAmountBeforeImpact        = 0,",

        --AngleFalloff                = TRUE,
        "\t\tToHitModifier                  =   1.5,",
        "\t\tProjectileCount                = 1,",
        "\t\tConditionMax                   = 10,",
        "\t\tConditionLowerChanceOneIn      = 200,",
        "\t\tUseEndurance                   = FALSE,",
        "\t\tMultipleHitConditionAffected   = FALSE,",
        "\t\tSplatBloodOnNoDeath            = TRUE,",
        "\t\tKnockBackOnNoDeath             = TRUE,",
        "\t}"
    })
    ORGM.createScriptItems('ORGM', scriptItems)
    o.instance = InventoryItemFactory.CreateItem(o.moduleName .. "." .. firearmType)

    if not o.instance then
        ORGM.log(ORGM.ERROR, "FirearmType: Could not create instance of " .. firearmType .. " (Registration Failed)")
        return nil
    end

    FirearmTable[firearmType] = o
    ReloadUtil:addWeaponType(o)
    for group, weight in pairs(o.Groups or template.Groups) do
        group = FirearmGroupTable[group]
        if group then group:add(firearmType, weight) end
    end
    for group, weight in pairs(o.addGroups or {}) do
        group = FirearmGroupTable[group]
        if group then group:add(firearmType, weight) end
    end
    table.insert(FirearmKeyTable, firearmType)
    ORGM.log(ORGM.DEBUG, "FirearmType: Registered " .. o.instance:getDisplayName() .. "\t\t (ID: "..firearmType ..")")
    return o
end

function FirearmType:newCollection(ammoType, template, variants)
    ORGM.log(ORGM.VERBOSE, "FirearmType: Starting Collection ".. ammoType)
    for variant, variantData in pairs(variants) do
        FirearmType:new(ammoType .. "_" .. variant, variantData, template)
    end
end

function FirearmType:spawn(container, loaded, chance, mustFit)
    if chance and ZombRand(100)+1 <= chance * ZomboidGlobals.WeaponLootModifier * Settings.FirearmSpawnModifier then
        return nil
    end
    local item = InventoryItemFactory.CreateItem("ORGM.".. self.type)
    if mustFit and not container:hasRoomFor(nil, item:getActualWeight()) then
		return nil
	end

    self:setup(item)

    -- set the serial number
    local sn = {}
    for i=1, 6 do sn[i] = tostring(ZombRand(10)) end
    item:getModData().serialnumber = table.concat(sn, '')

    if loaded then
        local count = self.maxCapacity
        if ZombRand(100) < 50 then count = ZombRand(self.maxCapacity)+1 end
    end
    Firearm.refill(item, count)
    Firearm.Stats.set(item)
    if container then
        container:AddItem(item)
    end
    return item
end

--[[- Sets up a gun, applying key/values into the items modData.
This should be called whenever a firearm is spawned.
Basically the same as ReloadUtil:setupGun and ISORGMWeapon:setupReloadable but
called without needing a player or reloadable object.

@usage ORGM.Firearm.setup(Firearm.getData(weaponItem), weaponItem)
@tparam table gunData return value of `ORGM.Firearm.getData`
@tparam HandWeapon weaponItem

]]
function FirearmType:setup(item)
    local modData = item:getModData()
    -- ISReloadableWeapon.setupReloadable(self, weapon, v)
    --modData.defaultAmmo = self.ammoType -- weaponItem:getAmmoType()
    --modData.defaultSwingSound = self.SwingSound -- weaponItem:getSwingSound()
    modData.type = self.type
    modData.moduleName = self.moduleName
    modData.reloadClass = self.reloadClass
    modData.ammoType = self.ammoType
    --modData.loadStyle = self.reloadStyle -- TODO: unused?
    --modData.ejectSound = self.ejectSound -- TODO: doesnt need to be in modData
    --modData.clickSound = self.clickSound -- TODO: doesnt need to be in modData
    --modData.insertSound = self.insertSound -- TODO: doesnt need to be in modData
    --modData.rackSound = self.rackSound -- TODO: doesnt need to be in modData
    modData.maxCapacity = self.maxCapacity
    modData.reloadTime = self.reloadTime
    modData.rackTime = self.rackTime
    modData.currentCapacity = 0

    -- custom stuff
    --modData.cockSound = self.cockSound -- TODO: doesnt need to be in modData
    --modData.openSound = self.openSound -- TODO: doesnt need to be in modData
    --modData.closeSound = self.closeSound -- TODO: doesnt need to be in modData


    if self:hasMagazine() then
        -- TODO: this could be a issue when resetting to default. Need to check
        -- if we have a mag, and what type it is. Also there may not be a mag inserted
        local mag = Magazine.getGroup(self.ammoType):random()
        modData.magazineType = mag.type
        modData.maxCapacity = mag.maxCapacity
    else -- sanity check when resetting to default
        modData.magazineType = nil
    end

    modData.speedLoader = self.speedLoader -- speedloader/stripperclip name
    -- normally isAutomatic checks modData.feedSystem, but thats not set yet so self.feedSystem is used.
    -- direct copying of self.feedSystem to modData.feedSystem is not desirable for dual type systems like
    -- the spas-12. modData.feedSystem should only contain the current firemode.
    if self:isAutomatic() then
        modData.feedSystem = Flags.AUTO + Bit.band(self.feedSystem, AUTOFEEDTYPES)
    --elseif Firearm.isRotary(weaponItem, self) then
    --elseif Firearm.isBolt(weaponItem, self) then
    --elseif Firearm.isPump(weaponItem, self) then
    --elseif Firearm.isLever(weaponItem, self) then
    --elseif Firearm.isBreak(weaponItem, self) then
    else
        modData.feedSystem = self.feedSystem
    end

    if self:isFeedType(Flags.ROTARY + Flags.BREAK) then
        modData.cylinderPosition = 1 -- position is 1 to maxCapacity (required for % oper to work properly)
        --modData.roundChambered = nil
        --modData.emptyShellChambered = nil
    else
        modData.chambered = nil
        --modData.roundChambered = 0 -- 0 or 1, a round is currently chambered
        --modData.emptyShellChambered = 0 -- 0 or 1, a empty shell is currently chambered
    end

    local status = 0
    -- set the current firemode to first available position.

    --if Firearm.isSelectFire(weaponItem, self) then
    if self:isSemiAuto() then
        status = status + Status.SINGLESHOT
    elseif self:isFullAuto() then
        status = status + Status.FULLAUTO
    elseif self:is2ShotBurst() then
        status = status + Status.BURST2
    elseif self:is3ShotBurst() then
        status = status + Status.BURST3
    else
        status = status + Status.SINGLESHOT
    end
    --end
    modData.status = status

    modData.magazineData = {} -- current rounds, LIFO list
    modData.strictAmmoType = nil -- preferred ammo type, this is set by the UI context menu
    -- last round the stats were set to, used for knowing what to eject, and if we should change weapon stats when chambering next round
    modData.setAmmoType = nil
    -- what type of rounds are loaded, either ammo name, or 'mixed'. This is only really used when ejecting a magazine, so the mag's modData
    -- has this flagged (used when loading new mags to match self.preferredAmmoType). Also used in tooltips
    modData.loadedAmmoType = nil
    modData.roundsFired = 0
    modData.roundsSinceCleaned = 0
    modData.barrelLength = self.barrelLength
    --[[
    if ZombRand(100) > 50 and self.barrelLengthOpt then
        -- pick random length from our options
        modData.barrelLength = self.barrelLengthOpt[ZombRand(#self.barrelLengthOpt)+1]
    else
    end
    ]]
    modData.BUILD_ID = ORGM.BUILD_ID
end


function FirearmType:randMag()
    local group = Magazine.getGroup(self.ammoType)
    if not group then return nil end
    return group:random()
end

function FirearmType:isFeature(flags)
    return Bit.band(self.features, flags) ~= 0
end

function FirearmType:isSelectFire()
    return self:isFeature(Flags.SELECTFIRE)
end

function FirearmType:isFullAuto()
    return self:isFeature(Flags.FULLAUTO)
end

function FirearmType:isSemiAuto()
    return self:isFeature(Flags.SEMIAUTO)
end

function FirearmType:is2ShotBurst()
    return self:isFeature(Flags.BURST2)
end

function FirearmType:is3ShotBurst()
    return self:isFeature(Flags.BURST3)
end

function FirearmType:isOpenBolt()
    return self:isFeature(Flags.OPENBOLT)
end

function FirearmType:isBullpup()
    return self:isFeature(Flags.BULLPUP)
end

function FirearmType:isFreeFloat()
    return self:isFeature(Flags.FREEFLOAT)
end

function FirearmType:isSightless()
    return self:isFeature(Flags.NOSIGHTS)
end
function FirearmType:hasSafety()
    return self:isFeature(Flags.SAFETY)
end
function FirearmType:hasSlideLock()
    return self:isFeature(Flags.SLIDELOCK)
end
function FirearmType:hasChamberIndicator()
    return self:isFeature(Flags.CHAMBERINDICATOR)
end

function FirearmType:isFeedType(value)
    if not value then value = FEEDTYPES end
    return Bit.band(self.feedSystem, value) ~= 0
end
function FirearmType:isRotary()
    return self:isFeedType(Flags.ROTARY)
end
function FirearmType:isAutomatic()
    return self:isFeedType(Flags.AUTO)
end
function FirearmType:isBolt()
    return self:isFeedType(Flags.Bolt)
end
function FirearmType:isPump()
    return self:isFeedType(Flags.PUMP)
end
function FirearmType:isLever()
    return self:isFeedType(Flags.LEVER)
end
function FirearmType:isBreak()
    return self:isFeedType(Flags.BREAk)
end

function FirearmType:hasMagazine()
    return Magazine.isGroup(self.ammoType)
end

-- #############################################################################

--- Data Functions
-- @section FirearmData

--[[- Gets the table of registered FirearmType objects

@treturn table all registered FirearmType objects

]]
Firearm.getTable = function()
    return FirearmTable
end
--[[- Returns the ammo group table for the specified groupName.

The table contains all the ammo types that can be used for this group.

@tparam string groupName name of a ammo group

@treturn nil|table list of real ammo names

]]
Firearm.getGroup = function(groupName)
    return FirearmGroupTable[groupName]
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


-- #############################################################################

--- Feature Functions
-- @section FirearmData

Firearm.modeStatus2Flag = function(status)
    if status == Status.SINGLESHOT then return Flag.SEMIAUTO end
    if status == Status.FULLAUTO then return Flag.FULLAUTO end
    if status == Status.BURST2 then return Flag.BURST2 end
    if status == Status.BURST3 then return Flag.BURST3 end
end

Firearm.modeFlag2Status = function(flag)
    if flag == Flag.SEMIAUTO then return Status.SINGLESHOT end
    if flag == Flag.FULLAUTO then return Status.FULLAUTO end
    if flag == Flag.BURST2 then return Status.BURST2 end
    if flag == Flag.BURST3 then return Status.BURST3 end
end

Firearm.isFeature = function(item, flags)
    local data = Firearm.getData(item)
    if not data then return nil end
    return data:isFeature(flags)
end

--[[- Checks if a firearm is select fire.

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn nil|bool nil if not a firearm, else true or false.
]]
Firearm.isSelectFire = function(item)
    return Firearm.isFeature(item, Flags.SELECTFIRE)
end

--[[- Returns if the firearm is capable of full-auto fire.

Not to be confused with `ORGM.ReloadableWeapon.isFullAuto`

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@return boolean or nil

]]
Firearm.isFullAuto = function(item)
    return Firearm.isFeature(item, Flags.FULLAUTO)
end

Firearm.isSemiAuto = function(item)
    return Firearm.isFeature(item, Flags.SEMIAUTO)
end

Firearm.is2ShotBurst = function(item)
    return Firearm.isFeature(item, Flags.BURST2)
end

Firearm.is3ShotBurst = function(item)
    return Firearm.isFeature(item, Flags.BURST3)
end

Firearm.isOpenBolt = function(item)
    return Firearm.isFeature(item, Flags.OPENBOLT)
end

Firearm.isBullpup = function(item)
    return Firearm.isFeature(item, Flags.BULLPUP)
end

Firearm.isFreeFloat = function(item)
    return Firearm.isFeature(item, Flags.FREEFLOAT)
end

Firearm.isSightless = function(item)
    return Firearm.isFeature(item, Flags.NOSIGHTS)
end

Firearm.hasSafety = function(item)
    return Firearm.isFeature(item, Flags.SAFETY)
end

Firearm.hasSlideLock = function(item)
    return Firearm.isFeature(item, Flags.SLIDELOCK)
end

Firearm.hasChamberIndicator = function(item)
    return Firearm.isFeature(item, Flags.CHAMBERINDICATOR)
end

Firearm.isFeedType = function(item, value)
    return Firearm.isFeedType(item, value)
end
Firearm.isRotary = function(item)
    return Firearm.isFeedType(item, Flags.ROTARY)
end
Firearm.isAutomatic = function(item)
    return Firearm.isFeedType(item, Flags.AUTO)
end
Firearm.isBolt = function(item)
    return Firearm.isFeedType(item, Flags.Bolt)
end
Firearm.isPump = function(item)
    return Firearm.isFeedType(item, Flags.PUMP)
end
Firearm.isLever = function(item)
    return Firearm.isFeedType(item, Flags.LEVER)
end
Firearm.isBreak = function(item)
    return Firearm.isFeedType(item, Flags.BREAk)
end

Firearm.hasMagazine = function(item)
    local data = Firearm.getData(item)
    if not data then return nil end
    return data:hasMagazine()
end

-- #############################################################################

--- Item Manipulation Functions
-- @section FirearmItems

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


Firearm.refill = function(item, count, ammoType)
    local data = item:getModData()
    local ammoGroup = Ammo.itemGroup(item, true)

    if ammoType then
        local ammoData = Ammo.getData(ammoType)
        if not ammoData:isGroupMember(ammoGroup.type) then return false end
    else
        ammoType = ammoGroup:random().type
    end
    if not count then count = data.maxCapacity end
    for i=1, count do
        data.magazineData[i] = ammoType
    end
    data.currentCapacity = count
    data.loadedAmmoType = ammoType
end


-- TODO: move to Reloadable
--[[- Sets up a gun, applying key/values into the items modData.
This should be called whenever a firearm is spawned.
Basically the same as ReloadUtil:setupGun and ISORGMWeapon:setupReloadable but
called without needing a player or reloadable object.

@usage ORGM.Firearm.setup(Firearm.getData(weaponItem), weaponItem)
@tparam table gunData return value of `ORGM.Firearm.getData`
@tparam HandWeapon weaponItem

]]
Firearm.setup = function(gunData, weaponItem)
    gunData:setup(weaponItem)
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

Firearm.setFireMode = function(item, mode, playerObj)
    if not Firearm.isFirearm(item) then return end
    Reloadable.Fire.set(item:getModData(), mode)
    if playerObj then playerObj:playSound("ORGMRndLoad", false) end
    Firearm.Stats.set(item)
end

--[[- Toggles the position of the Select Fire switch on a firearm.

@tparam InventoryItem item
@tparam[opt] nil|int mode If nil, toggles. Otherwise sets to `ORGM.SEMIAUTOMODE` or `ORGM.FULLAUTOMODE`
@tparam[optchain] IsoPlayer playerObj

]]
Firearm.toggleFireMode = function(item, mode, playerObj)
    local itemData = Firearm.getData(item)
    if not itemData then return end
    if not Firearm.isSelectFire(item, itemData) then return end -- not select fire
    if Reloadable.isStatus(item:getModData(), mode) then -- already in this mode
        mode = Status.SINGLESHOT
    end
    if not Firearm.isFeature(itemData, Firearm.modeStatus2Flag(mode)) then return end -- invalid mode
    Firearm.setFireMode(item, mode, playerObj)
end


Firearm.toggleSafety = function(item, engage, playerObj)
    local itemData = Firearm.getData(item)
    if not itemData then return end
    if not Firearm.hasSafety(item, itemData) then return end -- not select fire
end



--[[- Checks if a firearm is loaded.

@tparam HandWeapon item

@treturn bool true if the firearm has any ammo in it.

]]
Firearm.isLoaded = function(item)
    local modData = item:getModData()
    if modData.chambered and not Ammo.isCase(modData.chambered) then
        return true
    elseif modData.currentCapacity and modData.currentCapacity > 0 then
        return true
    end
    return false
end

--- Trigger Table
-- @section FirearmTrigger

--[[- Returns the trigger type of the firearm.

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn nil|bool nil if not a firearm, else true or false.

]]
Trigger.type = function(item, itemData, value)
    itemData = itemData or Firearm.getData(item)
    if not itemData then return nil end
    if not value then value = Flags.SINGLEACTION + Flags.DOUBLEACTION end
    return Bit.band(itemData.features, value)
end

--[[- Checks if the hammer/trigger is single-action.

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn bool

]]
Trigger.isSAO = function(item, itemData)
    return Trigger.type(item, itemData) == Flags.SINGLEACTION
end

--[[- Checks if the hammer/trigger is double-action.

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn bool

]]
Trigger.isDA = function(item, itemData)
    return Trigger.type(item, itemData) == Flags.SINGLEACTION + Flags.DOUBLEACTION
end

--[[- Checks if the hammer/trigger is double-action-only.

@tparam HandWeapon item
@tparam[opt] table itemData return value of `ORGM.Firearm.getData`, auto detected if nil.

@treturn bool

]]
Trigger.isDAO = function(item, itemData)
    return Trigger.type(item, itemData) == Flags.DOUBLEACTION
end


--- Hammer Table
-- @section FirearmHammer

--[[- NOTE: Depreciated. Checks if the hammer is cocekd.

@tparam HandWeapon item

@treturn nil|bool nil if not a firearm, else true or false.

]]
Hammer.isCocked = function(item)
    if not Firearm.isFirearm(item) then return nil end
    return Reloadable.Hammer.isCocked(item:getModData())
end


--- Barrel Table
-- @section FirearmBarrel

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

    --Stats.adjustByCategory(gunData.category, statsTable, effectiveWgt)
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
        DoorDamage = ammoData.DoorDamage or instance:getDoorDamage(),
        TreeDamage = ammoData.TreeDamage or instance:getTreeDamage(),
        CriticalChance = Settings.DefaultCriticalChance, -- dynamic setting below
        AimingPerkCritModifier = Settings.DefaultAimingCritMod, -- this is modifier * (level/2)
        MaxHitCount = ammoData.MaxHitCount or instance:getMaxHitCount(),
        HitChance = Settings.DefaultHitChance, -- dynamic setting below

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

    local optimal = 30
    if ammoData and ammoData.category then
        if Bit.band(ammoData.category, Ammo.Flags.PISTOL) ~= 0 then
            optimal = 30
        elseif Bit.band(ammoData.category, Ammo.Flags.RIFLE) ~= 0 then
            optimal = 80
        elseif Bit.band(ammoData.category, Ammo.Flags.SHOTGUN) ~= 0 then
            optimal = 60
        end
    end

    -- TODO: check reloadable
    local isAuto = gunData:isAutomatic()
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
    -- TODO: fix for bitflags
    if isAuto and gunData.autoType then
        recoilActionAdj = recoilActionAdj + (ADJ_AUTOTYPERECOILDELAY[gunData.autoType] or 0)
    end
    local lenModifierRecoil = calcBarrelModifier(optimal + recoilActionAdj, length + recoilActionAdj)
    statsTable.RecoilDelay =  statsTable.RecoilDelay + statsTable.RecoilDelay * lenModifierRecoil

    -- now for the noise...
    --statsTable.SoundRadius = ???

    statsTable.AimingTime = 50 - (effectiveWgt *MOD_WEIGHTAIMINGTIME) - length
    if gunData:isBullpup() then
        statsTable.AimingTime = statsTable.AimingTime + 6
    end
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
    local isFullAuto = Reloadable.Fire.isFullAuto(weaponItem:getModData())
    --if alwaysFullAuto then fireMode = ORGM.FULLAUTOMODE end
    if gunData:isAutomatic() then
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



--[[
    free recoil calcuation.
    https://en.wikipedia.org/wiki/Free_recoil

    mgu is the weight of the small arm expressed in kilograms (kg).
    mp is the weight of the projectile expressed in grams (g).
    mc is the weight of the powder charge expressed in grams (g).
    vp is the velocity of the projectile expressed in meters per second (m/s).
    vc is the velocity of the powder charge expressed in meters per second (m/s).

function freerecoil(mgu, mp, mc, vp, vc)
    return 0.5 * ((((mp*vp)+(mc*vc)) / 1000 )^2) /mgu
end

]]

-- ORGM[16] = "\116\111\110\117"

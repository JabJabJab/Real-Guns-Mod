--[[- ORGM Rechambered

The core ORGM table of ORGM Rechambered.

All functions and tables can be accessed via the global table named ORGM.
This mod's core philosophy is to place as little as possible in the global
namespace for performance reasons as Zomboid's lua global namespace is already
heavily polluted.
Because of this, you should always pull the ORGM table (or it's sub-tables)
into the local namespace.

    local ORGM = ORGM

## Example
    -- pull tables into local namespace
    local ORGM = ORGM
    local Firearm = ORGM.Firearm
    local Cylinder = ORGM.ReloadableWeapon.Cylinder
    local Hammer = ORGM.ReloadableWeapon.Hammer

    -- Spin the cylinder and cock the hammer for a IsoPlayer.
    local function spinAndCock(playerObj)
        local item = Firearm.getFirearm(playerObj)
        if not item return end
        -- check if its rotary fed
        if not Firearm.isRotary(item) then return end
        -- rotate the cylinder
        Cylinder.rotate(item:getModData(), nil, playerObj, true, item)
        -- Can't cock a double action only
        if Firearm.Hammer.isDAO() then return end
        Hammer.cock(item:getModData(), playerObj, true, item)
    end

@module ORGM
@release 3.09
@author Fenris_Wolf.
@copyright 2018 **File:** shared/1LoadOrder/ORGMCore.lua

]]

-- Functions are not listed in this file, they are loaded into it by the other files in the mod.

ORGM = { }

--- Modules
-- @section Modules

--- Contains all ORGM server-side functions, see: `ORGM.Server`
ORGM.Server = { }
ORGM.Server.Spawn = { }
ORGM.Server.CommandHandler = { }
ORGM.Server.Callbacks = { }

--- Contains all ORGM client-side functions, see: `ORGM.Client`.
ORGM.Client = { }
ORGM.Client.CommandHandler = { }
ORGM.Client.Callbacks = { }
ORGM.Client.Menu = { }

--- Functions for controlling and performing actions with firearms, see: `ORGM.ReloadableWeapon`.
--
-- These work on both ISReloadableWeapon objects, and a InventoryItem's modData.
ORGM.ReloadableWeapon = { }
ORGM.ReloadableWeapon.Fire = { }
ORGM.ReloadableWeapon.Ammo = { }
ORGM.ReloadableWeapon.Magazine = { }
ORGM.ReloadableWeapon.Cylinder = { }
ORGM.ReloadableWeapon.Break = { }
ORGM.ReloadableWeapon.Bolt = { }
ORGM.ReloadableWeapon.Reload = { }
ORGM.ReloadableWeapon.Unload = { }
ORGM.ReloadableWeapon.Rack = { }
ORGM.ReloadableWeapon.Hammer = { }

--- Contains all firearm functions, see: `ORGM.Firearm`.
ORGM.Firearm = { }
ORGM.Firearm.Stats = { }
ORGM.Firearm.Barrel = { }
ORGM.Firearm.Hammer = { }

--- Contains all ammo functions, see: `ORGM.Ammo`.
ORGM.Ammo = { }

--- Contains all component functions, see: `ORGM.Component`.
ORGM.Component = { }

--- Contains all magazine functions, see: `ORGM.Magazine`.
ORGM.Magazine = { }

--- Contains all maintance functions, see: `ORGM.Maintance`.
ORGM.Maintance = { }

--- Contains all callback functions, see: `ORGM.Callbacks`.
ORGM.Callbacks = { }

--- Contains all sound setup functions, see: `ORGM.Sounds`.
ORGM.Sounds = { }
ORGM.Sounds.Profiles = { }

--- Constants
-- @section Constants

--- Author of the mod.
ORGM.AUTHOR = "Original mod by ORMtnMan, Rechambered by Fenris_Wolf"

--- this table is used to track build #'s for backwards compatibility. All guns will be stamped with a index
-- number - the build it was last used in. A table exists changes to firearms (name = buildnumber). If the
-- gun build id < lastChanged build id then the gun needs to be reset to default values (fixed for the
-- new version.)
ORGM.BUILD_HISTORY = {
    "2.00-alpha", "2.00-beta-rc1", "2.00-beta-rc2", "2.00-beta-rc3", "2.00-beta-rc4", "2.00-beta-rc5", "2.00-beta-rc6", -- 7
    "2.00-stable", "2.01-stable", "2.02-stable", "2.03-stable", -- 11
    "3.00-alpha", "3.00-beta-rc1", "3.00-beta-rc2", "3.00-stable", "3.01-stable", "3.02-stable", "3.03-stable","3.04-stable","3.05-stable",-- 20
    "3.06-stable", "3.07-beta", "3.07-stable", "3.08-stable", -- 24
    "3.09-beta-rc1", "3.09-stable", "3.09.1-stable", "3.09.2-stable" -- 28
}
--- Set automatically. The current version number.
ORGM.BUILD_ID = nil

--[[- Logging Constants.
These are passed to and checked when making calls to `ORGM.log`.
@section Logging
]]

--- integer 0
ORGM.ERROR = 0
--- integer 1
ORGM.WARN = 1
--- integer 2
ORGM.INFO = 2
--- integer 3
ORGM.DEBUG = 3
--- integer 4
ORGM.VERBOSE = 4

--- Trigger Constants
-- @section Trigger

--- integer 1
ORGM.SINGLEACTION = 1
--- integer 2
ORGM.DOUBLEACTION = 2
--- integer 3
ORGM.DOUBLEACTIONONLY = 3

--- Feed System Constants
-- @section FeedSystem

--- integer 1
ORGM.AUTO = 1
--- integer 2
ORGM.BOLT = 2
--- integer 3
ORGM.LEVER = 3
--- integer 4
ORGM.PUMP = 4
--- integer 5
ORGM.BREAK = 5
--- integer 6
ORGM.ROTARY = 6

--- Auto Feed Constants
-- @section AutoFeed

--- integer 1
ORGM.BLOWBACK = 1
--- integer 2
ORGM.DELAYEDBLOWBACK = 2
--- integer 3
ORGM.SHORTGAS = 3
--- integer 4
ORGM.LONGGAS = 4
--- integer 5
ORGM.DIRECTGAS = 5
--- integer 6
ORGM.LONGRECOIL = 6
--- integer 7
ORGM.SHORTRECOIL = 7

--- Category Constants
-- @section Category

--- integer 1
ORGM.PISTOL = 1
--- integer 2
ORGM.REVOLVER = 2
--- integer 3
ORGM.SUBMACHINEGUN = 3
--- integer 4
ORGM.RIFLE = 4
--- integer 5
ORGM.SHOTGUN = 5

--- Select Fire Constants
-- @section SelectFire

--- integer 0
ORGM.SEMIAUTOMODE = 0
--- integer 1
ORGM.FULLAUTOMODE = 1

--- Item type Constants
-- @section ItemTypes

ORGM.FIREARM = 1
ORGM.MAGAZINE = 2
ORGM.MAGAZINEGROUP = 3
ORGM.AMMO = 4
ORGM.AMMOGROUP = 5
ORGM.COMPONENT = 6
ORGM.MAINTANCE = 7

--- tooltip Constants
-- @section ToolTipStyle
ORGM.TIPFULL = 1
ORGM.TIPDYNAMIC = 2
ORGM.TIPCLASSIC = 3
ORGM.TIPNUMERIC = 4

--- Rarity Constants
-- @section Rarity

--- Common
ORGM.COMMON = 1
--- Rare
ORGM.RARE = 2
--- VeryRare
ORGM.VERYRARE = 3

--- String Tables
-- @section StringTable

ORGM.LogLevelStrings = { [0] = "ERROR", [1] = "WARN", [2] = "INFO", [3] = "DEBUG", [4] = "VERBOSE"}

--- Contains string names for actionType constants.
ORGM.ActionTypeStrings = {"Auto", "Bolt", "Lever", "Pump", "Break", "Rotary"}

--- Contains string names for triggerType constants.
ORGM.TriggerTypeStrings = {"SingleAction", "DoubleAction", "DoubleActionOnly"}

--- Contains string names for autoType constants.
ORGM.AutoActionTypeStrings = {"Blowback", "Delayed Blowback", "Short Gas Piston", "Long Gas Piston", "Direct Impingement Gas", "Long Recoil", "Short Recoil"}

--- Settings
-- @section Settings

--- table containing all ORGM settings
-- these are all defined below in the ORGM.SettingsValidator table
ORGM.Settings = { }


--- This table handles all the settings to be defined in ORGM.Settings, expected
-- value types, default values, min/max (for integers and floats) and any Functions
-- to run when updating this setting.
ORGM.SettingsValidator = { }




-- Table containing firearms sorted by rarity.
-- ORGM.FirearmRarityTable = {}


-- Table containing basic sound profiles for working the action.
-- Any key = value pairs here can be overridden by specific weapons, each key is only set in the
-- weapons data table if it doesn't already exist.
-- Note: shootSound is not covered in these profiles, as they are specific to each weapon, and not required
ORGM.Sounds.Profiles = { }

-- Table contains a a list of firearm keys we need to add to the SoundBankQueueTable.
ORGM.Sounds.KeyTable = { "clickSound", "insertSound", "ejectSound", "rackSound", "openSound", "closeSound", "cockSound" }

--[[ ORGM.SettingsValidator Table

This table handles all the settings to be defined in ORGM.Settings, expected
value types, default values, min/max (for integers and floats) and any Functions
to run when updating this setting.

]]

ORGM.SettingsValidator = {

    -- LogLevel: This controls how much text ORGM prints to the console and log file.
    -- valid options are ORGM.ERROR, ORGM.WARN, ORGM.INFO, ORGM.DEBUG, ORGM.VERBOSE (default ORGM.INFO)
    LogLevel = {type='integer', min=0, max=4, default=ORGM.INFO},

    -- JammingEnabled: Turns firearm jamming on or off.
    -- valid options are true or false. (default true)
    JammingEnabled = {type='boolean', default=true},

    -- CasesEnabled: Turns ejecting of empty cases on or off.
    -- valid options are true or false. (default true)
    CasesEnabled = {type='boolean', default=true},

    -- RemoveBaseFirearms:  Stops spawning of the base game firearms.
    -- valid options are true or false (default true)
    RemoveBaseFirearms = {type='boolean', default=true},
    --UseBarrelLengthModifiers = {type='boolean', default=true},
    DamageMultiplier = {type='float', min=0.1, default=0.6},
    DefaultHitChancePistol = {type='integer', min=0, max=100, default=40},
    DefaultHitChanceSMG = {type='integer', min=0, max=100, default=30},
    DefaultHitChanceRifle = {type='integer', min=0, max=100, default=40},
    DefaultHitChanceShotgun = {type='integer', min=0, max=100, default=60},
    DefaultHitChanceOther = {type='integer', min=0, max=100, default=40},
    DefaultAimingHitMod = {type='integer', min=0, max=100, default=7},
    DefaultCriticalChance = {type='integer', min=0, max=100, default=20},
    DefaultAimingCritMod = {type='integer', min=0, max=100, default=10},


    -- DefaultMagazineReoadTime:  The base time it takes to load a round into a magazine
    -- before modifiers for panic levels and reloading skill are applied. Note specific
    -- magazines may override this value.
    -- valid options are any integer number greater then 0 (default: 30)
    DefaultMagazineReoadTime = {type='integer', min=1, default=30, onUpdate=function(value) for _,data in pairs(ORGM.Magazine.getTable()) do data.reloadTime = value end end },

    -- DefaultReloadTime:  The base time it takes to load a magazine or round into a firearm
    -- before modifiers for panic levels and reloading skill are applied. Note specific
    -- magazines may override this value.
    -- valid options are any integer number greater then 0 (default: 15)
    DefaultReloadTime = {type='integer', min=1, default=15, onUpdate=function(value) for _,data in pairs(ORGM.Firearm.getTable()) do data.reloadTime = value end end },

    -- DefaultRackTime:  The base time it takes to rack a firearm before modifiers for panic
    -- levels and reloading skill are applied. Note specific magazines may override this value.
    -- valid options are any integer number greater then 0 (default: 10)
    DefaultRackTime = {type='integer', min=1, default=10, onUpdate=function(value) for _,data in pairs(ORGM.Firearm.getTable()) do data.rackTime = value end end },

    -- Set this to the year you want to limit firearms spawning to. ie: 1993 will not spawn any
    -- firearms manufactured after 1993, if nil then no year limits will be applied.
    LimitYear = {type='integer', min=0, default=0, nilAllowed=true, onUpdate=function(value) ORGM.Callbacks.limitFirearmYear() end },

    -- Spawn Rate Multipliers
    -- These values tweak the various spawn rates, and stack with the sandbox weapon loot rarity
    -- settings. Setting any of these to 0 will disable spawning of those items completely, while
    -- a value of 1 is normal ORGM spawning.

    -- FirearmSpawnModifier: Multiplier for ALL firearms spawning.
    FirearmSpawnModifier = {type='float', min=0, default=1.0},

    -- CivilianFirearmSpawnModifier: Multiplier for the chances a firearm is civilian class.
    CivilianFirearmSpawnModifier = {type='float', min=0, default=1.0},

    -- PoliceFirearmSpawnModifier: Multiplier for the chances a firearm is police class.
    PoliceFirearmSpawnModifier = {type='float', min=0, default=1.0},

    -- MilitaryFirearmSpawnModifier: Multiplier for the chances a firearm is military class.
    MilitaryFirearmSpawnModifier = {type='float', min=0, default=1.0},

    -- AmmoSpawnModifier: Multiplier for controlling the spawn rate of ammo, boxes and cans.
    AmmoSpawnModifier = {type='float', min=0, default=1.0},

    -- MagazineSpawnModifier: Multiplier for controlling the spawn rate of spare magazines
    MagazineSpawnModifier = {type='float', min=0, default=1.0},

    -- RepairKitSpawnModifier: Multiplier for controlling the spawn rate of repair kits
    RepairKitSpawnModifier = {type='float', min=0, default=1.0},

    -- ComponentSpawnModifier: Multiplier for controlling the spawn rate of weapon upgrades
    -- and parts. Note this only effects upgrades not attached to guns.
    ComponentSpawnModifier = {type='float', min=0, default=1.0},

    -- CorpseSpawnModifier: Multiplier for controlling the spawn rate on corpses
    CorpseSpawnModifier = {type='float', min=0, default=1.0},

    -- CivilianBuildingSpawnModifier: Multiplier for controlling the spawn rate in civilian buildings
    CivilianBuildingSpawnModifier = {type='float', min=0, default=1.0},

    -- PoliceStorageSpawnModifier: Multiplier for controlling the spawn rate in police storage rooms
    PoliceStorageSpawnModifier = {type='float', min=0, default=1.0},

    -- GunStoreSpawnModifier: Multiplier for controlling the spawn rate in the gun store
    GunStoreSpawnModifier = {type='float', min=0, default=1.0},

    -- StorageUnitSpawnModifier: Multiplier for controlling the spawn rate in storage units
    StorageUnitSpawnModifier = {type='float', min=0, default=1.0},

    -- GarageSpawnModifier: Multiplier for controlling the spawn rate in garages
    GarageSpawnModifier = {type='float', min=0, default=1.0},

    -- HuntingSpawnModifier: Multiplier for controlling the spawn rate in the hunting lodge
    HuntingSpawnModifier = {type='float', min=0, default=1.0},

    -- Full-auto weapons behave as semi-auto if true (no full-auto fire rates, bonuses or penalties).
    -- This does not prevent them from spawning.
    DisableFullAuto = {type='boolean', default=false},


    -- Compatibility Patch Toggles
    -- These determine if the built in compatibility patches should be used. These are only valid
    -- If the mod in question is actually loaded.

    -- UseSilencersPatch: Patch Nolan's ORGM Silencers mod
    -- valid options are true or false (default: true)
    UseSilencersPatch = {type='boolean', default=true},

    -- SilencerPatchEffect: Sound reduction for Nolan's Silencer mod
    SilencerPatchEffect = {type='float', min=0.01, default=0.2},

    -- UseNecroforgePatch: Patch Svarog's NecroForge mod
    -- valid options are true or false (default: true)
    UseNecroforgePatch = {type='boolean', default=true},

    -- UseSurvivorsPatch: Patch Nolan's Survivors mod
    -- valid options are true or false (default: true)
    UseSurvivorsPatch = {type='boolean', default=true},

    ToolTipStyle = {type='integer', min=1, max=4, default=1},

    ----------------------------------
    -- WARNING DEBUG AND ADVANCED Settings. Touch at own risk.
    -- these are hidden from the options screen, and never saved in ORGM.ini but will
    -- be read from the file if the keys/values exist.

    -- HitChance penalty in full auto, recoil delay is applied to this
    FullAutoHitChanceAdjustment = {type='integer', default=-10,},

    -- RecoilDelay is reduced by this much in full auto, after HitChance has been modified
    FullAutoRecoilDelayAdjustment = {type='integer', default=-20, show=false},

    -- recoil is: (ammo recoil+barrel and feed system modifer) / (weapon weight * multiplier).
    -- the higher the multiplier the more weight effects recoil
    -- WARNING: editing this setting can greatly upset the balance of weapons of different weights
    WeightRecoilDelayModifier  = {type='float', min=0.1, default=0.55, show=false},

    -- how weight effects swingtime (lower is faster), swingtime is: BaseSwingTime + (effectiveWgt * WeightSwingTimeModifier)
    -- WARNING: editing this setting can greatly upset the balance of weapons of different weights
    WeightSwingTimeModifier  = {type='float', min=0.1, default=0.2, show=false},

    -- minumum limit for recoil delay, this is also the end recoil delay for full-autos
    RecoilDelayLimit  = {type='integer', min=1, default=1, show=false},

    -- base swingtime applied before weight additions. this is also the swingtime used for full-autos
    BaseSwingTime  = {type='float', min=0.1, default=0.3, show=false},

    -- swingtime limiter, applies to all firearms except those in full-auto mode
    SwingTimeLimit  = {type='float', min=0.1, default=0.5, show=false},

    -- development/debug flag. Note this is not related to debug logging. It is for accessing development, test and debugging
    -- features (context menus and such), as well as MP admin orgm menus in SP mode. Do not enable this on a open server.
    -- All warranties are void of you enable this.
    Debug = {type='boolean', default=false, show=false},
}
for key, data in pairs(ORGM.SettingsValidator) do
    ORGM.Settings[key] = data.default
end


-- ORGM[1] = "676574537"
-- ORGM[2] = "465616\0684"

ORGM.BUILD_ID = #ORGM.BUILD_HISTORY
--- @section end

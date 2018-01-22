--[[

    This file contains the core table of ORGM Rechambered.
    It is kept in the shared/1LoadOrder folder to ensure is loaded before any other ORGM files.
    All functions and tables can be accessed via the global table named ORGM.
    Functions are not listed in this file, they are loaded into it by the other files in the mod.
]]


ORGM = {
    AUTHOR = "Original mod by ORMtnMan, Rechambered by Fenris_Wolf",
    -- this table is used to track build #'s for backwards compatibility. All guns will be stamped with a index
    -- number - the build it was last used in. A table exists changes to firearms (name = buildnumber). If the
    -- gun index number < changed index number then the gun needs to be reset to default values (fixed for the 
    -- new version.)
    BUILD_HISTORY = {
        "2.00-alpha", "2.00-beta-rc1", "2.00-beta-rc2", "2.00-beta-rc3", "2.00-beta-rc4", "2.00-beta-rc5", "2.00-beta-rc6", -- 7
        "2.00-stable", "2.01-stable", "2.02-stable", "2.03-stable", -- 11
        "3.00-alpha", "3.00-beta-rc1", "3.00-beta-rc2", -- 14
    },
    BUILD_ID = nil, -- set automatically at the end of this file

    -- logging constants
    ERROR = 0,
    WARN = 1,
    INFO = 2,
    DEBUG = 3,

    -- trigger type constants
    SINGLEACTION = "SingleAction", -- TODO: replace string with int 1
    DOUBLEACTION = "DoubleAction", -- TODO: replace string with int 2
    DOUBLEACTIONONLY = "DoubleActionOnly", -- TODO: replace string with int 3

    -- action/feed type constants
    AUTO = "Auto", -- TODO: replace string with int 1
    BOLT = "Bolt", -- TODO: replace string with int 2
    LEVER = "Lever", -- TODO: replace string with int 3
    PUMP = "Pump", -- TODO: replace string with int 4
    BREAK = "Break", -- TODO: replace string with int 5
    ROTARY = "Rotary", -- TODO: replace string with int 6

    -- select fire mode constants
    SEMIAUTOMODE = 0,
    FULLAUTOMODE = 1,
    
    -- rarity constants
    COMMON = "Common", -- TODO: replace string with int 1
    RARE = "Rare", -- TODO: replace string with int 2
    VERYRARE = "VeryRare", -- TODO: replace string with int 3
    
    -- Settings table to be overwritten by 'Patch Mods'. See the Patch Mod Examples.zip
    Settings = {
        -- LogLevel: This controls how much text ORGM prints to the console and log file.
        -- valid options are ORGM.ERROR, ORGM.WARN, ORGM.INFO, and ORGM.DEBUG (default ORGM.INFO)
        LogLevel = 2,

        -- JammingEnabled: Turns firearm jamming on or off.
        -- valid options are true or false. (default true)
        JammingEnabled = true,

        -- CasesEnabled: Turns ejecting of empty cases on or off.
        -- valid options are true or false. (default true)
        CasesEnabled = true,

        -- RemoveBaseFirearms:  Stops spawning of the base game firearms.
        -- valid options are true or false (default true)
        RemoveBaseFirearms = true,

        -- DefaultMagazineReoadTime:  The base time it takes to load a round into a magazine 
        -- before modifiers for panic levels and reloading skill are applied. Note specific 
        -- magazines may override this value.
        -- valid options are any integer number greater then 0 (default: 30)
        DefaultMagazineReoadTime = 30,

        -- DefaultReoadTime:  The base time it takes to load a magazine or round into a firearm
        -- before modifiers for panic levels and reloading skill are applied. Note specific 
        -- magazines may override this value.
        -- valid options are any integer number greater then 0 (default: 15)
        DefaultReloadTime = 15,

        -- DefaultRackTime:  The base time it takes to rack a firearm before modifiers for panic 
        -- levels and reloading skill are applied. Note specific magazines may override this value.
        -- valid options are any integer number greater then 0 (default: 10)
        DefaultRackTime = 10,
        
        -- Set this to the year you want to limit firearms spawning to. ie: 1993 will not spawn any
        -- firearms manufactured after 1993, if nil then no year limits will be applied.
        LimitYear = nil,

        ----------------------------------
        -- Spawn Rate Multipliers
        -- These values tweak the various spawn rates, and stack with the sandbox weapon loot rarity 
        -- settings. Setting any of these to 0 will disable spawning of those items completely, while
        -- a value of 1 is normal ORGM spawning.

        -- FirearmSpawnModifier: Multiplier for ALL firearms spawning.
        FirearmSpawnModifier = 1.0,

        -- CivilianFirearmSpawnModifier: Multiplier for the chances a firearm is civilian class.
        CivilianFirearmSpawnModifier = 1.0,
        
        -- PoliceFirearmSpawnModifier: Multiplier for the chances a firearm is police class.
        PoliceFirearmSpawnModifier = 1.0,

        -- MilitaryFirearmSpawnModifier: Multiplier for the chances a firearm is military class.
        MilitaryFirearmSpawnModifier = 1.0,

        -- AmmoSpawnModifier: Multiplier for controlling the spawn rate of ammo, boxes and cans.
        AmmoSpawnModifier = 1.0,
        
        -- MagazineSpawnModifier: Multiplier for controlling the spawn rate of spare magazines
        MagazineSpawnModifier = 1.0,

        -- RepairKitSpawnModifier: Multiplier for controlling the spawn rate of repair kits
        RepairKitSpawnModifier = 1.0,

        -- ComponentSpawnModifier: Multiplier for controlling the spawn rate of weapon upgrades
        -- and parts. Note this only effects upgrades not attached to guns.
        ComponentSpawnModifier = 1.0,
        
        ----------------------------------
        -- Compatibility Patch Toggles
        -- These determine if the built in compatibility patches should be used. These are only valid
        -- If the mod in question is actually loaded.

        -- UseSilencersPatch: Patch Nolan's ORGM Silencers mod
        -- valid options are true or false (default: true)
        UseSilencersPatch = true,

        -- UseNecroforgePatch: Patch Svarog's NecroForge mod
        -- valid options are true or false (default: true)
        UseNecroforgePatch = true,

        -- UseSurvivorsPatch: Patch Nolan's Survivors mod
        -- valid options are true or false (default: true)
        UseSurvivorsPatch = true,
        -- development/debug flag. Note this is not related to debug logging. It is for accessing development, test and debugging
        -- features (context menus and such). Do not enable this on a open server. All warranties are void of you enable this.
        Debug = false, 
    },

    -- table containing all ORGM server-side functions
    -- server functions and subtables are defined in the lua/server folder
    Server = { },
    
    -- table containing all ORGM client-side functions. 
    -- client functions and subtables are defined in the lua/client folder
    Client = { },

    -- Table containing all registered ammo and definitions. formally ORGMMasterAmmoTable (v2.00-v2.03)
    AmmoTable = { },
    
    -- Table containing all dummy round names and real ammo replacements. formally ORGMAlternateAmmoTable (v2.00-v2.03)
    AlternateAmmoTable = { },
    
    -- Table containing all registered firearms and definitions. formally ORGMMasterWeaponTable (v2.00-v2.03)
    FirearmTable = { },
        
    -- Table containing all registered magazines and definitions. formally ORGMMasterMagTable (v2.00-v2.03)
    MagazineTable = { },

    ComponentTable = { },

    RepairKitTable = { },

    FirearmRarityTable = {
        Civilian = { Common = {},Rare = {}, VeryRare = {} },
        Police = { Common = {}, Rare = {}, VeryRare = {} },
        Military = { Common = {}, Rare = {}, VeryRare = {} },
    },
    
    LogLevelStrings = { [0] = "ERROR", [1] = "WARN", [2] = "INFO", [3] = "DEBUG"},

    -- The ActionTypeStrings table contains all valid firearm.actionType values. It is used for error checking in ORGM.registerFirearm
    ActionTypeStrings = {"Auto", "Bolt", "Lever", "Pump", "Break", "Rotary"},

    -- The TriggerTypeStrings table contains all valid firearm.triggerType values. It is used for error checking in ORGM.registerFirearm
    TriggerTypeStrings = {"SingleAction", "DoubleAction", "DoubleActionOnly"},
    
    -- The ORGM.SoundBankQueueTable table contains all sounds we need to setup on the OnLoadSoundBanks event 
    -- so sounds player properly in multiplayer. This table is set to nil after completion.
    SoundBankQueueTable = { },

    -- The SoundBankKeys table contains a a list of firearm keys we need to add to the SoundBankQueueTable.
    SoundBankKeys = {"clickSound", "insertSound", "ejectSound", "rackSound", "openSound", "closeSound", "cockSound"},

    
    
    --[[  ORGM.log
        
        Basic logging function.

    ]]
    log = function(level, text)
        if level > ORGM.Settings.LogLevel then return end
        local prefix = "ORGM." .. ORGM.LogLevelStrings[level] .. ": "
        print(prefix .. text)
    end
}

--[[ The ORGM.SoundProfiles table contains some basic sound profiles for working the action.
    Any key = value pairs here can be overridden by specific weapons, each key is only set in the 
    weapons data table if it doesn't already exist.
    Note: shootSound is not covered in these profiles, as they are specific to each weapon, and not required
]]
ORGM.SoundProfiles = {
    ["Revolver"] = {
        clickSound = 'ORGMRevolverEmpty',
        insertSound = 'ORGMMagLoad',
        ejectSound = nil,
        rackSound = 'ORGMRevolverCock',
        openSound = 'ORGMRevolverOpen',
        closeSound = 'ORGMRevolverClose',
        cockSound = 'ORGMRevolverCock'
    },
    ["Pistol-Small"] = {
        clickSound = 'ORGMSmallPistolEmpty',
        insertSound = 'ORGMSmallPistolIn',
        ejectSound = 'ORGMSmallPistolOut',
        rackSound = 'ORGMSmallPistolRack',
        openSound = nil,
        closeSound = 'ORGMPistolClose',
        cockSound = nil
    },
    ["Pistol-Large"] = {
        clickSound = 'ORGMPistolEmpty',
        insertSound = 'ORGMPistolIn',
        ejectSound = 'ORGMPistolOut',
        rackSound = 'ORGMPistolRack',
        openSound = nil,
        closeSound = 'ORGMPistolClose',
        cockSound = nil
    },
    ["SMG"] = {
        clickSound = 'ORGMSMGEmpty',
        insertSound = 'ORGMSMGIn',
        ejectSound = 'ORGMSMGOut',
        rackSound = 'ORGMSMGRack',
        openSound = nil,
        closeSound = nil,
        cockSound = nil
    },
    ["Rifle-Auto"] = {
        clickSound = 'ORGMRifleEmpty',
        insertSound = 'ORGMRifleIn',
        ejectSound = 'ORGMRifleOut',
        rackSound = 'ORGMRifleRack',
        openSound = nil,
        closeSound = nil,
        cockSound = nil
    },
    ["Rifle-Auto-IM"] = {
        clickSound = 'ORGMRifleEmpty',
        insertSound = 'ORGMMagLoad',
        ejectSound = 'ORGMRifleOut',
        rackSound = 'ORGMRifleRack',
        openSound = nil,
        closeSound = nil,
        cockSound = nil
    },
    ["Rifle-Bolt"] = {
        clickSound = 'ORGMRifleEmpty',
        insertSound = 'ORGMMagLoad',
        ejectSound = 'ORGMRifleOut',
        rackSound = 'ORGMRifleBolt',
        openSound = nil,
        closeSound = nil,
        cockSound = nil
        --bulletOutSound = "ORGMRifleBolt"
    },
    ["Rifle-Bolt-IM"] = {
        clickSound = 'ORGMRifleEmpty',
        insertSound = 'ORGMRifleIn',
        ejectSound = nil,
        rackSound = 'ORGMRifleBolt',
        openSound = nil,
        closeSound = nil,
        cockSound = nil
        --bulletOutSound = "ORGMRifleBolt"
    },
    ["Rifle-Lever"] = {
        clickSound = 'ORGMRifleEmpty',
        insertSound = 'ORGMMagLoad',
        ejectSound = nil,
        rackSound = 'ORGMRifleLever',
        openSound = nil,
        closeSound = nil,
        cockSound = nil
        --bulletOutSound = "ORGMRifleLever"
    },
    ["Rifle-AR"] = {
        clickSound = 'ORGMRifleEmpty',
        insertSound = 'ORGMARIn',
        ejectSound = 'ORGMAROut',
        rackSound = 'ORGMARRack',
        openSound = nil,
        closeSound = nil,
        cockSound = nil
    },
    ["Shotgun"] = { -- Pump, auto, bolt
        clickSound = 'ORGMShotgunEmpty',
        insertSound = 'ORGMShotgunRoundIn',
        ejectSound = nil,
        rackSound = 'ORGMShotgunRack',
        openSound = nil,
        closeSound = nil,
        cockSound = nil
        --bulletOutSound = 'ORGMShotgunRack'
    },
    ["Shotgun-Lever"] = {
        clickSound = 'ORGMShotgunEmpty',
        insertSound = 'ORGMShotgunRoundIn',
        ejectSound = nil,
        rackSound = 'ORGMRifleLever',
        openSound = nil,
        closeSound = nil,
        cockSound = nil
        --bulletOutSound = 'ORGMRifleLever'
    },
    ["Shotgun-Break"] = {
        rackSound = 'ORGMShotgunDBRack',
        clickSound = 'ORGMShotgunEmpty',
        insertSound = 'ORGMShotgunRoundIn',
        ejectSound = nil,
        openSound = 'ORGMShotgunOpen',
        closeSound = nil,
        cockSound = nil
        --bulletOutSound = 'ORGMShotgunOpen'
    }
}

ORGM.BUILD_ID = #ORGM.BUILD_HISTORY
ORGM.log(ORGM.INFO, "ORGM Rechambered Core Loaded v" .. ORGM.BUILD_HISTORY[ORGM.BUILD_ID])
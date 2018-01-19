--[[

    This file contains the core table of ORGM Rechambered.
    It is kept in the shared/1LoadOrder folder to ensure is loaded before any other ORGM files.
    All functions and tables can be accessed via the global table named ORGM.
    Functions are not listed in this file, they are loaded into it by the other files in the mod.
]]


ORGM = {
    VERSION = "3.00-beta-rc1",
    AUTHOR = "Original mod by ORMtnMan, Rechambered by Fenris_Wolf",
    -- this table is used to track build #'s for backwards compatibility. All guns will be stamped with a index
    -- number - the build it was last used in. A table exists changes to firearms (name = buildnumber). If the
    -- gun index number < changed index number then the gun needs to be reset to default values (fixed for the 
    -- new version.)
    BUILD_HISTORY = {
        "2.00-alpha", "2.00-beta-rc1", "2.00-beta-rc2", "2.00-beta-rc3", "2.00-beta-rc4", "2.00-beta-rc5", "2.00-beta-rc6", -- 7
        "2.00-stable", "2.01-stable", "2.02-stable", "2.03-stable", -- 11
        "3.00-alpha", "2.00-beta-rc1", -- 13
    },
    BUILD_ID = nil, -- set automatically at the end of this file
    -- constants
    -- logging
    ERROR = 0,
    WARN = 1,
    INFO = 2,
    DEBUG = 3,
    -- trigger types
    SINGLEACTION = 1,
    DOUBLEACTION = 2,
    DOUBLEACTIONONLY = 3,
    -- action/feed types
    AUTO = 1,
    BOLT = 2,
    LEVER = 3,
    PUMP = 4,
    BREAK = 5,
    ROTARY = 6,
    -- select fire modes
    SEMIAUTOMODE = 0,
    FULLAUTOMODE = 1,
    
    -- tables
    Settings = { -- Settings table to be overwritten
        LogLevel = 2,
        JammingEnabled = true,
        CasesEnabled = true,
        RemoveBaseFirearms = true,
        DefaultMagazineReoadTime = 5,
        -- spawn modifiers
        LimitYear = nil, -- set to the max production year (ie: 1993, no guns produced after 1993 will spawn)
        FirearmSpawnModifier = 1.0,
        CivilianFirearmSpawnModifier = 1.0,
        PoliceFirearmSpawnModifier = 1.0,
        MilitaryFirearmSpawnModifier = 1.0,
        AmmoSpawnModifier = 1.0,
        MagazineSpawnModifier = 1.0,
        RepairKitSpawnModifier = 1.0,
        ComponentSpawnModifier = 1.0,
        
        UseSilencersPatch = true,
        UseNecroforgePatch = true,
        UseSurvivorsPatch = true,
        Debug = false, -- development/debug flag. Note this is not related to debug logging
    },

    Server = { -- table containing all ORGM server-side functions
        -- server functions and subtables are defined in the lua/server folder
    },
    Client = {  -- table containing all ORGM client-side functions. 
        -- client functions and subtables are defined in the lua/client folder
    },

    AmmoTable = { }, -- formally ORGMMasterAmmoTable
    AlternateAmmoTable = { }, --formally ORGMAlternateAmmoTable
    FirearmTable = { }, -- formally ORGMMasterWeaponTable
    MagazineTable = { }, -- formally ORGMMasterMagTable
    ComponentTable = { },
    RepairKitTable = { },

    FirearmRarityTable = {
        Civilian = { Common = {},Rare = {}, VeryRare = {} },
        Police = { Common = {}, Rare = {}, VeryRare = {} },
        Military = { Common = {}, Rare = {}, VeryRare = {} },
    },
    
    LogLevelStrings = { [0] = "ERROR", [1] = "WARN", [2] = "INFO", [3] = "DEBUG"},
    -- The ActionTypes table contains all valid firearm.actionType values. It is used for error checking in ORGM.registerFirearm
    ActionTypes = {"Auto", "Bolt", "Lever", "Pump", "Break", "Rotary"},

    -- The TriggerTypes table contains all valid firearm.triggerType values. It is used for error checking in ORGM.registerFirearm
    TriggerTypes = {"SingleAction", "DoubleAction", "DoubleActionOnly"},
    
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

--[[ The SoundProfiles table contains some basic sound profiles for working the action.
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
ORGM.log(ORGM.INFO, "ORGM Rechambered Core Loaded v" .. ORGM.VERSION)
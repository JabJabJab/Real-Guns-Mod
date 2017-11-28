--[[
    This file contains all weapon and magazine data passed into ReloadUtil:addMagazineType()
    and ReloadUtil:addWeaponType().  It has been redesigned to limit the amount of repeated data
    to make it more manageable and less prone to errors (typos).
    
    At the bottom of this file is a pair of for loops that set defaults and finalize the magazine
    and gun setups.
]]

--[[ The GunTypes table lists all the various types, by actionType and triggerType.
    Any key = value pairs here can be overridden by specific weapons, each key is only set in the 
    weapons data table if it doesn't already exist.
    
    valid actionTypes are: Rotary, Auto, Bolt, Lever, Pump, and Break
    valid triggerTypes are: SingleAction, DoubleAction and DoubleActionOnly
    Note: the 3 trigger types do NOT realistically account for all trigger/hammer/firing pin types,
    but are sufficient enough code wise. For effective purposes, they are handled as such:
    
    SingleAction - Requires a cocking motion (manual or automatic) before striking a chambered round.
        Can be cocked and safely released manually.
        
    DoubleAction - Can be fired from a uncocked position, but can be cocked and safely released manually.
    
    DoubleActionOnly - No manual cocking or releasing allowed.

]]
local GunTypes = {
    ["Rotary-SA"] =     { triggerType = "SingleAction",     actionType = "Rotary" },
    ["Rotary-DA"] =     { triggerType = "DoubleAction",     actionType = "Rotary" },
    ["Rotary-DAO"] =    { triggerType = "DoubleActionOnly", actionType = "Rotary" },
    ["Auto-SA"] =       { triggerType = "SingleAction",     actionType = "Auto" },
    ["Auto-DA"] =       { triggerType = "DoubleAction",     actionType = "Auto" },
    ["Auto-DAO"] =      { triggerType = "DoubleActionOnly", actionType = "Auto" },
    ["Bolt-SA"] =       { triggerType = "SingleAction",     actionType = "Bolt" },
    ["Bolt-DA"] =       { triggerType = "DoubleAction",     actionType = "Bolt" },
    ["Bolt-DAO"] =      { triggerType = "DoubleActionOnly", actionType = "Bolt", },
    ["Lever-SA"] =      { triggerType = "SingleAction",     actionType = "Lever", },
    ["Lever-DA"] =      { triggerType = "DoubleAction",     actionType = "Lever" },
    ["Lever-DAO"] =     { triggerType = "DoubleActionOnly", actionType = "Lever" },
    ["Pump-SA"] =       { triggerType = "SingleAction",     actionType = "Pump" },
    ["Pump-DA"] =       { triggerType = "DoubleAction",     actionType = "Pump" },
    ["Pump-DAO"] =      { triggerType = "DoubleActionOnly", actionType = "Pump" },
    ["Break-SA"] =      { triggerType = "SingleAction",     actionType = "Break" },
    ["Break-DA"] =      { triggerType = "DoubleAction",     actionType = "Break" },
    ["Break-DAO"] =     { triggerType = "DoubleActionOnly", actionType = "Break" },
}


--[[ The SoundProfiles table contains some basic sound profiles for working the action.
    Any key = value pairs here can be overridden by specific weapons, each key is only set in the 
    weapons data table if it doesn't already exist.
    Note: shootSound is not covered in these profiles, as they are specific to each weapon.
    It doesnt look like its needed anyways
]]
local SoundProfiles = {
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


--[[ The SoundBanksSetupTable table contains sounds we have to setup OnLoadSoundBanks event.
    It is automatically filled out after all guns are setup
]]
local SoundBanksSetupTable = { }


--[[ The Alternate Ammo Table (Global)
    This table defines what ammo can be used as replacements for the generic dummy ammo. When 
    searching the player inventory to find ammo to load into the gun/magazine, it will search 
    these rounds in order.
]]
ORGMAlternateAmmoTable = {
    ["Ammo_117BB"]      = {"Ammo_117BB"},
    ["Ammo_22LR"]       = {"Ammo_22LR_FMJ", "Ammo_22LR_HP"},
    ["Ammo_32ACP"]      = {"Ammo_32ACP_FMJ", "Ammo_32ACP_HP"},
    ["Ammo_357Magnum"]  = {"Ammo_357Magnum_FMJ", "Ammo_357Magnum_HP", "Ammo_38Special_FMJ", "Ammo_38Special_HP"},
    ["Ammo_38Special"]  = {"Ammo_38Special_FMJ", "Ammo_38Special_HP"},
    ["Ammo_38Super"]    = {"Ammo_38Super_FMJ", "Ammo_38Super_HP"},
    ["Ammo_380ACP"]     = {"Ammo_380ACP_FMJ", "Ammo_380ACP_HP"},
    ["Ammo_40SW"]       = {"Ammo_40SW_FMJ", "Ammo_40SW_HP"},
    ["Ammo_44Magnum"]   = {"Ammo_44Magnum_FMJ", "Ammo_44Magnum_HP"},
    ["Ammo_45ACP"]      = {"Ammo_45ACP_FMJ", "Ammo_45ACP_HP"},
    ["Ammo_45Colt"]     = {"Ammo_45Colt_FMJ", "Ammo_45Colt_HP"},
    ["Ammo_454Casull"]  = {"Ammo_454Casull_FMJ", "Ammo_454Casull_HP", "Ammo_45Colt_FMJ", "Ammo_45Colt_HP"},
    ["Ammo_50AE"]       = {"Ammo_50AE_FMJ", "Ammo_50AE_HP"},
    ["Ammo_223Remington"] = {"Ammo_223Remington_FMJ", "Ammo_223Remington_HP", "Ammo_556x45mm_FMJ", "Ammo_556x45mm_HP"},
    ["Ammo_3006Springfield"] = {"Ammo_3006Springfield_FMJ", "Ammo_3006Springfield_HP"},
    ["Ammo_3030Winchester"] = {"Ammo_3030Winchester_FMJ", "Ammo_3030Winchester_HP"},
    ["Ammo_308Winchester"] = {"Ammo_308Winchester_FMJ", "Ammo_308Winchester_HP", "Ammo_762x51mm_FMJ", "Ammo_762x51mm_HP"},
    ["Ammo_57x28mm"]    = {"Ammo_57x28mm_FMJ", "Ammo_57x28mm_HP"},
    ["Ammo_9x19mm"]     = {"Ammo_9x19mm_FMJ", "Ammo_9x19mm_HP"},
    ["Ammo_10x25mm"]    = {"Ammo_10x25mm_FMJ", "Ammo_10x25mm_HP"},
    ["Ammo_556x45mm"]   = {"Ammo_556x45mm_FMJ", "Ammo_556x45mm_HP", "Ammo_223Remington_FMJ", "Ammo_223Remington_HP"},
    ["Ammo_762x39mm"]   = {"Ammo_762x39mm_FMJ", "Ammo_762x39mm_HP"},
    ["Ammo_762x51mm"]   = {"Ammo_762x51mm_FMJ", "Ammo_762x51mm_HP", "Ammo_308Winchester_FMJ", "Ammo_308Winchester_HP"},
    ["Ammo_762x54mm"]   = {"Ammo_762x54mm_FMJ", "Ammo_762x54mm_HP"},
    ["Ammo_12g"]        = {"Ammo_12g_00Buck", "Ammo_12g_Slug"},
}


--[[
    TODO: fill out this table.
]]
ORGMAlternateMagTable = {  }


--[[ The Ammo Stats Table (Global)
    This is used for guns to change attributes based on ammo.  If a round is different from the last round 
    loaded, it changes several of the weapon properties to match the new ammo.
    Supported table keys:
    MinDamage, MaxDamage, CriticalChance, DoorDamage, HitChance,
    PiercingBullets (true/false or 0-100% chance ), MaxHitCount (for shotgun ammo)
]]
ORGMMasterAmmoTable = {
    ["Ammo_117BB"]              = { MinDamage = 0.1, MaxDamage = 0.1, PiercingBullets = false },
    ["Ammo_22LR_FMJ"]           = { MinDamage = 0.4, MaxDamage = 0.8, PiercingBullets = 10 },
    ["Ammo_22LR_HP"]            = { MinDamage = 0.5, MaxDamage = 0.9, PiercingBullets = 2 },
    ["Ammo_32ACP_FMJ"]          = { MinDamage = 0.7, MaxDamage = 1.3, PiercingBullets = 15 },
    ["Ammo_32ACP_HP"]           = { MinDamage = 0.9, MaxDamage = 1.3, PiercingBullets = 3 },
    ["Ammo_357Magnum_FMJ"]      = { MinDamage = 0.9, MaxDamage = 1.9, PiercingBullets = 50 },
    ["Ammo_357Magnum_HP"]       = { MinDamage = 1.2, MaxDamage = 1.9, PiercingBullets = 10 },
    ["Ammo_38Special_FMJ"]      = { MinDamage = 0.7, MaxDamage = 1.6, PiercingBullets = 30 },
    ["Ammo_38Special_HP"]       = { MinDamage = 1.0, MaxDamage = 1.6, PiercingBullets = 8 },
    ["Ammo_38Super_FMJ"]        = { MinDamage = 0.7, MaxDamage = 1.7, PiercingBullets = 30 },
    ["Ammo_38Super_HP"]         = { MinDamage = 1.0, MaxDamage = 1.7, PiercingBullets = 8 },
    ["Ammo_380ACP_FMJ"]         = { MinDamage = 0.7, MaxDamage = 1.5, PiercingBullets = 25 },
    ["Ammo_380ACP_HP"]          = { MinDamage = 1.0, MaxDamage = 1.5, PiercingBullets = 7 },
    ["Ammo_40SW_FMJ"]           = { MinDamage = 0.8, MaxDamage = 1.7, PiercingBullets = 50 },
    ["Ammo_40SW_HP"]            = { MinDamage = 1.1, MaxDamage = 1.7, PiercingBullets = 10 },
    ["Ammo_44Magnum_FMJ"]       = { MinDamage = 1.2, MaxDamage = 2.2, PiercingBullets = 65 },
    ["Ammo_44Magnum_HP"]        = { MinDamage = 1.6, MaxDamage = 2.2, PiercingBullets = 13 },
    ["Ammo_45ACP_FMJ"]          = { MinDamage = 1.0, MaxDamage = 1.8, PiercingBullets = 50 },
    ["Ammo_45ACP_HP"]           = { MinDamage = 1.3, MaxDamage = 1.8, PiercingBullets = 10 },
    ["Ammo_45Colt_FMJ"]         = { MinDamage = 1.1, MaxDamage = 2.1, PiercingBullets = 60 },
    ["Ammo_45Colt_HP"]          = { MinDamage = 1.5, MaxDamage = 2.1, PiercingBullets = 12 },
    ["Ammo_454Casull_FMJ"]      = { MinDamage = 1.3, MaxDamage = 2.3, PiercingBullets = 67 },
    ["Ammo_454Casull_HP"]       = { MinDamage = 1.7, MaxDamage = 2.3, PiercingBullets = 14 },
    ["Ammo_50AE_FMJ"]           = { MinDamage = 1.3, MaxDamage = 2.3, PiercingBullets = 67 },
    ["Ammo_50AE_HP"]            = { MinDamage = 1.7, MaxDamage = 2.3, PiercingBullets = 14 },
    ["Ammo_223Remington_FMJ"]   = { MinDamage = 1.4, MaxDamage = 2.4, PiercingBullets = 75 },
    ["Ammo_223Remington_HP"]    = { MinDamage = 1.8, MaxDamage = 2.4, PiercingBullets = 15 },
    ["Ammo_3006Springfield_FMJ"] = { MinDamage = 1.4, MaxDamage = 2.4, PiercingBullets = 75 },
    ["Ammo_3006Springfield_HP"] = { MinDamage = 1.7, MaxDamage = 2.4, PiercingBullets = 15 },
    ["Ammo_3030Winchester_FMJ"] = { MinDamage = 0.8, MaxDamage = 1.6, PiercingBullets = 30 },
    ["Ammo_3030Winchester_HP"]  = { MinDamage = 1.0, MaxDamage = 1.6, PiercingBullets = 8 },
    ["Ammo_308Winchester_FMJ"]  = { MinDamage = 1.4, MaxDamage = 2.6, PiercingBullets = 80 },
    ["Ammo_308Winchester_HP"]   = { MinDamage = 1.8, MaxDamage = 2.6, PiercingBullets = 20 },
    ["Ammo_57x28mm_FMJ"]        = { MinDamage = 0.7, MaxDamage = 1.6, PiercingBullets = 90 },
    ["Ammo_57x28mm_HP"]         = { MinDamage = 1.0, MaxDamage = 1.6, PiercingBullets = 40 },
    ["Ammo_9x19mm_FMJ"]         = { MinDamage = 0.7, MaxDamage = 1.6, PiercingBullets = 50 },
    ["Ammo_9x19mm_HP"]          = { MinDamage = 1.0, MaxDamage = 1.6, PiercingBullets = 10 },
    ["Ammo_10x25mm_FMJ"]        = { MinDamage = 0.9, MaxDamage = 1.9, PiercingBullets = 55 },
    ["Ammo_10x25mm_HP"]         = { MinDamage = 1.2, MaxDamage = 1.9, PiercingBullets = 12 },
    ["Ammo_556x45mm_FMJ"]       = { MinDamage = 1.4, MaxDamage = 2.4, PiercingBullets = 75 },
    ["Ammo_556x45mm_HP"]        = { MinDamage = 1.8, MaxDamage = 2.4, PiercingBullets = 15 },
    ["Ammo_762x39mm_FMJ"]       = { MinDamage = 1.2, MaxDamage = 2.2, PiercingBullets = 65 },
    ["Ammo_762x39mm_HP"]        = { MinDamage = 1.6, MaxDamage = 2.2, PiercingBullets = 13 },
    ["Ammo_762x51mm_FMJ"]       = { MinDamage = 1.4, MaxDamage = 2.6, PiercingBullets = 80 },
    ["Ammo_762x51mm_HP"]        = { MinDamage = 1.8, MaxDamage = 2.6, PiercingBullets = 20 },
    ["Ammo_762x54mm_FMJ"]       = { MinDamage = 1.6, MaxDamage = 2.8, PiercingBullets = 80 },
    ["Ammo_762x54mm_HP"]        = { MinDamage = 2.0, MaxDamage = 2.8, PiercingBullets = 20 },
    ["Ammo_12g_00Buck"]         = { MinDamage = 1.0, MaxDamage = 2.2, MaxHitCount = 4, PiercingBullets = false,  },
    ["Ammo_12g_Slug"]           = { MinDamage = 2.0, MaxDamage = 2.8, MaxHitCount = 1, PiercingBullets = 95, }
}


--[[ ORGMWeaponModsTable (Global)
    A list of weapon repair kits in ORGM, this is used for distribution tables, and so other mods can
    list possible upgrades without having to hardcode the list
]]
ORGMRepairKitsTable = { "WD40", "Brushkit", "Maintkit" }


--[[ ORGMWeaponModsTable (Global)
    A list of standard weapon mods in ORGM, this is used for distribution tables, and so other mods can
    list possible upgrades without having to hardcode the list
]]
ORGMWeaponModsTable = {
    '2xScope', 
    '4xScope', 
    '8xScope', 
    'FibSig', 
    'Foregrip', 
    'FullCh', 
    'HalfCh', 
    'PistolLas', 
    'PistolTL', 
    'RDS', 
    'Recoil', 
    'Reflex', 
    'RifleLas', 
    'RifleTL', 
    'Rifsling', 
    'SkeletalStock', 
    'CollapsingStock'
}


--[[ The Master Magazine Table (global)
    This table contains all magazine data (ammoType, maxCapacity, etc), it lists clipIcon and clipName 
    originally listed in each weapon's table (since multiple guns often use the same mag, it makes sense to
    just move those keys to the magazine instead).

    MagName = {
        name = "", -- clipName used by any weapon that uses this mag, AUTO GENERATED FROM THE MATCHING SCRIPT ITEM
        icon = "", -- clipIcon used by any weapon that uses this mag, AUTO GENERATED FROM THE MATCHING SCRIPT ITEM
        data = { -- table passed to ReloadUtil:addMagazineType()
            -- any key = value pair that doesn't exist here (but should) is set to a default
            ammoType = "",
            maxCapacity = ""
        },
    }
]]
ORGMMasterMagTable = {
    ["AIAW308Mag"] =        { data = { ammoType = 'Ammo_308Winchester',     maxCapacity = 5,    }, },
    ["AKMMag"] =            { data = { ammoType = 'Ammo_762x39mm',          maxCapacity = 30,   }, },
    ["AM180Mag"] =          { data = { ammoType = 'Ammo_22LR',              maxCapacity = 177,  }, },
    ["AR10Mag"] =           { data = { ammoType = 'Ammo_762x51mm',          maxCapacity = 20,   }, },
    ["AutomagVMag"] =       { data = { ammoType = 'Ammo_50AE',              maxCapacity = 5,    }, },
    ["BBPistolMag"] =       { data = { ammoType = 'Ammo_117BB',             maxCapacity = 35,   reloadTime = 5, }, },
    ["Ber92Mag"] =          { data = { ammoType = 'Ammo_9x19mm',            maxCapacity = 15,   }, },
    ["Ber93RMag"] =         { data = { ammoType = 'Ammo_9x19mm',            maxCapacity = 32,   }, },
    ["BrenTenMag"] =        { data = { ammoType = 'Ammo_10x25mm',           maxCapacity = 12,   }, },
    ["BrownHPMag"] =        { data = { ammoType = 'Ammo_9x19mm',            maxCapacity = 13,   }, },
    ["Colt38SMag"] =        { data = { ammoType = 'Ammo_38Super',           maxCapacity = 9,    }, },
    ["ColtDeltaMag"] =      { data = { ammoType = 'Ammo_10x25mm',           maxCapacity = 8,    }, },
    ["CZ75Mag"] =           { data = { ammoType = 'Ammo_40SW',              maxCapacity = 10,   }, },
    ["DEagleMag"] =         { data = { ammoType = 'Ammo_44Magnum',          maxCapacity = 8,    }, },
    ["DEagleXIXMag"] =      { data = { ammoType = 'Ammo_50AE',              maxCapacity = 7,    }, },
    ["FN57Mag"] =           { data = { ammoType = 'Ammo_57x28mm',           maxCapacity = 20,   }, },
    ["FNFALAMag"] =         { data = { ammoType = 'Ammo_762x51mm',          maxCapacity = 20,   }, },
    ["FNFALMag"] =          { data = { ammoType = 'Ammo_308Winchester',     maxCapacity = 20,   }, },
    ["FNP90Mag"] =          { data = { ammoType = 'Ammo_57x28mm',           maxCapacity = 50,   }, },
    ["GarandClip"] =        { data = { ammoType = 'Ammo_3006Springfield',   maxCapacity = 8,    }, },
    ["Glock17Mag"] =        { data = { ammoType = 'Ammo_9x19mm',            maxCapacity = 17,   }, },
    ["Glock20Mag"] =        { data = { ammoType = 'Ammo_10x25mm',           maxCapacity = 15,   }, },
    ["Glock21Mag"] =        { data = { ammoType = 'Ammo_45ACP',             maxCapacity = 13,   }, },
    ["Glock22Mag"] =        { data = { ammoType = 'Ammo_40SW',              maxCapacity = 10,   }, },
    ["HK91Mag"] =           { data = { ammoType = 'Ammo_308Winchester',     maxCapacity = 20,   }, },
    ["HKG3Mag"] =           { data = { ammoType = 'Ammo_762x51mm',          maxCapacity = 20,   }, },
    ["HKMK23Mag"] =         { data = { ammoType = 'Ammo_45ACP',             maxCapacity = 12,   }, },
    ["HKMP5Mag"] =          { data = { ammoType = 'Ammo_9x19mm',            maxCapacity = 30,   }, },
    ["HKSL8Mag"] =          { data = { ammoType = 'Ammo_223Remington',      maxCapacity = 20,   }, },
    ["HKUMPMag"] =          { data = { ammoType = 'Ammo_45ACP',             maxCapacity = 25,   }, },
    ["KahrCT40Mag"] =       { data = { ammoType = 'Ammo_40SW',              maxCapacity = 7,    }, },
    ["KahrP380Mag"] =       { data = { ammoType = 'Ammo_380ACP',            maxCapacity = 6,    }, },
    ["KTP32Mag"] =          { data = { ammoType = 'Ammo_32ACP',             maxCapacity = 7,    }, },
    ["L96Mag"] =            { data = { ammoType = 'Ammo_762x51mm',          maxCapacity = 5,    }, },
    ["LENo4Mag"] =          { data = { ammoType = 'Ammo_762x51mm',          maxCapacity = 10,   }, },
    ["LENo4StripperClip"] = { data = { ammoType = 'Ammo_762x51mm',          maxCapacity = 5,    }, },
    ["M1216Mag"] =          { data = { ammoType = 'Ammo_12g',               maxCapacity = 16,   reloadTime = 15, ejectSound = 'ORGMShotgunRoundIn', insertSound = 'ORGMShotgunRoundIn', }, },
    ["M1903StripperClip"] = { data = { ammoType = 'Ammo_3006Springfield',   maxCapacity = 5,    reloadTime = 15, }, },
    ["M1911Mag"] =          { data = { ammoType = 'Ammo_45ACP',             maxCapacity = 7,    }, },
    ["M1A1Mag"] =           { data = { ammoType = 'Ammo_45ACP',             maxCapacity = 30,   }, },
    ["M21Mag"] =            { data = { ammoType = 'Ammo_762x51mm',          maxCapacity = 20,   }, },
    ["M249Belt"] =          { data = { ammoType = 'Ammo_556x45mm',          maxCapacity = 200,  }, },
    ["Mac10Mag"] =          { data = { ammoType = 'Ammo_45ACP',             maxCapacity = 30,   }, },
    ["Mac11Mag"] =          { data = { ammoType = 'Ammo_380ACP',            maxCapacity = 32,   }, },
    ["Mini14Mag"] =         { data = { ammoType = 'Ammo_223Remington',      maxCapacity = 20,   }, },
    ["MosinStripperClip"] = { data = { ammoType = 'Ammo_762x54mm',          maxCapacity = 5,    reloadTime = 15, }, },
    ["R25Mag"] =            { data = { ammoType = 'Ammo_308Winchester',     maxCapacity = 10,   }, },
    ["Rem788Mag"] =         { data = { ammoType = 'Ammo_3030Winchester',    maxCapacity = 3,    }, },
    ["Rug1022Mag"] =        { data = { ammoType = 'Ammo_22LR',              maxCapacity = 25,   }, },
    ["RugerMKIIMag"] =      { data = { ammoType = 'Ammo_22LR',              maxCapacity = 10,   }, },
    ["RugerSR9Mag"] =       { data = { ammoType = 'Ammo_9x19mm',            maxCapacity = 17,   }, },
    ["SIG550Mag"] =         { data = { ammoType = 'Ammo_556x45mm',          maxCapacity = 30,   }, },
    ["SIGP226Mag"] =        { data = { ammoType = 'Ammo_40SW',              maxCapacity = 12,   }, },
    ["SkorpionMag"] =       { data = { ammoType = 'Ammo_32ACP',             maxCapacity = 20,   }, },
    ["SKSStripperClip"] =   { data = { ammoType = 'Ammo_762x39mm',          maxCapacity = 10,   reloadTime = 15, }, },
    ["SpeedLoader10mm6"] =  { data = { ammoType = 'Ammo_10x25mm',           maxCapacity = 6,    reloadTime = 15, }, },
    ["SpeedLoader3576"] =   { data = { ammoType = 'Ammo_357Magnum',         maxCapacity = 6,    reloadTime = 15, }, },
    ["SpeedLoader385"] =    { data = { ammoType = 'Ammo_38Special',         maxCapacity = 5,    reloadTime = 15, }, },
    ["SpeedLoader386"] =    { data = { ammoType = 'Ammo_38Special',         maxCapacity = 6,    reloadTime = 15, }, },
    ["SpeedLoader446"] =    { data = { ammoType = 'Ammo_44Magnum',          maxCapacity = 6,    reloadTime = 15, }, },
    ["SpeedLoader4546"] =   { data = { ammoType = 'Ammo_454Casull',         maxCapacity = 6,    reloadTime = 15, }, },
    ["SpeedLoader456"] =    { data = { ammoType = 'Ammo_45ACP',             maxCapacity = 6,    reloadTime = 15, }, },
    ["SpeedLoader45C6"] =   { data = { ammoType = 'Ammo_45Colt',            maxCapacity = 6,    reloadTime = 15, }, },
    ["Spr19119Mag"] =       { data = { ammoType = 'Ammo_9x19mm',            maxCapacity = 9,    }, },
    ["SR25Mag"] =           { data = { ammoType = 'Ammo_762x51mm',          maxCapacity = 20,   }, },
    ["STANAGMag"] =         { data = { ammoType = 'Ammo_556x45mm',          maxCapacity = 30,   }, },
    ["SVDMag"] =            { data = { ammoType = 'Ammo_762x54mm',          maxCapacity = 10,   }, },
    ["Taurus38Mag"] =       { data = { ammoType = 'Ammo_38Super',           maxCapacity = 10,   }, },
    ["TaurusP132Mag"] =     { data = { ammoType = 'Ammo_32ACP',             maxCapacity = 10,   }, },
    ["UziMag"] =            { data = { ammoType = 'Ammo_9x19mm',            maxCapacity = 32,   }, },
    ["VEPR12Mag"] =         { data = { ammoType = 'Ammo_12g',               maxCapacity = 8,    reloadTime = 15, ejectSound = 'ORGMShotgunRoundIn', insertSound = 'ORGMShotgunRoundIn', }, },
    ["WaltherP22Mag"] =     { data = { ammoType = 'Ammo_22LR',              maxCapacity = 10,   }, },
    ["WaltherPPKMag"] =     { data = { ammoType = 'Ammo_380ACP',            maxCapacity = 6,    }, },
    ["XD40Mag"] =           { data = { ammoType = 'Ammo_40SW',              maxCapacity = 9,    }, },
}


--[[ ORGMWeaponRarityTable (global)

    A list of all guns, sorted into civilian, police and military, and rarity.
    This table is automatically built on startup from ORGMMasterWeaponTable
    
]]
ORGMWeaponRarityTable = {
    Civilian = { Common = {},Rare = {}, VeryRare = {} },
    Police = { Common = {}, Rare = {}, VeryRare = {} },
    Military = { Common = {}, Rare = {}, VeryRare = {} },
}


--[[ The Master Weapon Table (global)
    This table contains all weapon data
    
    WeaponName = {
        gunType = "", -- the action and trigger type (see the GunTypes table above)
        soundProfile = "", -- the sound profile to apply (see the SoundProfiles table above)
        isCivilian/isPolice/isMilitary = nil|"Common|Rare|VeryRare", -- used to define what distribution tables to insert into
        selectFire = nil|0|1, -- used on weapons that can select fire modes (leave nil if not select fire)
                    -- if 1 the default fire mode is full-auto, 0 default mode is semi
        altActionType = "", -- alternate action type for guns that can switch (ie: semi-auto shotguns that can also be pump action)
        data = { -- OPTIONAL table passed to ReloadUtil:addWeaponType()
            -- created automatically if it doesn't exist
            -- any key = value pair that doesn't exist here (but should) is set to a default
            -- or inherited from the GunTypes and SoundProfiles tables
            ammoType = "", -- AUTO GENERATED FROM SCRIPT ITEM
            speedLoader = "", -- optional, name of the speedloader/stripperclip used with this gun.
                    -- previously speedloaders were listed in the ammoType variable, but since use of
                    -- loaders or strippers is never actually required to load a gun, they have been
                    -- given a new variable.
        },
    }
]]
ORGMMasterWeaponTable = {
    ["ColtAnac"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = { speedLoader = 'SpeedLoader446', },
    },
    ["ColtPyth"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = { speedLoader = 'SpeedLoader3576', },
    },
    ["ColtSAA"] = {
        gunType = "Rotary-SA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
    },
    ["RugAlas"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = {speedLoader = 'SpeedLoader4546', },
    },
    ["RugBH"] = {
        gunType = "Rotary-SA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
    },
    ["RugGP100"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = { speedLoader = 'SpeedLoader3576', },
    },
    ["RugRH"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = { speedLoader = 'SpeedLoader446', },
    },
    ["RugSec6"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = { speedLoader = 'SpeedLoader386', },
    },
    ["SWM10"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = { speedLoader = 'SpeedLoader386', },
    },
    ["SWM19"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = { speedLoader = 'SpeedLoader3576', },
    },
    ["SWM252"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = { speedLoader = 'SpeedLoader456', },
    },
    ["SWM29"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = { speedLoader = 'SpeedLoader446', },
    },
    ["SWM36"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = { speedLoader = 'SpeedLoader385', },
    },
    ["SWM610"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = { speedLoader = 'SpeedLoader10mm6', },
    },
    ["Taurus454"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = { speedLoader = 'SpeedLoader4546', },
    },
        --************************************************************************--
        -- semi pistols
        --************************************************************************--
    ["AutomagV"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Large",
        isCivilian = "Rare",
    },
    ["BBPistol"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["Ber92"] = {
        gunType = "Auto-DA", -- this can be DAO, depending on model
        soundProfile = "Pistol-Small",
        isCivilian = "Common", 
        isPolice = "Common", 
        isMilitary = "Common",
    },
    ["BrenTen"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
    },
    ["BrownHP"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["Colt38S"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
    },
    ["ColtDelta"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
    },
    ["CZ75"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
    },
    ["DEagle"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Large",
        isCivilian = "Rare",
    },
    ["DEagleXIX"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Large",
        isCivilian = "Rare",
    },
    ["FN57"] = {
        gunType = "Auto-DAO", -- depending on model, this can be SA (FN57 Tactical)
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
        isPolice = "Rare",
        isMilitary = "Rare",
    },
    ["Glock17"] = {
        gunType = "Auto-DAO", -- this is technically not quite true, but as close as its going to get
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["Glock20"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["Glock21"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["Glock22"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["HKMK23"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
    },
    ["KahrCT40"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["KahrP380"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["KTP32"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["M1911"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common", 
        isMilitary = "Common",
    },
    ["RugerMKII"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["RugerSR9"] = {
        gunType = "Auto-DAO", -- like the glock, this isnt really a DAO
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["SIGP226"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common", 
        isMilitary = "Rare",
    },
    ["Spr19119"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["Taurus38"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
    },
    ["TaurusP132"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["WaltherP22"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["WaltherPPK"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["XD40"] = {
        gunType = "Auto-DAO", -- striker trigger mechanism, DAO is close enough
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
        --************************************************************************--
        -- smg/machine pistols
        --************************************************************************--

    ["AM180"] = {
        gunType = "Auto-DAO", -- again, not really, its closer to SA, but doesnt allow for manual decocking
        soundProfile = "SMG",
        isCivilian = "VeryRare",
        data = { ejectSound = 'ORGMSMG2Out',  insertSound = 'ORGMSMG2In', },
    },
    ["Ber93R"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        selectFire = 1,
        isCivilian = "VeryRare",
    },
    ["FNP90"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        selectFire = 1,
        isPolice = "Rare", 
        isMilitary = "Rare",
    },
    ["Glock18"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        selectFire = 1,
        isCivilian = "VeryRare",
    },
    -- TODO: fix all gun triggerTypes to proper values below here
    ["HKMP5"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        selectFire = 1,
        isPolice = "Rare", 
        isMilitary = "Common",
    },
    ["HKUMP"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        selectFire = 1,
        isPolice = "Rare", 
        isMilitary = "Common",
    },
    ["Kriss"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        isCivilian = "Rare",
    },
    ["KrissA"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        selectFire = 1,
        isCivilian = "VeryRare",
    },
    ["KTPLR"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
    },
    ["M1A1"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        isCivilian = "Rare",
    },
    ["Mac10"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        isCivilian = "Rare",
    },
    ["Mac11"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        isCivilian = "Rare",
    },
    ["Skorpion"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "VeryRare",
    },
    ["Uzi"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        isCivilian = "Rare",
    },
        --************************************************************************--
        -- rifles
        --************************************************************************--
    ["AIAW308"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt",
        isCivilian = "Rare", 
        isPolice = "Rare", 
        isMilitary = "Rare",
    },
    ["AKM"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
    },
    ["AKMA"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1,
        isCivilian = "VeryRare",
    },
    ["AR10"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isPolice = 'Rare',
        selectFire = 1,
    },
    ["AR15"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Common",
    },
    ["BBGun"] = {
        gunType = "Lever-DAO",
        soundProfile = "Rifle-Lever",
        isCivilian = "Common",
        data = {
            rackSound = 'ORGMBBLever',
            clickSound = 'ORGMPistolEmpty',
            insertSound = 'ORGMMagBBLoad',
            rackTime = 3,
        },
    },
    ["BLR"] = {
        gunType = "Lever-DAO",
        soundProfile = "Rifle-Lever",
        isCivilian = "Common",
    },
    ["FNFAL"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
    },
    ["FNFALA"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1,
        isCivilian = "VeryRare",
    },
    ["Garand"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto",
        isCivilian = "Common",
    },
    ["HenryBB"] = {
        gunType = "Lever-DAO",
        soundProfile = "Rifle-Lever",
        isCivilian = "Rare",
    },
    ["HK91"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
    },
    ["HKG3"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1,
        isCivilian = "VeryRare",
    },
    ["HKSL8"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
    },
    ["L96"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt",
        isCivilian = "Common",
    },
    ["LENo4"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt",
        isCivilian = "Rare",
        data = { speedLoader = "LENo4StripperClip", },
    },
    ["M16"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1,
        isPolice = "Rare", 
        isMilitary = "Common",
    },
    ["M1903"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto-IM",
        isCivilian = "Rare",
        data = { speedLoader = 'M1903StripperClip', },
    },
    ["M21"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto",
        isPolice = "Rare", 
        isMilitary = "Rare",
    },
    ["M249"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto",
        isMilitary = "Rare",
        data = {
            clickSound = 'ORGMRifleEmpty',
            ejectSound = 'ORGMLMGOut',
            insertSound = 'ORGMLMGIn',
            rackSound = 'ORGMLMGRack',
        },
    },
    ["M4C"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1,
        isPolice= "Rare", 
        isMilitary = "Common",
    },
    ["Marlin60"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto-IM",
        isCivilian = "Common",
        data = {
            rackSound = 'ORGMRifleRack',
            clickSound = 'ORGMSmallPistolEmpty',
            insertSound = 'ORGMMagLoad',
        },
    },
    ["Mini14"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Common", 
        isPolice = "Rare",
    },
    ["Mosin"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt-IM",
        isCivilian = "Common",
        data = { speedLoader = 'MosinStripperClip', },
    },
    ["R25"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
    },
    ["Rem700"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt-IM",
        isCivilian = "Common", 
        isPolice = "Rare",
    },
    ["Rem788"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt",
        isCivilian = "Rare",
    },
    ["Rug1022"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
    },
    ["SA80"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1,
        isMilitary = "Rare",
    },
    ["SIG550"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1,
        isCivilian = "VeryRare",
    },
    ["SIG551"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1,
        isCivilian = "VeryRare",
    },
    ["SKS"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto-IM",
        isCivilian = "Common",
        data = { speedLoader = 'SKSStripperClip', },
    },
    ["SR25"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isMilitary = "Common",
    },
    ["SVD"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto",
        isCivilian = "Rare",
    },
    ["WinM70"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt-IM",
        isCivilian = "Rare", 
        isMilitary = "Rare",
    },
    ["WinM94"] = {
        gunType = "Lever-DAO",
        soundProfile = "Rifle-Lever",
        isCivilian = "Rare",
    },
        --************************************************************************--
        -- shotguns
        --************************************************************************--

    ["BenelliM3"] = {
        gunType = "Auto-DAO",
        soundProfile = "Shotgun",
        altActionType = "Pump",
        isPolice = "Common",
    },
    ["BenelliM3SO"] = {
        gunType = "Auto-DAO",
        soundProfile = "Shotgun",
        altActionType = "Pump",
    },
    ["BenelliXM1014"] = {
        gunType = "Auto-DAO",
        soundProfile = "Shotgun",
        isMilitary = "Common",
        data = { rackSound = 'ORGMARRack', },
    },
    ["Hawk982"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
    },
    ["Ithaca37"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
    },
    ["Ithaca37SO"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
    },
    ["M1216"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
    },
    ["Moss590"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
    },
    ["Moss590SO"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
    },
    ["Rem870"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common", 
        isPolice = "Common",
    },
    ["Rem870SO"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
    },
    ["Silverhawk"] = {
        gunType = "Break-SA",
        soundProfile = "Shotgun-Break",
        isCivilian = "Common",
    },
    ["SilverHawkSO"] = {
        gunType = "Break-SA",
        soundProfile = "Shotgun-Break",
        isCivilian = "Common",
    },
    ["Spas12"] = {
        gunType = "Auto-DAO",
        soundProfile = "Shotgun",
        altActionType = "Pump",
        isCivilian = "Rare", 
        isPolice = "Rare", 
        isMilitary = "Rare",
    },
    ["Stevens320"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
    },
    ["Striker"] = {
        gunType = "Rotary-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Rare", 
        isPolice = "Rare",
        data = { rackSound = 'ORGMARRack', },
    },
    ["VEPR12"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
        data = { clickSound = 'ORGMShotgunEmpty', },
    },
    ["Win1887"] = {
        gunType = "Lever-DAO",
        soundProfile = "Shotgun-Lever",
        isCivilian = "VeryRare",
    },
    ["Win1887SO"] = {
        gunType = "Lever-DAO",
        soundProfile = "Shotgun-Lever",
    },
}


-- setup all magazines
-- this is a funky loop syntax, but allows us to use the break keyword to continue the loop
-- keeps from using nasty nested if / else statements
for name, info in pairs(ORGMMasterMagTable) do repeat
    local magItem = getScriptManager():FindItem('ORGM.' .. name)
    if not magItem then
        print("*** WARNING: ORGM." .. name .. " defined in ORGMMasterMagTable but no matching script item!")
        break
    end
    local data = info.data
    info.name = magItem:getDisplayName()
    info.icon = magItem:getIcon()
    data.type = name
    data.moduleName = "ORGM"
    data.reloadClass = "ISORGMMagazine"
    data.clipType = name
    data.shootSound = 'none'
    data.clickSound = nil
    -- TODO: add these to the SoundBanksSetupTable
    if data.ejectSound == nil then data.ejectSound = 'ORGMMagLoad' end
    if data.insertSound == nil then data.insertSound = 'ORGMMagLoad' end
    if data.rackSound == nil then data.rackSound = 'ORGMMagLoad' end
    if data.reloadTime == nil then data.reloadTime = 30 end
    data.containsClip = 0
    data.rackTime = 10
    ReloadUtil:addMagazineType(data)
until true end


-- setup all guns
-- this is a funky loop syntax, but allows us to use the break keyword to continue the loop
-- keeps from using nasty nested if / else statements

for name, info in pairs(ORGMMasterWeaponTable) do repeat
    local gunItem = getScriptManager():FindItem('ORGM.' .. name)
    if not gunItem then
        print("*** WARNING: ORGM." .. name .. " defined in ORGMMasterWeaponTable but no matching script item!")
        break
    end
    if not info.data then info.data = {} end
    local data = info.data
    data.ammoType = gunItem:getAmmoType() -- get the ammoType from the script item
    if data.ammoType == nil then
        print("*** ERROR: ORGM." .. name .. " missing AmmoType in script item!")
        break
    elseif getScriptManager():FindItem('ORGM.' .. data.ammoType) == nil then
        print("*** ERROR: ORGM." .. name .. " AmmoType isn't valid! (no script item)")
        break
    end

    -- apply any defaults from the GunTypes table
    if (info.gunType == nil or GunTypes[info.gunType] == nil) then
        print("*** ERROR: ORGM.".. name .. " has invalid gunType (ORGMReloadUtil.lua)")
        break
    end
    for key, value in pairs(GunTypes[info.gunType]) do
        if data[key] == nil then data[key] = value end
    end

    
    -- apply any defaults from the SoundProfiles table
    if (info.soundProfile and SoundProfiles[info.soundProfile]) then
        local profile = SoundProfiles[info.soundProfile]
        for key, value in pairs(profile) do
            if data[key] == nil then data[key] = value end
            -- load value into SoundBanksSetupTable
            -- TODO: This misses sounds that aren't in the soundProfile
            if SoundBanksSetupTable[data[key]] == nil then
                SoundBanksSetupTable[data[key]] = {gain = 1, minrange = 0.001, maxrange = 25, maxreverbrange = 25, reverbfactor = 1.0, priority = 5}
            end
        end
    else
        print("*** WARNING: ORGM.".. name .. " has invalid soundProfile (ORGMReloadUtil.lua)")
    end
    
    -- load SwingSound into SoundBanksSetupTable
    local swingSound = gunItem:getSwingSound()
    if SoundBanksSetupTable[swingSound] == nil then
        SoundBanksSetupTable[swingSound] = {gain = 2,  minrange = 0.001, maxrange = 1000, maxreverbrange = 1000, reverbfactor = 1.0, priority = 9 }
    end
    
    if info.altActionType then -- this gun has alternating action types (pump and auto, etc)
        data.altActionType = {data.actionType, info.altActionType}
    end

    -- check if gun uses a mag, and link clipData
    local mag = ORGMMasterMagTable[data.ammoType] 
    if mag then
        data.clipName = mag.name
        data.clipIcon = mag.icon
        data.clipData = mag.data
        data.containsClip = 1
    end

    -- setup remaining defaults
    data.type = name
    data.moduleName = "ORGM"
    data.reloadClass = 'ISORGMWeapon'
    data.selectFire = info.selectFire
    if data.rackTime == nil then data.rackTime = 10 end
    if data.reloadTime == nil then data.reloadTime = 15 end
    data.isOpen = 0
    data.hammerCocked = 0

    -- TODO: there should also be some strict error checking here insuring all required variables are set.
    ReloadUtil:addWeaponType(data)
    
    -- build up the weapons table for spawning
    if info.isCivilian then
        if ORGMWeaponRarityTable.Civilian[info.isCivilian] ~= nil then table.insert(ORGMWeaponRarityTable.Civilian[info.isCivilian], name) end
    end
    if info.isPolice then
        if ORGMWeaponRarityTable.Police[info.isPolice] ~= nil then table.insert(ORGMWeaponRarityTable.Police[info.isPolice], name) end
    end
    if info.isMilitary then
        if ORGMWeaponRarityTable.Military[info.isMilitary] ~= nil then table.insert(ORGMWeaponRarityTable.Military[info.isMilitary], name) end
    end

    
until true end


Events.OnLoadSoundBanks.Add(function()
    for key, value in pairs(SoundBanksSetupTable) do
        getFMODSoundBank():addSound(key, "media/sound/" .. key .. ".ogg", value.gain, value.minrange, value.maxrange, value.maxreverbrange, value.reverbfactor, value.priority, false)
    end
end)
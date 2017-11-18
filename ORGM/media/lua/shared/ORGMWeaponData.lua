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
    ["Rotary-SA"] = {
        triggerType = "SingleAction",
        actionType = "Rotary"
    },
    ["Rotary-DA"] = {
        triggerType = "DoubleAction",
        actionType = "Rotary"
    },
    ["Rotary-DAO"] = {
        triggerType = "DoubleActionOnly",
        actionType = "Rotary"
    },
    ["Auto-SA"] = {
        triggerType = "SingleAction",
        actionType = "Auto"
    },
    ["Auto-DA"] = {
        triggerType = "DoubleAction",
        actionType = "Auto"
    },
    ["Auto-DAO"] = {
        triggerType = "DoubleActionOnly",
        actionType = "Auto"
    },
    ["Bolt-SA"] = {
        triggerType = "SingleAction",
        actionType = "Bolt"
    },
    ["Bolt-DA"] = {
        triggerType = "DoubleAction",
        actionType = "Bolt"
    },
    ["Bolt-DAO"] = {
        triggerType = "DoubleActionOnly",
        actionType = "Bolt",
    },
    ["Lever-SA"] = {
        triggerType = "SingleAction",
        actionType = "Lever",
    },
    ["Lever-DA"] = {
        triggerType = "DoubleAction",
        actionType = "Lever"
    },
    ["Lever-DAO"] = {
        triggerType = "DoubleActionOnly",
        actionType = "Lever"
    },
    ["Pump-SA"] = {
        triggerType = "SingleAction",
        actionType = "Pump"
    },
    ["Pump-DA"] = {
        triggerType = "DoubleAction",
        actionType = "Pump"
    },
    ["Pump-DAO"] = {
        triggerType = "DoubleActionOnly",
        actionType = "Pump"
    },
    ["Break-SA"] = {
        triggerType = "SingleAction",
        actionType = "Break"
    },    
    ["Break-DA"] = {
        triggerType = "DoubleAction",
        actionType = "Break"
    },
    ["Break-DAO"] = {
        triggerType = "DoubleActionOnly",
        actionType = "Break"
    }    
}

--[[ The SoundProfiles table contains some basic sound profiles for working the action.
    Any key = value pairs here can be overridden by specific weapons, each key is only set in the 
    weapons data table if it doesn't already exist.
    Note: shootSound is not covered in these profiles, as they are specific to each weapon.
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

--[[ The Alternate Ammo Table (Global)
    This table defines what ammo can be used as replacements for other ammo. When searching the player 
    inventory to find ammo to load into the gun/magazine, it will search these rounds in order.
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
ORGMAlternateMagTable = {

}

--[[ The Ammo Stats Table (Global)
    This is used for guns that load alternating ammo types.  If a round is different from the last round loaded,
    it changes several of the weapon properties to match the new ammo.
]]
ORGMAmmoStatsTable = {
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
    ["Ammo_12g_00Buck"]         = { MinDamage = 1.5, MaxDamage = 2.2, MaxHitCount = 4, PiercingBullets = 4 },
    ["Ammo_12g_Slug"]           = { MinDamage = 2.0, MaxDamage = 2.8, MaxHitCount = 1, PiercingBullets = 95 }
}

--[[ The Master Magazine Table (global)
    This table contains all magazine data (ammoType, maxCapacity, etc), it lists clipIcon and clipName 
    originally listed in each weapon's table (since multiple guns often use the same mag, it makes sense to
    just move those keys to the magazine instead).
    It also contains any caliber conversion data (ie: 7.62 to .308)

    MagName = {
        name = "", -- clipName used by any weapon that uses this mag
        icon = "", -- clipIcon used by any weapon that uses this mag
        data = { -- table passed to ReloadUtil:addMagazineType()
            -- any key = value pair that doesn't exist here (but should) is set to a default
            ammoType = "",
            maxCapacity = ""
        },
    }
]]

ORGMMasterMagTable = {
    ["AIAW308Mag"] = {
        name = 'AI-AW .308 Magazine (.308)',
        icon = 'AIAW308Mag',
        data = { 
            ammoType = 'Ammo_308Winchester',
            maxCapacity = 5,
        },
    },
    ["AKMMag"] = {
        name = 'AKM Magazine (7.62x39)',
        icon = 'AKMMag',
        data = {
            ammoType = 'Ammo_762x39mm',
            maxCapacity = 30,
        },
    },
    ["AM180Mag"] = {
        name = 'American-180 Magazine (.22)',
        icon = 'AM180Mag',
        data = {
            ammoType = 'Ammo_22LR',
            maxCapacity = 177,
        },
    },
    ["AR10Mag"] = {
        name = 'AR-10 Magazine (7.62x51)',
        icon = 'AR10Mag',
        data = {
            ammoType = 'Ammo_762x51mm',
            maxCapacity = 20,
        },
    },
    ["AutomagVMag"] = {
        name = 'AMT Automag V Magazine (.50)',
        icon = 'AutomagVMag',
        data = {
            ammoType = 'Ammo_50AE',
            maxCapacity = 5,
        },
    },
    ["BBPistolMag"] = {
        name = 'Daisy Powerline Model 201 Magazine (.117 BBs)',
        icon = 'BBPistolMag',
        data = {
            ammoType = 'Ammo_117BB',
            maxCapacity = 35,
            reloadTime = 5,
        },
    },
    ["Ber92Mag"] = {
        name = 'Beretta 92 Magazine (9mm)',
        icon = 'Ber92Mag',
        data = {
            ammoType = 'Ammo_9x19mm',
            maxCapacity = 15,
        },
    },
    ["Ber93RMag"] = {
        name = 'Beretta 93R Magazine (9mm)',
        icon = 'Ber93RMag',
        data = {
            ammoType = 'Ammo_9x19mm',
            maxCapacity = 32,
        },
    },
    ["BrenTenMag"] = {
        name = 'Bren Ten Magazine (10mm)',
        icon = 'BrenTenMag',
        data = {
            ammoType = 'Ammo_10x25mm',
            maxCapacity = 12,
        },
    },
    ["BrownHPMag"] = {
        name = 'Browning HP Magazine (9mm)',
        icon = 'BrownHPMag',
        data = {
            ammoType = 'Ammo_9x19mm',
            maxCapacity = 13,
        },
    },
    ["Colt38SMag"] = {
        name = 'Colt Commander Super 38 Magazine (.38S)',
        icon = 'Colt38SMag',
        data = {
            ammoType = 'Ammo_38Super',
            maxCapacity = 9,
        },
    },
    ["ColtDeltaMag"] = {
        name = 'Colt Delta Elite Magazine (10mm)',
        icon = 'ColtDeltaMag',
        data = {
            ammoType = 'Ammo_10x25mm',
            maxCapacity = 8,
        },
    },
    ["CZ75Mag"] = {
        name = 'CZ 75 Magazine (.40)',
        icon = 'CZ75Mag',
        data = {
            ammoType = 'Ammo_40SW',
            maxCapacity = 10,
        },
    },
    ["DEagleMag"] = {
        name = 'IMI Desert Eagle Magazine (.44)',
        icon = 'DEagleMag',
        data = {
            ammoType = 'Ammo_44Magnum',
            maxCapacity = 8,
        },
    },
    ["DEagleXIXMag"] = {
        name = 'IMI Desert Eagle XIX Magazine (.50)',
        icon = 'DEagleXIXMag',
        data = {
            ammoType = 'Ammo_50AE',
            maxCapacity = 7,
        },
    },
    ["FN57Mag"] = {
        name = 'FN Five-seven Magazine (5.7mm)',
        icon = 'FN57Mag',
        data = {
            ammoType = 'Ammo_57x28mm',
            maxCapacity = 20,
        },
    },
    ["FNFALAMag"] = {
        name = 'FN FAL Magazine (7.62x51mm)',
        icon = 'FNFALMag',
        data = {
            ammoType = 'Ammo_762x51mm',
            maxCapacity = 20,
        },
    },
    ["FNFALMag"] = {
        name = 'FSL LSR Magazine (.308)',
        icon = 'FNFALMag',
        data = {
            ammoType = 'Ammo_308Winchester',
            maxCapacity = 20,
        },
    },
    ["FNP90Mag"] = {
        name = 'FN P90 Magazine (5.7mm)',
        icon = 'FNP90Mag',
        data = {
            ammoType = 'Ammo_57x28mm',
            maxCapacity = 50,
        },
    },
    ["GarandClip"] = {
        name = 'M1 Garand Clip (.30-06)',
        icon = 'GarandClip',
        data = {
            ammoType = 'Ammo_3006Springfield',
            maxCapacity = 8,
        },
    },
    ["Glock17Mag"] = {
        name = 'Glock 17 Magazine (9mm)',
        icon = 'Glock17Mag',
        data = {
            ammoType = 'Ammo_9x19mm',
            maxCapacity = 17,
        },
    },
    ["Glock20Mag"] = {
        name = 'Glock 20 Magazine (10mm)',
        icon = 'Glock20Mag',
        data = {
            ammoType = 'Ammo_10x25mm',
            maxCapacity = 15,
        },
    },
    ["Glock21Mag"] = {
        name = 'Glock 21 Magazine (.45)',
        icon = 'Glock21Mag',
        data = {
            ammoType = 'Ammo_45ACP',
            maxCapacity = 13,
        },
    },
    ["Glock22Mag"] = {
        name = 'Glock 22 Magazine (.40)',
        icon = 'Glock22Mag',
        data = {
            ammoType = 'Ammo_40SW',
            maxCapacity = 10,
        },
    },
    ["HK91Mag"] = {
        name = 'H&K 91 Magazine (.308)',
        icon = 'HK91Mag',
        data = {
            ammoType = 'Ammo_308Winchester',
            maxCapacity = 20,
        },
    },
    ["HKG3Mag"] = {
        name = 'H&K G3 Magazine (7.62x51mm)',
        icon = 'HK91Mag',
        data = {
            ammoType = 'Ammo_762x51mm',
            maxCapacity = 20,
        },
    },
    ["HKMK23Mag"] = {
        name = 'H&K MK 23 Magazine (.45)',
        icon = 'HKMK23Mag',
        data = {
            ammoType = 'Ammo_45ACP',
            maxCapacity = 12,
        },
    },
    ["HKMP5Mag"] = {
        name = 'H&K MP5 Magazine (9mm)',
        icon = 'HKMP5Mag',
        data = {
            ammoType = 'Ammo_9x19mm',
            maxCapacity = 30,
        },
    },
    ["HKSL8Mag"] = {
        name = 'H&K SL8 Magazine (.223)',
        icon = 'HKSL8Mag',
        data = {
            ammoType = 'Ammo_223Remington',
            maxCapacity = 20,
            reloadTime = 15,
        },
    },
    ["HKUMPMag"] = {
        name = 'H&K UMP Magazine (.45)',
        icon = 'HKUMPMag',
        data = {
            ammoType = 'Ammo_45ACP',
            maxCapacity = 25,
            reloadTime = 25,
        },
    },
    ["KahrCT40Mag"] = {
        name = 'Kahr CT-40 Magazine (.40)',
        icon = 'KahrCT40Mag',
        data = {
            ammoType = 'Ammo_40SW',
            maxCapacity = 7,
        },
    },
    ["KahrP380Mag"] = {
        name = 'Kahr P-380 Magazine (.380 ACP)',
        icon = 'KahrP380Mag',
        data = {
            ammoType = 'Ammo_380ACP',
            maxCapacity = 6,
        },
    },
    ["KTP32Mag"] = {
        name = 'Kel-Tec P-32 Magazine (.32ACP)',
        icon = 'KTP32Mag',
        data = {
            ammoType = 'Ammo_32ACP',
            maxCapacity = 7,
        },
    },
    ["L96Mag"] = {
        name = 'L96 Magazine (7.62x51)',
        icon = 'AIAW308Mag',
        data = {
            ammoType = 'Ammo_762x51mm',
            maxCapacity = 5,
        },
    },
    ["LENo4Mag"] = {
        name = 'Lee Enfield No. 4 Magazine (7.62x51)',
        icon = 'LENo4Mag',
        data = {
            ammoType = 'Ammo_762x51mm',
            maxCapacity = 10,
        },
    },
    ["M1216Mag"] = {
        name = 'SRM Arms Model 1216 Magazine (12 gauge)',
        icon = 'M1216Mag',
        data = {
            ammoType = 'Ammo_12g',
            ejectSound = 'ORGMShotgunRoundIn',
            insertSound = 'ORGMShotgunRoundIn',
            --rackSound = 'ORGMShotgunRoundIn',
            maxCapacity = 16,
            reloadTime = 15,
        },
    },
    ["M1903StripperClip"] = {
        name = 'Springfield M1903 Stripper Clip',
        icon = 'M1903StripperClip',
        data = {
            ammoType = 'Ammo_3006Springfield',
            maxCapacity = 5,
            reloadTime = 15,
        },
    },
    ["M1911Mag"] = {
        name = 'M1911 Magazine (.45)',
        icon = 'M1911Mag',
        data = {
            ammoType = 'Ammo_45ACP',
            maxCapacity = 7,
        },
    },
    ["M1A1Mag"] = {
        name = 'M1A1 Magazine (.45)',
        icon = 'M1A1Mag',
        data = {
            ammoType = 'Ammo_45ACP',
            maxCapacity = 30,
            reloadTime = 25,
        },
    },
    ["M21Mag"] = {
        name = 'M21 Magazine (7.62x51)',
        icon = 'M21Mag',
        data = {
            ammoType = 'Ammo_762x51mm',
            maxCapacity = 20,
        },
    },
    ["M249Belt"] = {
        name = 'M249 Belt (5.56)',
        icon = 'M249Belt',
        data = {
            ammoType = 'Ammo_556x45mm',
            maxCapacity = 200,
        },
    },
    ["Mac10Mag"] = {
        name = 'Mac-10 Magazine (.45)',
        icon = 'Mac10Mag',
        data = {
            ammoType = 'Ammo_45ACP',
            maxCapacity = 30,
            reloadTime = 25,
        },
    },
    ["Mac11Mag"] = {
        name = 'Mac-11 Magazine (.380 ACP)',
        icon = 'Mac11Mag',
        data = {
            ammoType = 'Ammo_380ACP',
            maxCapacity = 32,
        },
    },
    ["Mini14Mag"] = {
        name = 'Ruger Mini-14 Magazine (.223)',
        icon = 'Mini14Mag',
        data = {
            ammoType = 'Ammo_223Remington',
            maxCapacity = 20,
            reloadTime = 15,
        },
    },
    ["MosinStripperClip"] = {
        name = 'Mosin Nagant Stripper Clip',
        icon = 'MosinStripperClip',
        data = {
            ammoType = 'Ammo_762x54mm',
            maxCapacity = 5,
            reloadTime = 15,
        },
    },
    ["R25Mag"] = {
        name = 'Remington R25 Magazine (.308)',
        icon = 'R25Mag',
        data = {
            ammoType = 'Ammo_308Winchester',
            maxCapacity = 10,
        },
    },
    ["Rem788Mag"] = {
        name = 'Remington Magazine (.30-30)',
        icon = 'Rem788Mag',
        data = {
            ammoType = 'Ammo_3030Winchester',
            maxCapacity = 3,
        },
    },
    ["Rug1022Mag"] = {
        name = 'Ruger 10/22 Magazine (.22)',
        icon = 'Rug1022Mag',
        data = {
            ammoType = 'Ammo_22LR',
            maxCapacity = 25,
        },
    },
    ["RugerMKIIMag"] = {
        name = 'Ruger MKII Magazine (.22)',
        icon = 'RugerMKIIMag',
        data = {
            ammoType = 'Ammo_22LR',
            maxCapacity = 10,
        },
    },
    ["RugerSR9Mag"] = {
        name = 'Ruger SR9 Magazine (9mm)',
        icon = 'RugerSR9Mag',
        data = {
            ammoType = 'Ammo_9x19mm',
            maxCapacity = 17,
        },
    },
    ["SIG550Mag"] = {
        name = 'Sig SG550 Magazine (5.56x45)',
        icon = 'SIG550Mag',
        data = {
            ammoType = 'Ammo_556x45mm',
            maxCapacity = 30,
        },
    },
    ["SIGP226Mag"] = {
        name = 'SIG P226 Magazine (.40)',
        icon = 'SIGP226Mag',
        data = {
            ammoType = 'Ammo_40SW',
            maxCapacity = 12,
        },
    },
    ["SkorpionMag"] = {
        name = 'Skorpion vz. 61 Magazine (.32ACP)',
        icon = 'SkorpionMag',
        data = {
            ammoType = 'Ammo_32ACP',
            maxCapacity = 20,
        },
    },
    ["SKSStripperClip"] = {
        name = 'SKS Stripper Clip',
        icon = 'SKSStripperClip',
        data = {
            ammoType = 'Ammo_762x39mm',
            maxCapacity = 10,
            reloadTime = 15,
        },
    },
    ["SpeedLoader10mm6"] = {
        name = '10mm Auto 6 round Speed Loader',
        icon = '10mmSpeedLoader6',
        data = {
            ammoType = 'Ammo_10x25mm',
            maxCapacity = 6,
            reloadTime = 15,
        },
    },
    ["SpeedLoader3576"] = {
        name = '.357 Magnum 6 round Speed Loader',
        icon = '357SpeedLoader6',
        data = {
            ammoType = 'Ammo_357Magnum',
            maxCapacity = 6,
            reloadTime = 15,
        },
    },
    ["SpeedLoader385"] = {
        name = '.38 Special 5 round Speed Loader',
        icon = '38SpeedLoader5',
        data = {
            ammoType = 'Ammo_38Special',
            maxCapacity = 5,
            reloadTime = 15,
        },
    },
    ["SpeedLoader386"] = {
        name = '.38 Special 6 round Speed Loader',
        icon = '38SpeedLoader6',
        data = {
            ammoType = 'Ammo_38Special',
            maxCapacity = 6,
            reloadTime = 15,
        },
    },
    ["SpeedLoader446"] = {
        name = '.44 Magnum 6 round Speed Loader',
        icon = '44SpeedLoader6',
        data = {
            ammoType = 'Ammo_44Magnum',
            maxCapacity = 6,
            reloadTime = 15,
        },
    },
    ["SpeedLoader4546"] = {
        name = '.454 Casull 6 round Speed Loader',
        icon = '454SpeedLoader6',
        data = {
            ammoType = 'Ammo_454Casull',
            maxCapacity = 6,
            reloadTime = 15,
        },
    },
    ["SpeedLoader456"] = {
        name = '.45 ACP 6 round Speed Loader',
        icon = '45SpeedLoader6',
        data = {
            ammoType = 'Ammo_45ACP',
            maxCapacity = 6,
            reloadTime = 15,
        },
    },
    ["SpeedLoader45C6"] = {
        name = '.45 Colt 6 round Speed Loader',
        icon = '454SpeedLoader6',
        data = {
            ammoType = 'Ammo_45Colt',
            maxCapacity = 6,
            reloadTime = 15,
        },
    },
    ["Spr19119Mag"] = {
        name = 'Springfield 1911 9mm Magazine (9mm)',
        icon = 'Spr19119Mag',
        data = {
            ammoType = 'Ammo_9x19mm',
            maxCapacity = 9,
        },
    },
    ["SR25Mag"] = {
        name = 'KAC SR-25 Magazine (7.62x51)',
        icon = 'SR25Mag',
        data = {
            ammoType = 'Ammo_762x51mm',
            maxCapacity = 20,
        },
    },
    ["STANAGMag"] = {
        name = 'Standard STANAG Magazine (5.56x45)',
        icon = 'STANAGMag',
        data = {
            ammoType = 'Ammo_556x45mm',
            maxCapacity = 30,
        },
    },
    ["SVDMag"] = {
        name = 'SVD Magazine (7.62x54R)',
        icon = 'SVDMag',
        data = {
            ammoType = 'Ammo_762x54mm',
            maxCapacity = 10,
            reloadTime = 15,
        },
    },
    ["Taurus38Mag"] = {
        name = 'Taurus PT38S Magazine (.38S)',
        icon = 'Taurus38Mag',
        data = {
            ammoType = 'Ammo_38Super',
            maxCapacity = 10,
        },
    },
    ["TaurusP132Mag"] = {
        name = 'Taurus Millennium P132 Magazine (.32ACP)',
        icon = 'TaurusP132Mag',
        data = {
            ammoType = 'Ammo_32ACP',
            maxCapacity = 10,
        },
    },
    ["UziMag"] = {
        name = 'Uzi Magazine (9mm)',
        icon = 'UziMag',
        data = {
            ammoType = 'Ammo_9x19mm',
            maxCapacity = 32,
        },
    },
    ["VEPR12Mag"] = {
        name = 'VEPR-12 Magazine (12 gauge)',
        icon = 'VEPR12Mag',
        data = {
            ammoType = 'Ammo_12g',
            ejectSound = 'ORGMShotgunRoundIn',
            insertSound = 'ORGMShotgunRoundIn',
            --rackSound = 'ORGMShotgunRoundIn',
            maxCapacity = 8,
            reloadTime = 15,
        },
    },
    ["WaltherP22Mag"] = {
        name = 'Walther P22 Magazine (.22)',
        icon = 'WaltherP22Mag',
        data = {
            ammoType = 'Ammo_22LR',
            maxCapacity = 10,
        },
    },
    ["WaltherPPKMag"] = {
        name = 'Walther PPK Magazine (.380 ACP)',
        icon = 'WaltherPPKMag',
        data = {
            ammoType = 'Ammo_380ACP',
            maxCapacity = 6,
        },
    },
    ["XD40Mag"] = {
        name = 'Springfield XD-40 Magazine (.40)',
        icon = 'XD40Mag',
        data = {
            ammoType = 'Ammo_40SW',
            maxCapacity = 9,
        },
    },
}

--[[ The Master Weapon Table (global)
    This table contains all weapon data
    
    WeaponName = {
        gunType = "", -- the action and trigger type (see the GunTypes table above)
        soundProfile = "", -- the sound profile to apply (see the SoundProfiles table above)
        data = { -- table passed to ReloadUtil:addWeaponType()
            -- any key = value pair that doesn't exist here (but should) is set to a default
            -- or inherited from the GunTypes and SoundProfiles tables
            ammoType = "",
            shootSound = "",
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
        data = {
            speedLoader = 'SpeedLoader446',
            ammoType = 'Ammo_44Magnum',
            shootSound = 'ORGMColtAnac',
        },
    },
    ["ColtPyth"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = {
            speedLoader = 'SpeedLoader3576',
            ammoType = 'Ammo_357Magnum',
            shootSound = 'ORGMColtPyth',
        },
    },
    ["ColtSAA"] = {
        gunType = "Rotary-SA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = {
            ammoType = 'Ammo_45Colt',
            shootSound = 'ORGMColtSAA',
            shootSoundPartial = 'ORGMColtSAA',
        },
    },
    ["RugAlas"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = {
            speedLoader = 'SpeedLoader4546',
            ammoType = 'Ammo_454Casull',
            shootSound = 'ORGMRugAlas',
        },
    },
    ["RugBH"] = {
        gunType = "Rotary-SA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = {
            ammoType = 'Ammo_357Magnum',
            shootSound = '357Fire',
            shootSoundPartial = '357Fire',
        },
    },
    ["RugGP100"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = {
            speedLoader = 'SpeedLoader3576',
            ammoType = 'Ammo_357Magnum',
            shootSound = '357Fire',
        },
    },
    ["RugRH"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = {
            speedLoader = 'SpeedLoader446',
            ammoType = 'Ammo_44Magnum',
            shootSound = 'ORGMRugBH',
        },
    },
    ["RugSec6"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = {
            speedLoader = 'SpeedLoader386',
            ammoType = 'Ammo_38Special',
            shootSound = 'ORGMRugSec6',
        },
    },
    ["SWM10"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = {
            speedLoader = 'SpeedLoader386',
            ammoType = 'Ammo_38Special',
            shootSound = 'ORGMSWM10',
        },
    },
    ["SWM19"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = {
            speedLoader = 'SpeedLoader3576',
            ammoType = 'Ammo_357Magnum',
            shootSound = 'ORGMSWM19',
        },
    },
    ["SWM252"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = {
            speedLoader = 'SpeedLoader456',
            ammoType = 'Ammo_45ACP',
            shootSound = 'ORGMSWM252',
        },
    },
    ["SWM29"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = {
            speedLoader = 'SpeedLoader446',
            ammoType = 'Ammo_44Magnum',
            shootSound = 'ORGMSWM29',
        },
    },
    ["SWM36"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = {
            speedLoader = 'SpeedLoader385',
            ammoType = 'Ammo_38Special',
            shootSound = 'ORGMSWM36',
        },
    },
    ["SWM610"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Rare",
        data = {
            speedLoader = 'SpeedLoader10mm6',
            ammoType = 'Ammo_10x25mm',
            shootSound = 'ORGMSWM610',
        },
    },
    ["Taurus454"] = {
        gunType = "Rotary-DA",
        soundProfile = "Revolver",
        isCivilian = "Common",
        data = {
            speedLoader = 'SpeedLoader4546',
            ammoType = 'Ammo_454Casull',
            shootSound = 'ORGMRagingBull',
        },
    },
        --************************************************************************--
        -- semi pistols
        --************************************************************************--
    ["AutomagV"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Large",
        isCivilian = "Rare",
        data = {
            ammoType = 'AutomagVMag',
            shootSound = 'ORGMAutomag',
        },
    },
    ["BBPistol"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'BBPistolMag',
            shootSound = 'ORGMDaisy',
        },
    },
    ["Ber92"] = {
        gunType = "Auto-DA", -- this can be DAO, depending on model
        soundProfile = "Pistol-Small",
        isCivilian = "Common", isPolice = "Common", isMilitary = "Common",
        data = {
            ammoType = 'Ber92Mag',
            shootSound = 'ORGMBeretta',
        },
    },
    ["BrenTen"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
        data = {
            ammoType = 'BrenTenMag',
            shootSound = 'ORGMBrenTen',
        },
    },
    ["BrownHP"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'BrownHPMag',
            shootSound = 'ORGMBrowningHP',
        },
    },
    ["Colt38S"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
        data = {
            ammoType = 'Colt38SMag',
            shootSound = 'ORGMColtSuper38',
        },
    },
    ["ColtDelta"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
        data = {
            ammoType = 'ColtDeltaMag',
            shootSound = 'ORGMColtDelta',
        },
    },
    ["CZ75"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
        data = {
            ammoType = 'CZ75Mag',
            shootSound = 'ORGMCZ75',
        },
    },
    ["DEagle"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Large",
        isCivilian = "Rare",
        data = {
            ammoType = 'DEagleMag',
            shootSound = 'ORGMDeagle44',
        },
    },
    ["DEagleXIX"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Large",
        isCivilian = "Rare",
        data = {
            ammoType = 'DEagleXIXMag',
            shootSound = 'ORGMDeagle50',
        },
    },
    ["FN57"] = {
        gunType = "Auto-DAO", -- depending on model, this can be SA (FN57 Tactical)
        soundProfile = "Pistol-Small",
        isCivilian = "Rare", isPolice = "Rare", isMilitary = "Rare",
        data = {
            ammoType = 'FN57Mag',
            shootSound = 'ORGMFiveseven',
        },
    },
    ["Glock17"] = {
        gunType = "Auto-DAO", -- this is technically not quite true, but as close as its going to get
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'Glock17Mag',
            shootSound = 'ORGMGlock17',
        },
    },
    ["Glock20"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'Glock20Mag',
            shootSound = 'ORGMGlock20',
        },
    },
    ["Glock21"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'Glock21Mag',
            shootSound = 'ORGMGlock21',
        },
    },
    ["Glock22"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'Glock22Mag',
            shootSound = 'ORGMGlock22',
        },
    },
    ["HKMK23"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
        data = {
            ammoType = 'HKMK23Mag',
            shootSound = 'ORGMMK23',
        },
    },
    ["KahrCT40"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'KahrCT40Mag',
            shootSound = 'ORGMKahrCT40',
        },
    },
    ["KahrP380"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'KahrP380Mag',
            shootSound = 'ORGMKahrP380',
        },
    },
    ["KTP32"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'KTP32Mag',
            shootSound = 'ORGMKelTecP32',
        },
    },
    ["M1911"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common", isMilitary = "Common",
        data = {
            ammoType = 'M1911Mag',
            shootSound = 'ORGMM1911',
        },
    },
    ["RugerMKII"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'RugerMKIIMag',
            shootSound = 'ORGMRugerMKII',
        },
    },
    ["RugerSR9"] = {
        gunType = "Auto-DAO", -- like the glock, this isnt really a DAO
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'RugerSR9Mag',
            shootSound = 'ORGMRugerSR9',
        },
    },
    ["SIGP226"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common", isMilitary = "Rare",
        data = {
            ammoType = 'SIGP226Mag',
            shootSound = 'ORGMSIGP226',
        },
    },
    ["Spr19119"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'Spr19119Mag',
            shootSound = 'ORGMSpr19119',
        },
    },
    ["Taurus38"] = {
        gunType = "Auto-SA",
        soundProfile = "Pistol-Small",
        isCivilian = "Rare",
        data = {
            ammoType = 'Taurus38Mag',
            shootSound = 'ORGMTaurus38S',
        },
    },
    ["TaurusP132"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'TaurusP132Mag',
            shootSound = 'ORGMTaurusP132',
        },
    },
    ["WaltherP22"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'WaltherP22Mag',
            shootSound = 'ORGMWaltherP22',
        },
    },
    ["WaltherPPK"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'WaltherPPKMag',
            shootSound = 'ORGMWaltherPPK',
        },
    },
    ["XD40"] = {
        gunType = "Auto-DAO", -- striker trigger mechanism, DAO is close enough
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'XD40Mag',
            shootSound = 'ORGMSprXD',
        },
    },
        --************************************************************************--
        -- smg/machine pistols
        --************************************************************************--

    ["AM180"] = {
        gunType = "Auto-DAO", -- again, not really, its closer to SA, but doesnt allow for manual decocking
        soundProfile = "SMG",
        isCivilian = "VeryRare",
        data = {
            ammoType = 'AM180Mag',
            shootSound = 'ORGMAM180',
            ejectSound = 'ORGMSMG2Out', -- unique
            insertSound = 'ORGMSMG2In', -- unique
        },
    },
    ["Ber93R"] = {
        gunType = "Auto-DA",
        soundProfile = "Pistol-Small",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isCivilian = "VeryRare",
        data = {
            ammoType = 'Ber93RMag',
            shootSound = 'ORGMBeretta',
        },
    },
    ["FNP90"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isPolice = "Rare", isMilitary = "Rare",
        data = {
            ammoType = 'FNP90Mag',
            shootSound = 'ORGMFNP90',
        },
    },
    ["Glock18"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isCivilian = "VeryRare",
        data = {
            ammoType = 'Glock17Mag',
            shootSound = 'ORGMGlock17',
        },
    },
    -- TODO: fix all gun triggerTypes to proper values below here
    ["HKMP5"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isPolice = "Rare", isMilitary = "Common",
        data = {
            ammoType = 'HKMP5Mag',
            shootSound = 'ORGMHKMP5',
        },
    },
    ["HKUMP"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isPolice = "Rare", isMilitary = "Common",
        data = {
            ammoType = 'HKUMPMag',
            shootSound = 'ORGMUMP45',
        },
    },
    ["Kriss"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        isCivilian = "Rare",
        data = {
            ammoType = 'Glock21Mag',
            shootSound = 'ORGMKriss',
        },
    },
    ["KrissA"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isCivilian = "VeryRare",
        data = {
            ammoType = 'Glock21Mag',
            shootSound = 'ORGMKriss',
        },
    },
    ["KTPLR"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
        data = {
            ammoType = 'STANAGMag',
            shootSound = 'ORGMKTPLR',
        },
    },
    ["M1A1"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        isCivilian = "Rare",
        data = {
            ammoType = 'M1A1Mag',
            shootSound = 'ORGMM1A1',
        },
    },
    ["Mac10"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        isCivilian = "Rare",
        data = {
            ammoType = 'Mac10Mag',
            shootSound = 'ORGMMac10',
        },
    },
    ["Mac11"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        isCivilian = "Rare",
        data = {
            ammoType = 'Mac11Mag',
            shootSound = 'ORGMMac11',
        },
    },
    ["Skorpion"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "VeryRare",
        data = {
            ammoType = 'SkorpionMag',
            shootSound = 'ORGMSkorpion',
        },
    },
    ["Uzi"] = {
        gunType = "Auto-DAO",
        soundProfile = "SMG",
        isCivilian = "Rare",
        data = {
            ammoType = 'UziMag',
            shootSound = 'ORGMUzi',
        },
    },
        --************************************************************************--
        -- rifles
        --************************************************************************--
    ["AIAW308"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt",
        isCivilian = "Rare", isPolice = "Rare", isMilitary = "Rare",
        data = {
            ammoType = 'AIAW308Mag', -- or L96Mag
            shootSound = 'ORGML96',
        },
    },
    ["AKM"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
        data = {
            ammoType = 'AKMMag',
            shootSound = 'ORGMAKM',
        },
    },
    ["AKMA"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isCivilian = "VeryRare",
        data = {
            ammoType = 'AKMMag',
            shootSound = 'ORGMAKM',
        },
    },
    ["AR10"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isPolice = 'Rare',
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        data = {
            ammoType = 'AR10Mag',
            shootSound = 'ORGMAR10',
        },
    },
    ["AR15"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Common",
        data = {
            ammoType = 'STANAGMag',
            shootSound = 'ORGMAR15',
        },
    },
    ["BBGun"] = {
        gunType = "Lever-DAO",
        soundProfile = "Rifle-Lever",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_117BB',
            shootSound = 'ORGMRedRyder',
            shootSoundPartial = 'ORGMRedRyder',
            rackSound = 'ORGMBBLever', -- override
            clickSound = 'ORGMPistolEmpty', -- override
            insertSound = 'ORGMMagBBLoad', -- override
            rackTime = 3,  -- override
            bulletOutSound = "ORGMBBLever" -- override
        },
    },
    ["BLR"] = {
        gunType = "Lever-DAO",
        soundProfile = "Rifle-Lever",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_308Winchester',
            shootSound = 'ORGMBLR',
            shootSoundPartial = 'ORGMBLR',
        },
    },
    ["FNFAL"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
        data = {
            ammoType = 'FNFALMag',
            shootSound = 'ORGMFNFAL',
        },
    },
    ["FNFALA"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isCivilian = "VeryRare",
        data = {
            ammoType = 'FNFALAMag',
            shootSound = 'ORGMFNFAL',
        },
    },
    ["Garand"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto",
        isCivilian = "Common",
        data = {
            ammoType = 'GarandClip',
            shootSound = 'ORGMM1Garand',
        },
    },
    ["HenryBB"] = {
        gunType = "Lever-DAO",
        soundProfile = "Rifle-Lever",
        isCivilian = "Rare",
        data = {
            ammoType = 'Ammo_45Colt',
            shootSound = 'ORGMHenryBB',
            shootSoundPartial = 'ORGMHenryBB',
        },
    },
    ["HK91"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
        data = {
            ammoType = 'HK91Mag',
            shootSound = 'ORGMG3',
        },
    },
    ["HKG3"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isCivilian = "VeryRare",
        data = {
            ammoType = 'HKG3Mag',
            shootSound = 'ORGMG3',
        },
    },
    ["HKSL8"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
        data = {
            ammoType = 'HKSL8Mag',
            shootSound = 'ORGMHKSL8',
        },
    },
    ["L96"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt",
        isCivilian = "Common",
        data = {
            ammoType = 'L96Mag',
            shootSound = 'ORGML96',
        },
    },
    ["LENo4"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt",
        isCivilian = "Rare",
        data = {
            ammoType = 'LENo4Mag',
            shootSound = 'ORGMLENo4',
        },
    },
    ["M16"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isPolice = "Rare", isMilitary = "Common",
        data = {
            ammoType = 'STANAGMag',
            shootSound = 'ORGMAR15',
        },
    },
    ["M1903"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto-IM",
        isCivilian = "Rare",
        data = {
            speedLoader = 'M1903StripperClip',
            ammoType = 'Ammo_3006Springfield',
            shootSound = 'ORGMM1903',
        },
    },
    ["M21"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto",
        isPolice = "Rare", isMilitary = "Rare",
        data = {
            ammoType = 'M21Mag',
            shootSound = 'ORGMM21',
        },
    },
    ["M249"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto",
        isMilitary = "Rare",
        data = {
            ammoType = 'M249Belt',
            shootSound = 'ORGMM249',
            clickSound = 'ORGMRifleEmpty',
            ejectSound = 'ORGMLMGOut',
            insertSound = 'ORGMLMGIn',
            rackSound = 'ORGMLMGRack',
        },
    },
    ["M4C"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isPolice= "Rare", isMilitary = "Common",
        data = {
            ammoType = 'STANAGMag',
            shootSound = 'ORGMAR15',
        },
    },
    ["Marlin60"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto-IM",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_22LR',
            rackSound = 'ORGMRifleRack',
            shootSound = 'ORGMMarlin60',
            shootSoundPartial = 'ORGMMarlin60',
            clickSound = 'ORGMSmallPistolEmpty',
            insertSound = 'ORGMMagLoad',
            bulletOutSound = 'none'
        },
    },
    ["Mini14"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Common", isPolice = "Rare",
        data = {
            ammoType = 'Mini14Mag',
            shootSound = 'ORGMMini14',
        },
    },
    ["Mosin"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt-IM",
        isCivilian = "Common",
        data = {
            speedLoader = 'MosinStripperClip',
            ammoType = 'Ammo_762x54mm',
            shootSound = 'ORGMMosin',
        },
    },
    ["R25"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
        data = {
            ammoType = 'R25Mag',
            shootSound = 'ORGMAR10',
        },
    },
    ["Rem700"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt-IM",
        isCivilian = "Common", isPolice = "Rare",
        data = {
            ammoType = 'Ammo_3006Springfield',
            shootSound = 'ORGMRem700',
            shootSoundPartial = 'ORGMRem700',
        },
    },
    ["Rem788"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt",
        isCivilian = "Rare",
        data = {
            ammoType = 'Rem788Mag',
            shootSound = 'ORGMRem788',
        },
    },
    ["Rug1022"] = {
        gunType = "Auto-DAO",
        soundProfile = "Pistol-Small",
        isCivilian = "Common",
        data = {
            ammoType = 'Rug1022Mag',
            shootSound = 'ORGMRuger1022',
        },
    },
    ["SA80"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isMilitary = "Rare",
        data = {
            ammoType = 'STANAGMag',
            shootSound = 'ORGML85',
        },
    },
    ["SIG550"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isCivilian = "VeryRare",
        data = {
            ammoType = 'SIG550Mag',
            shootSound = 'ORGMSIG550',
        },
    },
    ["SIG551"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        selectFire = 1, -- 1 = full-auto, 0 = semi, nil = no select
        isCivilian = "VeryRare",
        data = {
            ammoType = 'SIG550Mag',
            shootSound = 'ORGMSIG550',
        },
    },
    ["SKS"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto-IM",
        isCivilian = "Common",
        data = {
            speedLoader = 'SKSStripperClip',
            ammoType = 'Ammo_762x39mm',
            shootSound = 'ORGMSKS',
        },
    },
    ["SR25"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isMilitary = "Common",
        data = {
            ammoType = 'SR25Mag',
            shootSound = 'ORGMAR10',
        },
    },
    ["SVD"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-Auto",
        isCivilian = "Rare",
        data = {
            ammoType = 'SVDMag',
            shootSound = 'ORGMSVD',
        },
    },
    ["WinM70"] = {
        gunType = "Bolt-SA",
        soundProfile = "Rifle-Bolt-IM",
        isCivilian = "Rare", isMilitary = "Rare",
        data = {
            ammoType = 'Ammo_3006Springfield',
            shootSound = 'ORGMWinM70',
            shootSoundPartial = 'ORGMWinM70',
        },
    },
    ["WinM94"] = {
        gunType = "Lever-DAO",
        soundProfile = "Rifle-Lever",
        isCivilian = "Rare",
        data = {
            ammoType = 'Ammo_3030Winchester',
            shootSound = 'ORGMWinM1894',
            shootSoundPartial = 'ORGMWinM1894',
        },
    },
        --************************************************************************--
        -- shotguns
        --************************************************************************--

    ["BenelliM3"] = {
        gunType = "Auto-DAO",
        soundProfile = "Shotgun",
        altActionType = "Pump",
        isPolice = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["BenelliM3SO"] = {
        gunType = "Auto-DAO",
        soundProfile = "Shotgun",
        altActionType = "Pump",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["BenelliXM1014"] = {
        gunType = "Auto-DAO",
        soundProfile = "Shotgun",
        isMilitary = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
            rackSound = 'ORGMARRack', -- override
            bulletOutSound = 'ORGMARRack' -- override
        },
    },
    ["Hawk982"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["Ithaca37"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["Ithaca37SO"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["M1216"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
        data = {
            ammoType = 'M1216Mag',
            shootSound = '12GShotgunFire',
            clickSound = 'ORGMShotgunEmpty', -- override
        },
    },
    ["Moss590"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["Moss590SO"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["Rem870"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common", isPolice = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["Rem870SO"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["Silverhawk"] = {
        gunType = "Break-SA",
        soundProfile = "Shotgun-Break",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["SilverHawkSO"] = {
        gunType = "Break-SA",
        soundProfile = "Shotgun-Break",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },
    },
    ["Spas12"] = {
        gunType = "Auto-DAO",
        soundProfile = "Shotgun",
        altActionType = "Pump",
        isCivilian = "Rare", isPolice = "Rare", isMilitary = "Rare",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = 'ORGMSPAS',
            shootSoundPartial = 'ORGMSPAS',
        },
    },
    ["Stevens320"] = {
        gunType = "Pump-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Common",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
        },

    },
    ["Striker"] = {
        gunType = "Rotary-DAO",
        soundProfile = "Shotgun",
        isCivilian = "Rare", isPolice = "Rare",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12GShotgunFire',
            shootSoundPartial = '12GShotgunFire',
            rackSound = 'ORGMARRack', -- override
        },
    },
    ["VEPR12"] = {
        gunType = "Auto-DAO",
        soundProfile = "Rifle-AR",
        isCivilian = "Rare",
        data = {
            ammoType = 'VEPR12Mag',
            shootSound = '12GShotgunFire',
            clickSound = 'ORGMShotgunEmpty', -- override
        },
    },
    ["Win1887"] = {
        gunType = "Lever-DAO",
        soundProfile = "Shotgun-Lever",
        isCivilian = "VeryRare",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12gFire',
            shootSoundPartial = '12gFire',
        },
    },
    ["Win1887SO"] = {
        gunType = "Lever-DAO",
        soundProfile = "Shotgun-Lever",
        data = {
            ammoType = 'Ammo_12g',
            shootSound = '12gFire',
            shootSoundPartial = '12gFire',
        },
    },
}

-- setup all magazines
for name, info in pairs(ORGMMasterMagTable) do
    local data = info.data
    data.type = name
    data.moduleName = "ORGM"
    data.reloadClass = "ISORGMMagazine"
    data.clipType = name
    data.shootSound = 'none'
    data.clickSound = nil
    if data.ejectSound == nil then data.ejectSound = 'ORGMMagLoad' end
    if data.insertSound == nil then data.insertSound = 'ORGMMagLoad' end
    if data.rackSound == nil then data.rackSound = 'ORGMMagLoad' end
    data.containsClip = 0
    if data.reloadTime == nil then data.reloadTime = 30 end
    data.rackTime = 10
    ReloadUtil:addMagazineType(data)
end

-- setup all guns
for name, info in pairs(ORGMMasterWeaponTable) do
    -- check the weapon type
    local data = info.data
    data.type = name
    data.moduleName = "ORGM"
    data.reloadClass = 'ISORGMWeapon'
    if data.rackTime == nil then data.rackTime = 10 end
    if data.reloadTime == nil then data.reloadTime = 15 end

    -- apply any defaults from the SoundProfiles table
    if (info.soundProfile and SoundProfiles[info.soundProfile]) then
        local profile = SoundProfiles[info.soundProfile]
        for key, value in pairs(profile) do
            if data[key] == nil then data[key] = value end
        end
    else
        print("*** WARNING: ORGM.".. name .. " has invalid soundProfile (ORGMReloadUtil.lua)")
    end

    -- apply any defaults from the GunTypes table
    if (info.gunType and GunTypes[info.gunType]) then
        local gtype = GunTypes[info.gunType]
        for key, value in pairs(gtype) do
            if data[key] == nil then data[key] = value end
        end
    else
        print("*** WARNING: ORGM.".. name .. " has invalid gunType (ORGMReloadUtil.lua)")
    end
    
    if info.altActionType then -- this gun has alternating action types (pump and auto, etc)
        data.altActionType = {data.actionType, info.altActionType}
    end
    if info.selectFire then data.selectFire = info.selectFire end
    -- check if gun uses a mag, and link clipData
    -- TODO: there should be error checking here in case of typos.
    local mag = ORGMMasterMagTable[data.ammoType] 
    if mag then
        data.clipName = mag.name
        data.clipIcon = mag.icon
        data.clipData = mag.data
        data.containsClip = 1
    end
    data.isOpen = 0
    data.hammerCocked = 0

    -- TODO: there should also be some strict error checking here insuring all required variables are set.
    ReloadUtil:addWeaponType(data)
end

--[[- This file contains all default magazine data.

All calls made by this script are to `ORGM.Magazine.register`. See the documention there.

@script ORGMData_Magazine.lua
@author Fenris_Wolf
@release 3.09
@copyright 2018 **File:** shared/4DataFiles/ORGMData_Magazine.lua

]]
local Magazine = ORGM.Magazine
local MagazineGroup = Magazine.MagazineGroup
local MagazineType = Magazine.MagazineType
local Flags = Magazine.Flags

MagazineGroup:new("MagGroup_STANAG")

MagazineGroup:new("MagGroup_AutomagV")
MagazineType:new("Mag_AutomagV_x5", {
    Groups = { MagGroup_AutomagV = 1 },
    ammoType = "AmmoGroup_50AE",
    maxCapacity = 5,
    features = Flags.BOX,
    Weight = 0.2,
    Icon = "Mag_AutomagV",
})
MagazineGroup:new("MagGroup_Beretta_92_early")
MagazineType:new("Mag_Beretta_92_early_x15", {
    Groups = { MagGroup_Beretta_92_early = 1 },
    ammoType = "AmmoGroup_9x19mm",
    maxCapacity = 15,
    features = Flags.BOX,
    Weight = 0.2,
    Icon = "Mag_Beretta_92",
})

MagazineGroup:new("MagGroup_Beretta_92")
MagazineType:newCollection("Mag_Beretta_92", {
        ammoType = 'AmmoGroup_9x19mm',
        Icon = "Mag_Beretta_92",
    },{
        x15 = {
            features = Flags.BOX,
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Beretta_92 = 1 },
        },
        x32 = {
            features = Flags.BOX,
            maxCapacity = 32,
            Weight = 0.2,
            Groups = { MagGroup_Beretta_92 = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_BrenTen")
MagazineType:new("Mag_BrenTen_x12", {
    Groups = { MagGroup_BrenTen = 1 },
    ammoType = "AmmoGroup_10x25mm",
    maxCapacity = 12,
    features = Flags.BOX,
    Weight = 0.2,
    Icon = "Mag_BrenTen",
})
MagazineGroup:new("MagGroup_Browning_HiPower")
MagazineType:newCollection("Mag_Browning_HiPower", {
    ammoType = 'AmmoGroup_9x19mm',
    Icon = "Mag_Browning_HiPower",
    },{
        x13 = {
            features = Flags.BOX,
            maxCapacity = 13,
            Weight = 0.2,
            Groups = { MagGroup_Browning_HiPower = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_1911")
MagazineType:newCollection("Mag_1911", {
    ammoType = 'AmmoGroup_45ACP',
    Icon = "Mag_1911",
    },{
        x7 = {
            features = Flags.BOX,
            maxCapacity = 7,
            Weight = 0.2,
            Groups = { MagGroup_1911 = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_1911_9x19mm")
MagazineType:newCollection("Mag_1911_9x19mm", {
    ammoType = 'AmmoGroup_9x19mm',
    Icon = "Mag_1911_9x19mm",
    },{
        x9 = {
            features = Flags.BOX,
            maxCapacity = 9,
            Weight = 0.2,
            Groups = { MagGroup_1911 = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_1911_10x25mm")
MagazineType:newCollection("Mag_1911_10x25mm", {
    ammoType = 'AmmoGroup_10x25mm',
    Icon = "Mag_1911_10x25mm",
    },{
        x9 = {
            features = Flags.BOX,
            maxCapacity = 9,
            Weight = 0.2,
            Groups = { MagGroup_1911_10x25mm = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_1911_38Super")
MagazineType:newCollection("Mag_1911_38Super", {
    ammoType = 'AmmoGroup_38Super',
    Icon = "Mag_1911_38Super",
    },{
        x9 = {
            features = Flags.BOX,
            maxCapacity = 9,
            Weight = 0.2,
            Groups = { MagGroup_1911_38Super = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_CZ75_9x19mm")
MagazineType:newCollection("Mag_CZ75_9x19mm", {
    ammoType = 'AmmoGroup_9x19mm',
    Icon = "Mag_CZ75",
    },{
        x15 = {
            features = Flags.BOX,
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_CZ75_9x19mm = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_DesertEagle_44Magnum")
MagazineType:newCollection("Mag_DesertEagle_44Magnum", {
    ammoType = 'AmmoGroup_44Magnum',
    Icon = "Mag_DesertEagle_44Magnum",
    },{
        x8 = {
            features = Flags.BOX,
            maxCapacity = 8,
            Weight = 0.2,
            Groups = { MagGroup_DesertEagle_44Magnum = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_DesertEagle_50AE")
MagazineType:newCollection("Mag_DesertEagle_50AE", {
    ammoType = 'AmmoGroup_50AE',
    Icon = "Mag_DesertEagle_50AE",
    },{
        x7 = {
            features = Flags.BOX,
            maxCapacity = 7,
            Weight = 0.2,
            Groups = { MagGroup_DesertEagle_50AE = 1 },
        },
    }
)

MagazineGroup:new("MagGroup_FN57")
MagazineType:newCollection("Mag_FN57", {
    ammoType = 'AmmoGroup_57x25mm',
    Icon = "Mag_FN57",
    },{
        x20 = {
            features = Flags.BOX,
            maxCapacity = 20,
            Weight = 0.2,
            Groups = { MagGroup_FN57 = 1 },
        },
    }
)

MagazineGroup:new("MagGroup_Glock_9x19mm")
MagazineType:newCollection("Mag_Glock_9x19mm", {
    ammoType = 'AmmoGroup_9x19mm',
    Icon = "Mag_Glock_9x19mm",
    },{
        x10 = {
            features = Flags.BOX,
            maxCapacity = 10,
            Weight = 0.2,
            Groups = { MagGroup_Glock_9x19mm = 1 },
        },
        x17 = {
            features = Flags.BOX,
            maxCapacity = 17,
            Weight = 0.2,
            Groups = { MagGroup_Glock_9x19mm = 1 },
        },
        Gen1_x17 = { -- tends to stick/buldge
            features = Flags.BOX,
            maxCapacity = 17,
            Weight = 0.2,
            Groups = { MagGroup_Glock_9x19mm = 1 },
        },
        x33 = {
            features = Flags.BOX,
            maxCapacity = 33,
            Weight = 0.2,
            Groups = { MagGroup_Glock_9x19mm = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_Glock_10x25mm")
MagazineType:newCollection("Mag_Glock_10x25mm", {
    ammoType = 'AmmoGroup_10x25mm',
    Icon = "Mag_Glock_10x25mm",
    },{
        x10 = {
            features = Flags.BOX,
            maxCapacity = 10,
            Weight = 0.2,
            Groups = { MagGroup_Glock_10x25mm = 1 },
        },
        x15 = {
            features = Flags.BOX,
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Glock_10x25mm = 1 },
        },
        Gen1_x15 = { -- tends to stick/buldge
            features = Flags.BOX,
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Glock_10x25mm = 1 },
        },
    }
)

MagazineGroup:new("MagGroup_Glock_45ACP")
MagazineType:newCollection("Mag_Glock_45ACP", {
    ammoType = 'AmmoGroup_45ACP',
    Icon = "Mag_Glock_45ACP",
    },{
        x10 = {
            features = Flags.BOX,
            maxCapacity = 10,
            Weight = 0.2,
            Groups = { MagGroup_Glock_45ACP = 1 },
        },
        x13 = {
            features = Flags.BOX,
            maxCapacity = 13,
            Weight = 0.2,
            Groups = { MagGroup_Glock_45ACP = 1 },
        },
        Gen1_x13 = { -- tends to stick/buldge
            features = Flags.BOX,
            maxCapacity = 13,
            Weight = 0.2,
            Groups = { MagGroup_Glock_45ACP = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_Glock_40SW")
MagazineType:newCollection("Mag_Glock_40SW", {
    ammoType = 'AmmoGroup_40SW',
    Icon = "Mag_Glock_40SW",
    },{
        x10 = {
            features = Flags.BOX,
            maxCapacity = 10,
            Weight = 0.2,
            Groups = { MagGroup_Glock_40SW = 1 },
        },
        x15 = {
            features = Flags.BOX,
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Glock_40SW = 1 },
        },
        Gen1_x15 = { -- tends to stick/buldge
            features = Flags.BOX,
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Glock_40SW = 1 },
        },
    }
)
MagazineGroup:new("MagGroup_Mark23")
MagazineType:newCollection("Mag_Mark23", {
    ammoType = 'AmmoGroup_45ACP',
    Icon = "Mag_Mark23",
    },{
        x12 = {
            features = Flags.BOX,
            maxCapacity = 12,
            Weight = 0.2,
            Groups = { MagGroup_Mark23 = 1 },
        },
    }
)

MagazineGroup:new("MagGroup_Kahr_CT_Series")
MagazineGroup:new("MagGroup_Kahr_P_Series")

MagazineGroup:new("MagGroup_Ruger_MarkII")
MagazineGroup:new("MagGroup_Ruger_SR9")



MagazineGroup:new("MagGroup_AIAW_308", {ammoType = 'AmmoGroup_308Winchester'})
MagazineGroup:new("MagGroup_AIAW_300", {ammoType = 'AmmoGroup_308Winchester'})

MagazineType:newCollection("Mag_STANAG", {
        ammoType = 'AmmoGroup_556x45mm',
        Icon = "STANAGMag",
    },{
        x5 = {
            features = Flags.BOX,
            maxCapacity = 5,
            Weight = 0.2,
            Groups = { MagGroup_STANAG = 10 },
        },
        x10 = {
            features = Flags.BOX,
            maxCapacity = 10,
            Weight = 0.2,
            Groups = { MagGroup_STANAG = 15 },
        },
        x20 = {
            features = Flags.BOX,
            maxCapacity = 20,
            Weight = 0.2,
            Groups = { MagGroup_STANAG = 20 },
        },
        x30 = {
            features = Flags.BOX,
            maxCapacity = 30,
            Weight = 0.2,
            Groups = { MagGroup_STANAG = 40 },
        },
        x40 = {
            features = Flags.BOX,
            maxCapacity = 40,
            Weight = 0.2,
            Groups = { MagGroup_STANAG = 10 },
        },
        x50 = {
            features = Flags.BOX,
            maxCapacity = 50,
            Weight = 0.2,
            Groups = { MagGroup_STANAG = 4 },
        },
        x60 = {
            features = Flags.CASKET,
            maxCapacity = 60,
            Weight = 0.2,
            Groups = { MagGroup_STANAG = 2 },
        },
        x100 = {
            features = Flags.CASKET,
            maxCapacity = 100,
            Weight = 0.2,
            Groups = { MagGroup_STANAG = 1 },
        },
    }
)

--[[


register("AIAW308Mag",
    { ammoType = 'AmmoGroup_308Winchester', maxCapacity = 5, }
)
register("AKMMag",
    { ammoType = 'AmmoGroup_762x39mm', maxCapacity = 30, }
)
register("AM180Mag",
    { ammoType = 'AmmoGroup_22LR', maxCapacity = 177, }
)
register("AR10Mag",
    { ammoType = 'AmmoGroup_762x51mm', maxCapacity = 20, }
)
register("BLRMag",
    { ammoType = 'AmmoGroup_308Winchester', maxCapacity = 4, }
)
register("FNFALAMag",
    { ammoType = 'AmmoGroup_762x51mm', maxCapacity = 20, }
)
register("FNFALMag",
    { ammoType = 'AmmoGroup_308Winchester', maxCapacity = 20, }
)
register("FNP90Mag",
    { ammoType = 'AmmoGroup_57x28mm', maxCapacity = 50, }
)
register("GarandClip",
    { ammoType = 'AmmoGroup_3006Springfield', maxCapacity = 8, }
)
register("HK91Mag",
    { ammoType = 'AmmoGroup_308Winchester', maxCapacity = 20, }
)
register("HKG3Mag",
    { ammoType = 'AmmoGroup_762x51mm', maxCapacity = 20, }
)
register("HKMK23Mag",
    { ammoType = 'AmmoGroup_45ACP', maxCapacity = 12, }
)
register("HKMP5Mag",
    { ammoType = 'AmmoGroup_9x19mm', maxCapacity = 30, }
)
register("HKSL8Mag",
    { ammoType = 'AmmoGroup_223Remington', maxCapacity = 10, }
)
register("HKUMPMag",
    { ammoType = 'AmmoGroup_45ACP', maxCapacity = 25, }
)
register("KahrCT40Mag",
    { ammoType = 'AmmoGroup_40SW', maxCapacity = 7, }
)
register("KahrP380Mag",
    { ammoType = 'AmmoGroup_380ACP', maxCapacity = 6, }
)
register("KTP32Mag",
    { ammoType = 'AmmoGroup_32ACP', maxCapacity = 7, }
)
register("L96Mag",
    { ammoType = 'AmmoGroup_762x51mm', maxCapacity = 5, }
)
register("LENo4Mag",
    { ammoType = 'AmmoGroup_762x51mm', maxCapacity = 10, }
)
register("LENo4StripperClip",
    { ammoType = 'AmmoGroup_762x51mm', maxCapacity = 5, }
)
register("M1216Mag",
    { ammoType = 'AmmoGroup_12g', maxCapacity = 16, ejectSound = 'ORGMShotgunRoundIn', insertSound = 'ORGMShotgunRoundIn', }
)
register("M1903StripperClip",
    { ammoType = 'AmmoGroup_3006Springfield', maxCapacity = 5, }
)
register("M1911Mag",
    { ammoType = 'AmmoGroup_45ACP', maxCapacity = 7, }
)
register("M1A1Mag",
    { ammoType = 'AmmoGroup_45ACP', maxCapacity = 30, }
)
register("M21Mag",
    { ammoType = 'AmmoGroup_762x51mm', maxCapacity = 20, }
)
register("M249Belt",
    { ammoType = 'AmmoGroup_556x45mm', maxCapacity = 200, }
)
register("Mac10Mag",
    { ammoType = 'AmmoGroup_45ACP', maxCapacity = 30, }
)
register("Mac11Mag",
    { ammoType = 'AmmoGroup_380ACP', maxCapacity = 32, }
)
register("Mini14Mag",
    { ammoType = 'AmmoGroup_223Remington', maxCapacity = 20, }
)
register("MosinStripperClip",
    { ammoType = 'AmmoGroup_762x54mm', maxCapacity = 5, }
)
register("R25Mag",
    { ammoType = 'AmmoGroup_308Winchester', maxCapacity = 4, }
)
register("Rem788Mag",
    { ammoType = 'AmmoGroup_3030Winchester', maxCapacity = 3, }
)
register("Rug1022Mag",
    { ammoType = 'AmmoGroup_22LR', maxCapacity = 25, }
)
register("RugerMKIIMag",
    { ammoType = 'AmmoGroup_22LR', maxCapacity = 10, }
)
register("RugerSR9Mag",
    { ammoType = 'AmmoGroup_9x19mm', maxCapacity = 17, }
)
register("SIG550Mag",
    { ammoType = 'AmmoGroup_556x45mm', maxCapacity = 30, }
)
register("SIGP226Mag",
    { ammoType = 'AmmoGroup_40SW', maxCapacity = 12, }
)
register("SkorpionMag",
    { ammoType = 'AmmoGroup_32ACP', maxCapacity = 20, }
)
register("SKSStripperClip",
    { ammoType = 'AmmoGroup_762x39mm', maxCapacity = 10, }
)
register("SpeedLoader10mm6",
    { ammoType = 'AmmoGroup_10x25mm', maxCapacity = 6, }
)
register("SpeedLoader3576",
    { ammoType = 'AmmoGroup_357Magnum', maxCapacity = 6, }
)
register("SpeedLoader385",
    { ammoType = 'AmmoGroup_38Special', maxCapacity = 5, }
)
register("SpeedLoader386",
    { ammoType = 'AmmoGroup_38Special', maxCapacity = 6, }
)
register("SpeedLoader446",
    { ammoType = 'AmmoGroup_44Magnum', maxCapacity = 6, }
)
register("SpeedLoader4546",
    { ammoType = 'AmmoGroup_454Casull', maxCapacity = 6, }
)
register("SpeedLoader456",
    { ammoType = 'AmmoGroup_45ACP', maxCapacity = 6, }
)
register("SpeedLoader45C6",
    { ammoType = 'AmmoGroup_45Colt', maxCapacity = 6, }
)
register("Spr19119Mag",
    { ammoType = 'AmmoGroup_9x19mm', maxCapacity = 9, }
)
register("SR25Mag",
    { ammoType = 'AmmoGroup_762x51mm', maxCapacity = 20, }
)
register("STANAGMag",
    { ammoType = 'AmmoGroup_556x45mm', maxCapacity = 30, }
)
register("SVDMag",
    { ammoType = 'AmmoGroup_762x54mm', maxCapacity = 10, }
)
register("Taurus38Mag",
    { ammoType = 'AmmoGroup_38Super', maxCapacity = 10, }
)
register("TaurusP132Mag",
    { ammoType = 'AmmoGroup_32ACP', maxCapacity = 10, }
)
register("UziMag",
    { ammoType = 'AmmoGroup_9x19mm', maxCapacity = 32, }
)
register("VEPR12Mag",
    { ammoType = 'AmmoGroup_12g', maxCapacity = 8, ejectSound = 'ORGMShotgunRoundIn', insertSound = 'ORGMShotgunRoundIn', }
)
register("WaltherP22Mag",
    { ammoType = 'AmmoGroup_22LR', maxCapacity = 10, }
)
register("WaltherPPKMag",
    { ammoType = 'AmmoGroup_380ACP', maxCapacity = 6, }
)
register("XD40Mag",
    { ammoType = 'AmmoGroup_40SW', maxCapacity = 9, }
)
]]
-- ORGM[14] = "353134363"
ORGM.log(ORGM.INFO, "All default magazines registered.")

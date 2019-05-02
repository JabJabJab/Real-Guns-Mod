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
MagazineGroup:new("MagGroup_Pistols")
MagazineGroup:new("MagGroup_SubMachineGuns")


MagazineGroup:new("MagGroup_AutomagV",              { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Beretta_92_early",      { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Beretta_92",            { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_BrenTen",               { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Browning_HiPower",      { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_1911",                  { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_1911_9x19mm",           { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_1911_10x25mm",          { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_1911_38Super",          { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_CZ75_9x19mm",           { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_DesertEagle_44Magnum",  { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_DesertEagle_50AE",      { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_FN57",                  { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Glock_9x19mm",          { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Glock_10x25mm",         { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Glock_45ACP",           { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Glock_40SW",            { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Mark23",                { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_CT45",                  { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_CT380",                 { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_CT9",                   { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_CT40",                  { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Kahr_P_Series",         { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_KalTec_P32",            { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Ruger_MarkII",          { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Ruger_SR_Series",       { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_SigSauer_P226",         { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Springfield_XD",        { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Taurus_PT38S",          { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_Taurus_Millennium_38Super", { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_P22",                   { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_PP",                    { Groups = { MagGroup_Pistols = 1 } })
MagazineGroup:new("MagGroup_PPK",                   { Groups = { MagGroup_Pistols = 1 } })

MagazineGroup:new("MagGroup_AM180",                 { Groups = { MagGroup_SubMachineGuns = 1 } })
MagazineGroup:new("MagGroup_FNP90",                 { Groups = { MagGroup_SubMachineGuns = 1 } })
MagazineGroup:new("MagGroup_Thompson",              { Groups = { MagGroup_SubMachineGuns = 1 } })
MagazineGroup:new("MagGroup_Mac10_45ACP",           { Groups = { MagGroup_SubMachineGuns = 1 } })
MagazineGroup:new("MagGroup_Mac10_9x19mm",          { Groups = { MagGroup_SubMachineGuns = 1 } })
MagazineGroup:new("MagGroup_Mac11_380ACP",          { Groups = { MagGroup_SubMachineGuns = 1 } })
MagazineGroup:new("MagGroup_Uzi_45ACP",            { Groups = { MagGroup_SubMachineGuns = 1 } })
MagazineGroup:new("MagGroup_Uzi_9x19mm",            { Groups = { MagGroup_SubMachineGuns = 1 } })



MagazineType:new("Mag_AutomagV_x5", {
    Groups = { MagGroup_AutomagV = 1 },
    ammoType = "AmmoGroup_50AE",
    maxCapacity = 5,
    features = Flags.BOX,
    Weight = 0.2,
    Icon = "Mag_AutomagV",
})
MagazineType:new("Mag_Beretta_92_early_x15", {
    Groups = { MagGroup_Beretta_92_early = 1 },
    ammoType = "AmmoGroup_9x19mm",
    maxCapacity = 15,
    features = Flags.BOX,
    Weight = 0.2,
    Icon = "Mag_Beretta_92",
})
MagazineType:newCollection("Mag_Beretta_92", {
        ammoType = 'AmmoGroup_9x19mm',
        Icon = "Mag_Beretta_92",
        features = Flags.BOX,
    },{
        x15 = {
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Beretta_92 = 4 },
        },
        x32 = {
            maxCapacity = 32,
            Weight = 0.3,
            Groups = { MagGroup_Beretta_92 = 1 },
        },
    }
)
MagazineType:new("Mag_BrenTen_x12", {
    Groups = { MagGroup_BrenTen = 1 },
    ammoType = "AmmoGroup_10x25mm",
    maxCapacity = 12,
    features = Flags.BOX,
    Weight = 0.2,
    Icon = "Mag_BrenTen",
})
MagazineType:newCollection("Mag_Browning_HiPower", {
    ammoType = 'AmmoGroup_9x19mm',
    Icon = "Mag_Browning_HiPower",
    features = Flags.BOX,
    },{
        x13 = {
            maxCapacity = 13,
            Weight = 0.2,
            Groups = { MagGroup_Browning_HiPower = 1 },
        },
    }
)
MagazineType:newCollection("Mag_1911", {
    ammoType = 'AmmoGroup_45ACP',
    Icon = "Mag_1911",
    features = Flags.BOX,
    },{
        x7 = {
            maxCapacity = 7,
            Weight = 0.2,
            Groups = { MagGroup_1911 = 1 },
        },
    }
)
MagazineType:newCollection("Mag_1911_9x19mm", {
    ammoType = 'AmmoGroup_9x19mm',
    Icon = "Mag_1911_9x19mm",
    features = Flags.BOX,
    },{
        x9 = {
            maxCapacity = 9,
            Weight = 0.2,
            Groups = { MagGroup_1911_9x19mm = 1 },
        },
    }
)
MagazineType:newCollection("Mag_1911_10x25mm", {
    ammoType = 'AmmoGroup_10x25mm',
    Icon = "Mag_1911_10x25mm",
    features = Flags.BOX,
    },{
        x9 = {
            maxCapacity = 9,
            Weight = 0.2,
            Groups = { MagGroup_1911_10x25mm = 1 },
        },
    }
)
MagazineType:newCollection("Mag_1911_38Super", {
    ammoType = 'AmmoGroup_38Super',
    Icon = "Mag_1911_38Super",
    features = Flags.BOX,
    },{
        x9 = {
            maxCapacity = 9,
            Weight = 0.2,
            Groups = { MagGroup_1911_38Super = 1 },
        },
    }
)
MagazineType:newCollection("Mag_CZ75_9x19mm", {
    ammoType = 'AmmoGroup_9x19mm',
    Icon = "Mag_CZ75",
    features = Flags.BOX,
    },{
        x15 = {
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_CZ75_9x19mm = 1 },
        },
    }
)
MagazineType:newCollection("Mag_DesertEagle_44Magnum", {
    ammoType = 'AmmoGroup_44Magnum',
    Icon = "Mag_DesertEagle_44Magnum",
    features = Flags.BOX,
    },{
        x8 = {
            maxCapacity = 8,
            Weight = 0.2,
            Groups = { MagGroup_DesertEagle_44Magnum = 1 },
        },
    }
)
MagazineType:newCollection("Mag_DesertEagle_50AE", {
    ammoType = 'AmmoGroup_50AE',
    Icon = "Mag_DesertEagle_50AE",
    features = Flags.BOX,
    },{
        x7 = {
            maxCapacity = 7,
            Weight = 0.2,
            Groups = { MagGroup_DesertEagle_50AE = 1 },
        },
    }
)
MagazineType:newCollection("Mag_FN57", {
    ammoType = 'AmmoGroup_57x25mm',
    Icon = "Mag_FN57",
    features = Flags.BOX,
    },{
        x20 = {
            maxCapacity = 20,
            Weight = 0.2,
            Groups = { MagGroup_FN57 = 1 },
        },
    }
)
MagazineType:newCollection("Mag_Glock_9x19mm", {
    ammoType = 'AmmoGroup_9x19mm',
    Icon = "Mag_Glock_9x19mm",
    features = Flags.BOX,
    },{
        x10 = {
            maxCapacity = 10,
            Weight = 0.2,
            Groups = { MagGroup_Glock_9x19mm = 3 },
        },
        x17 = {
            maxCapacity = 17,
            Weight = 0.2,
            Groups = { MagGroup_Glock_9x19mm = 4 },
        },
        Gen1_x17 = { -- tends to stick/buldge
            maxCapacity = 17,
            Weight = 0.2,
            Groups = { MagGroup_Glock_9x19mm = 2 },
        },
        x33 = {
            maxCapacity = 33,
            Weight = 0.2,
            Groups = { MagGroup_Glock_9x19mm = 1 },
        },
    }
)
MagazineType:newCollection("Mag_Glock_10x25mm", {
    ammoType = 'AmmoGroup_10x25mm',
    Icon = "Mag_Glock_10x25mm",
    features = Flags.BOX,
    },{
        x10 = {
            maxCapacity = 10,
            Weight = 0.2,
            Groups = { MagGroup_Glock_10x25mm = 1 },
        },
        x15 = {
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Glock_10x25mm = 1 },
        },
        Gen1_x15 = { -- tends to stick/buldge
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Glock_10x25mm = 1 },
        },
    }
)
MagazineType:newCollection("Mag_Glock_45ACP", {
    ammoType = 'AmmoGroup_45ACP',
    Icon = "Mag_Glock_45ACP",
    features = Flags.BOX,
    },{
        x10 = {
            maxCapacity = 10,
            Weight = 0.2,
            Groups = { MagGroup_Glock_45ACP = 1 },
        },
        x13 = {
            maxCapacity = 13,
            Weight = 0.2,
            Groups = { MagGroup_Glock_45ACP = 1 },
        },
        x30 = { -- extended version for the kriss vector
            maxCapacity = 30,
            Weight = 0.2,
            Groups = { MagGroup_Glock_45ACP = 1 },
        },
        Gen1_x13 = { -- tends to stick/buldge
            maxCapacity = 13,
            Weight = 0.2,
            Groups = { MagGroup_Glock_45ACP = 1 },
        },
    }
)
MagazineType:newCollection("Mag_Glock_40SW", {
    ammoType = 'AmmoGroup_40SW',
    Icon = "Mag_Glock_40SW",
    features = Flags.BOX,
    },{
        x10 = {
            maxCapacity = 10,
            Weight = 0.2,
            Groups = { MagGroup_Glock_40SW = 1 },
        },
        x15 = {
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Glock_40SW = 1 },
        },
        Gen1_x15 = { -- tends to stick/buldge
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Glock_40SW = 1 },
        },
    }
)
MagazineType:newCollection("Mag_Mark23", {
    ammoType = 'AmmoGroup_45ACP',
    Icon = "Mag_Mark23",
    features = Flags.BOX,
    },{
        x12 = {
            maxCapacity = 12,
            Weight = 0.2,
            Groups = { MagGroup_Mark23 = 1 },
        },
    }
)
MagazineType:new("Mag_CT380_x7", {
    Icon = "Mag_Kahr_CT_Series",
    features = Flags.BOX,
    ammoType = 'AmmoGroup_380ACP',
    maxCapacity = 7,
    Groups = { MagGroup_CT380 = 1 },
    Weight = 0.2, -- 0.059534 empty
})
MagazineType:new("Mag_CT40_x7", {
    Icon = "Mag_Kahr_CT_Series",
    features = Flags.BOX,
    ammoType = 'AmmoGroup_40SW',
    maxCapacity = 7,
    Groups = { MagGroup_CT40 = 1 },
    Weight = 0.2, -- 0.059534 empty
})
MagazineType:new("Mag_CT9_x8", {
    Icon = "Mag_Kahr_CT_Series",
    features = Flags.BOX,
    ammoType = 'AmmoGroup_9x19mm',
    maxCapacity = 8,
    Groups = { MagGroup_CT9 = 1 },
    Weight = 0.2, -- 0.059534 empty
})
MagazineType:new("Mag_CT45_x7", {
    Icon = "Mag_Kahr_CT_Series",
    features = Flags.BOX,
    ammoType = 'AmmoGroup_45ACP',
    maxCapacity = 7,
    Groups = { MagGroup_CT45 = 1 },
    Weight = 0.2, -- 2.4oz mag (0.068) empty
})


--




MagazineGroup:new("MagGroup_AIAW_308", {ammoType = 'AmmoGroup_308Winchester'})
--MagazineGroup:new("MagGroup_AIAW_300", {ammoType = 'AmmoGroup_308Winchester'})

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

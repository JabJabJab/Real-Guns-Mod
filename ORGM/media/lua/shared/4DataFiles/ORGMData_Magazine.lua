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

MagazineGroup:new("MagGroup_STANAG", {ammoType = 'AmmoGroup_556x45mm'})

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
register("AutomagVMag",
    { ammoType = 'AmmoGroup_50AE', maxCapacity = 5, }
)
register("BBPistolMag",
    { ammoType = 'AmmoGroup_177BB', maxCapacity = 35, }
)
register("Ber92Mag",
    { ammoType = 'AmmoGroup_9x19mm', maxCapacity = 15, }
)
register("Ber93RMag",
    { ammoType = 'AmmoGroup_9x19mm', maxCapacity = 32, }
)
register("BLRMag",
    { ammoType = 'AmmoGroup_308Winchester', maxCapacity = 4, }
)
register("BrenTenMag",
    { ammoType = 'AmmoGroup_10x25mm', maxCapacity = 12, }
)
register("BrownHPMag",
    { ammoType = 'AmmoGroup_9x19mm', maxCapacity = 13, }
)
register("Colt38SMag",
    { ammoType = 'AmmoGroup_38Super', maxCapacity = 9, }
)
register("ColtDeltaMag",
    { ammoType = 'AmmoGroup_10x25mm', maxCapacity = 8, }
)
register("CZ75Mag",
    { ammoType = 'AmmoGroup_9x19mm', maxCapacity = 15, }
)
register("DEagleMag",
    { ammoType = 'AmmoGroup_44Magnum', maxCapacity = 8, }
)
register("DEagleXIXMag",
    { ammoType = 'AmmoGroup_50AE', maxCapacity = 7, }
)
register("FN57Mag",
    { ammoType = 'AmmoGroup_57x28mm', maxCapacity = 20, }
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
register("Glock17Mag",
    { ammoType = 'AmmoGroup_9x19mm', maxCapacity = 17, }
)
register("Glock20Mag",
    { ammoType = 'AmmoGroup_10x25mm', maxCapacity = 15, }
)
register("Glock21Mag",
    { ammoType = 'AmmoGroup_45ACP', maxCapacity = 13, }
)
register("Glock22Mag",
    { ammoType = 'AmmoGroup_40SW', maxCapacity = 15, }
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

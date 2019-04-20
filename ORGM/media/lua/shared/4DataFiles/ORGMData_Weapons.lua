--[[- This file contains all default firearm data.

All calls made by this script are to `ORGM.Firearm.register`. See the documention there.

@script ORGMData_Weapons.lua
@author Fenris_Wolf
@release 3.10
@copyright 2018 **File:** shared/4DataFiles/ORGMData_Weapons.lua

]]
local register = ORGM.Firearm.register
local Flags = ORGM.Firearm.Flags

register("M16", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1964,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_M16",
})

--[[
register("ColtAnac", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 6,
    barrelLengthOpt =  {4, 6, 8},
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader446',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1990,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_ColtAnac",
})
register("ColtPyth", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 6,
    barrelLengthOpt = { 2.5, 3, 4, 6, 8},
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader3576',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1955,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_ColtPyth",
})
register("ColtSAA", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 5.5,
    barrelLengthOpt = {5.5, 7.5 },
    isCivilian = ORGM.RARE,
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1873,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_ColtSAA",
})
register("RugAlas", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 2.5,
    barrelLengthOpt = { 2.5, 7.5, 9.5 },
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader4546',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 2005,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugAlas",
})
register("RugBH", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 4.65,
    barrelLengthOpt = { 4.65, 6.5, 7.5 },
    isCivilian = ORGM.RARE,
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1955,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugBH",
})
register("RugGP100", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 4.2,
    barrelLengthOpt = { 3, 4.2, 6 },
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader3576',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1985,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugGP100",
})
register("RugRH", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 5.5,
    barrelLengthOpt = { 4, 5.5, 7.5 },
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader446',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1979,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugRH",
})
register("RugSec6", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 4,
    barrelLengthOpt = {2.74, 3, 4, 6},
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader386',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1972,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugSec6",
})
register("SWM10", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 4,
    barrelLengthOpt = {2, 2.5, 3, 4, 5, 6},
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.VERYRARE, -- old armory stock
    speedLoader = 'SpeedLoader386',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1899,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM10",
})
register("SWM19", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 4,
    barrelLengthOpt = {2.5, 3, 4, 6},
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader3576',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1957,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM19",
})
register("SWM252", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 6, -- 4, 5 (very rare!), 6, 6.5, 8.4
    barrelLengthOpt = {4, 5, 6, 6.5, 8.4},
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader456',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1955,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM252",
})
register("SWM29", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 6, -- 4, 6, 6.5, 8.425, 10.63
    barrelLengthOpt = { 4, 6, 6.5, 8.425, 10.63 },
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader446',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1955,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM29",
})
register("SWM36", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 1.875,
    barrelLengthOpt = { 1.875, 2, 3 },
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader385',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1950,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM36",
})
register("SWM610", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 6.5, -- 3.875, 6.5
    barrelLengthOpt = { 3.875, 6.5 },
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader10mm6',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1990,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM610",
})
register("Taurus454", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 25,
    category = ORGM.REVOLVER,
    barrelLength = 6.5, -- 2.25, 3, 4, 5, 6, 6.5, 8.425, 10
    barrelLengthOpt = { 2.25, 3, 4, 5, 6, 6.5, 8.425, 10 },
    isCivilian = ORGM.RARE,
    --speedLoader = 'SpeedLoader4546',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1997,
    country = "IGUI_Firearm_Country_BR",
    manufacturer = "IGUI_Firearm_Manuf_Taurus",
    description = "IGUI_Firearm_Desc_Taurus454",
})
    --************************************************************************--
    -- semi pistols
    --************************************************************************--
register("AutomagV", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 6.5, -- no aditional lengths
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Large",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1993,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_AMT",
    description = "IGUI_Firearm_Desc_AutomagV"
})
register("BBPistol", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 8,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_AirPistol",
    year = 2007, -- unknown, earliest reference i can find for this model dates to 2008
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Daisy",
    description = "IGUI_Firearm_Desc_BBPistol",
})
register("Ber92", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.9, -- 4.7 an 4.3 for other variants (not FS)
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.COMMON,
    isMilitary = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1975,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Beretta",
    description = "IGUI_Firearm_Desc_Ber92",
})
register("BrenTen", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 5,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1983,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Dixon",
    description = "IGUI_Firearm_Desc_BrenTen",
})
register("BrownHP", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.7,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1935,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_BrownHP",
})
register("Colt38S", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.5,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1950,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_Colt38S",
})
register("ColtDelta", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 5.03,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1987,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_ColtDelta",
})
register("CZ75", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.7,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1975,
    country = "IGUI_Firearm_Country_CZ",
    manufacturer = "IGUI_Firearm_Manuf_CZUB",
    description = "IGUI_Firearm_Desc_CZ75",
})
register("DEagle", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 10,
    barrelLengthOpt = { 6, 10, 14 },
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Large",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_USIL",
    manufacturer = "IGUI_Firearm_Manuf_IMI",
    description = "IGUI_Firearm_Desc_DEagle",
})
register("DEagleXIX", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 10,
    barrelLengthOpt = { 6, 10 },
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Large",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_USIL",
    manufacturer = "IGUI_Firearm_Manuf_IMI",
    description = "IGUI_Firearm_Desc_DEagleXIX",
})
register("FN57", {
    -- depending on model, this can be SA (FN57 Tactical)
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.8,
    isCivilian = ORGM.VERYRARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1998,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_FN57",
})
register("Glock17", {
    -- technically not quite DAO, but as close as its going to get
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.48,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock17",
})
register("Glock20", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.48,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1991,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock20",
})
register("Glock21", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.48,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1991,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock21",
})
register("Glock22", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 25,
    category = ORGM.PISTOL,
    barrelLength = 4.48,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1990,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock22",
})
register("HKMK23", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 5.87,
    isCivilian = ORGM.VERYRARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1991,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKMK23",
})
register("KahrCT40", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2014,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kahr",
    description = "IGUI_Firearm_Desc_KahrCT40",
})
register("KahrP380", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 2.53,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1999,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kahr",
    description = "IGUI_Firearm_Desc_KahrP380",
})
register("KTP32", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 2.68,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1999,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_KelTec",
    description = "IGUI_Firearm_Desc_KTP32",
})
register("M1911", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 5.03,
    isCivilian = ORGM.COMMON,
    isMilitary = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1911,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_M1911",
})
register("RugerMKII", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 6.875,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugerMKII",
})
register("RugerSR9", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.14,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2007,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugerSR9",
})
register("SIGP226", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.4,
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1983,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_SIG",
    description = "IGUI_Firearm_Desc_SIGP226",
})
register("Spr19119", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 5,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1985,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Springfield",
    description = "IGUI_Firearm_Desc_Spr19119",
})
register("Taurus38", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.25,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2005,
    country = "IGUI_Firearm_Country_BR",
    manufacturer = "IGUI_Firearm_Manuf_Taurus",
    description = "IGUI_Firearm_Desc_Taurus38",
})
register("TaurusP132", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 3.25,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2005,
    country = "IGUI_Firearm_Country_BR",
    manufacturer = "IGUI_Firearm_Manuf_Taurus",
    description = "IGUI_Firearm_Desc_TaurusP132",
})
register("WaltherP22", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 3.42, -- 5" target barrel
    barrelLengthOpt = {3.42, 5 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2002,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_Walther",
    description = "IGUI_Firearm_Desc_WaltherP22",
})
register("WaltherPPK", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 3.3,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1935,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_Walther",
    description = "IGUI_Firearm_Desc_WaltherPPK",
})
register("XD40", {
    -- striker trigger mechanism, DAO is close enough
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4, -- 3 (compact), 4 (service), or 5 (tactical)
    barrelLengthOpt = { 3, 4, 5 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1999,
    country = "IGUI_Firearm_Country_HR",
    manufacturer = "IGUI_Firearm_Manuf_HS",
    description = "IGUI_Firearm_Desc_XD40",
})
    --************************************************************************--
    -- smg/machine pistols
    --************************************************************************--

register("AM180", {
    -- not really DAO, its closer to SA, but doesnt allow for manual decocking
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 9, -- 9 or 18.5
    barrelLengthOpt = { 9, 18.5 },
    isCivilian = ORGM.VERYRARE,
    soundProfile = "SMG",
    alwaysFullAuto = true,
    ejectSound = 'ORGMSMG2Out',
    insertSound = 'ORGMSMG2In',

    classification = "IGUI_Firearm_SMG",
    year = 1972,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_AAI",
    description = "IGUI_Firearm_Desc_AM180",
})
register("Ber93R", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 4.9,
    isCivilian = ORGM.VERYRARE,
    isMilitary = ORGM.VERYRARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_MachinePistol",
    year = 1979,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Beretta",
    description = "IGUI_Firearm_Desc_Ber93R",
})
register("FNP90", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BULLPUP,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 10.4,
    isMilitary = ORGM.VERYRARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1990,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_FNP90",
})
register("Glock18", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 4.48,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_MachinePistol",
    year = 1986,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock18",
})
register("HKMP5", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.FREEFLOAT,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 8.9,
    barrelLengthOpt = { 4.5, 5.5, 5.7, 5.8, 8.9 },
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1966,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKMP5",
})
register("HKUMP", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BURST2 + Flags.FREEFLOAT,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 8,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1999,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKUMP",
})
register("Kriss", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 16,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 2009,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kriss",
    description = "IGUI_Firearm_Desc_Kriss",
})
register("KrissA", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BURST2,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 5.5, -- 5.5 or 6.5
    barrelLengthOpt = { 5.5, 6.5 },
    isCivilian = ORGM.VERYRARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 2009,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kriss",
    description = "IGUI_Firearm_Desc_KrissA",
})
register("KTPLR", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 9.25,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SMG",
    year = 2006,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_KelTec",
    description = "IGUI_Firearm_Desc_KTPLR",
})
register("M1A1", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 10.52,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1921,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_AOC",
    description = "IGUI_Firearm_Desc_M1A1",

    --skins = {'gold'},
})
register("Mac10", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.OPENBOLT,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 4.49,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1970,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_MAC",
    description = "IGUI_Firearm_Desc_Mac10",
})
register("Mac11", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.OPENBOLT,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 5.08,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_MachinePistol",
    year = 1972,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_MAC",
    description = "IGUI_Firearm_Desc_Mac11",
})
register("Skorpion", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 4.5,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Pistol-Small",
    selectFire = 1,

    classification = "IGUI_Firearm_MachinePistol",
    year = 1961,
    country = "IGUI_Firearm_Country_CZ",
    --manufacturer = "Česká zbrojovka Uherský Brod",
    manufacturer = "IGUI_Firearm_Manuf_CZUB",
    description = "IGUI_Firearm_Desc_Skorpion",
})
register("Uzi", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.OPENBOLT,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 10.2,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",
    alwaysFullAuto = true,

    classification = "IGUI_Firearm_SMG",
    year = 1950,
    country = "IGUI_Firearm_Country_IL",
    manufacturer = "IGUI_Firearm_Manuf_IMI",
    description = "IGUI_Firearm_Desc_Uzi",
})
    --************************************************************************--
    -- rifles
    --************************************************************************--
register("AIAW308", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.FREEFLOAT,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 26,
    isCivilian = ORGM.RARE,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1983,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_AI",
    description = "IGUI_Firearm_Desc_AIAW308",
})
register("AKM", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 16.3,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1982,
    country = "IGUI_Firearm_Country_CN",
    manufacturer = "IGUI_Firearm_Manuf_NORINCO",
    description = "IGUI_Firearm_Desc_AKM",

})
register("AKMA", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 16.3,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1959,
    country = "IGUI_Firearm_Country_SU",
    manufacturer = "IGUI_Firearm_Manuf_Kal",
    description = "IGUI_Firearm_Desc_AKMA",
})
register("AR10", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20.8,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_BattleRifle",
    year = 1956,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_ALCOLT",
    description = "IGUI_Firearm_Desc_AR10",
})
register("AR15", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20, -- 16 (carbine), 20 (standard), 24 (target)
    barrelLengthOpt = { 16, 20, 24 },
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.COMMON,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1963,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_AR15",
})
register("BBGun", {
    features = Flags.DOUBLEACTION,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.RIFLE,
    isCivilian = ORGM.COMMON,
    -- TODO: Barrel Length
    barrelLength = 11,
    rackTime = 3,
    soundProfile = "Rifle-Lever",
    rackSound = 'ORGMBBLever',
    clickSound = 'ORGMPistolEmpty',
    insertSound = 'ORGMMagBBLoad',

    classification = "IGUI_Firearm_AirRifle",
    year = 1940,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Daisy",
    description = "IGUI_Firearm_Desc_BBGun",
})
register("BLR", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 22, -- 16, 18, 18.5, 20, 22, 24
    barrelLengthOpt = { 16, 18, 18.5, 20, 22, 24 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Lever",

    classification = "IGUI_Firearm_LeverRifle",
    year = 1969,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Browning",
    description = "IGUI_Firearm_Desc_BLR",
})
register("FNFAL", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 21,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1982,
    country = "IGUI_Firearm_Country_AR",
    manufacturer = "IGUI_Firearm_Manuf_FMAP",
    description = "IGUI_Firearm_Desc_FNFAL",
})
register("FNFALA", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 21, -- 17.2, 18, 21
    barrelLengthOpt = { 17.2, 18, 21 },
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_BattleRifle",
    year = 1953,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_FNFALA",
})
register("Garand", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Auto",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1934,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Springfield",
    description = "IGUI_Firearm_Desc_Garand",
})
register("HenryBB", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-Lever",

    classification = "IGUI_Firearm_LeverRifle",
    year = 2001,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Henry",
    description = "IGUI_Firearm_Desc_HenryBB",
})
register("HK91", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 19.7,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1974,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HK91",
})
register("HKG3", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 17.7,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_BattleRifle",
    year = 1958,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKG3",
})
register("HKSL8", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.FREEFLOAT,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20.08,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1998,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKSL8",
})
register("L96", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.FREEFLOAT,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 26,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1982,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_AI",
    description = "IGUI_Firearm_Desc_L96",
})
register("LENo4", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 25.2,
    isCivilian = ORGM.COMMON,
    speedLoader = "LENo4StripperClip",
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1941,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_LBASS",
    description = "IGUI_Firearm_Desc_LENo4",
})
register("M16", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1964,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_M16",
})
register("M1903", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24,
    isCivilian = ORGM.RARE,
    speedLoader = 'M1903StripperClip',
    soundProfile = "Rifle-Auto-IM",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1903,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Springfield",
    description = "IGUI_Firearm_Desc_M1903",
})
register("M21", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 22,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-Auto",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1969,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RIA",
    description = "IGUI_Firearm_Desc_M21",
})
register("M249", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.FULLAUTO + Flags.OPENBOLT,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 21, -- 18 or 21
    barrelLengthOpt = { 18, 21 },
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-Auto",
    clickSound = 'ORGMRifleEmpty',
    ejectSound = 'ORGMLMGOut',
    insertSound = 'ORGMLMGIn',
    rackSound = 'ORGMLMGRack',

    classification = "IGUI_Firearm_LMG",
    year = 1979,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_FN2",
    description = "IGUI_Firearm_Desc_M249",
})
register("M4C", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 14.5,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultCarbine",
    year = 1984,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_M4C",
})
register("Marlin60", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 19, -- 19 or 22 (pre-1985)
    barrelLengthOpt = { 19, 22 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Auto-IM",
    rackSound = 'ORGMRifleRack',
    clickSound = 'ORGMSmallPistolEmpty',
    insertSound = 'ORGMMagLoad',

    classification = "IGUI_Firearm_SemiRifle",
    year = 1960,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Marlin",
    description = "IGUI_Firearm_Desc_Marlin60",
})
register("Mini14", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 18.5, -- 16.12 (tactical), 18.5, 22 (target)
    barrelLengthOpt = { 16.12, 18.5, 22 },
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1973,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_Mini14",
})
register("Mosin", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 29, -- 22.2 carbine, 26.2, 29
    barrelLengthOpt = { 22.2, 26.2, 29 },
    isCivilian = ORGM.COMMON,
    speedLoader = 'MosinStripperClip',
    soundProfile = "Rifle-Bolt-IM",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1891,
    country = "IGUI_Firearm_Country_RUSEMP",
    manufacturer = "IGUI_Firearm_Manuf_Tula",
    description = "IGUI_Firearm_Desc_Mosin",
})
register("R25", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.FREEFLOAT + Flags.NOSIGHTS,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 27,
    category = ORGM.RIFLE,
    barrelLength = 20,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 2008,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_R25",
})
register("Rem700", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24, -- varies widely from 16.5 to 26 depending on model and caliber. the .30-06's seem mostly in 24"
    barrelLengthOpt = {16.5, 18, 20, 22, 24, 26 },
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.RARE,
    soundProfile = "Rifle-Bolt-IM",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1962,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_Rem700",
})
register("Rem788", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24, -- 18.5, 22, 24
    barrelLengthOpt = { 18.5, 22, 24 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1967,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_Rem788",
})
register("Rug1022", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 18.5,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1964,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_Rug1022",
})
register("SA80", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BULLPUP,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20.4, -- 11.2, 20.4, 25.4
    barrelLengthOpt = { 11.2, 20.4, 25.4 },
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-AR",
    isBulpup = true,

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1985,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_RSAF",
    description = "IGUI_Firearm_Desc_SA80",
})
register("SIG550", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20.8,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1986,
    country = "IGUI_Firearm_Country_CH",
    manufacturer = "IGUI_Firearm_Manuf_SIG2",
    description = "IGUI_Firearm_Desc_SIG550",
})
register("SIG551", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20.8,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultCarbine",
    year = 1986,
    country = "IGUI_Firearm_Country_CH",
    manufacturer = "IGUI_Firearm_Manuf_SIG2",
    description = "IGUI_Firearm_Desc_SIG551",
})
register("SKS", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20, -- 20 or 22
    barrelLengthOpt = { 20, 22 },
    isCivilian = ORGM.COMMON,
    speedLoader = 'SKSStripperClip',
    soundProfile = "Rifle-Auto-IM",

    classification = "IGUI_Firearm_SemiCarbine",
    year = 1945,
    country = "IGUI_Firearm_Country_SU",
    manufacturer = "IGUI_Firearm_Manuf_Tula",
    description = "IGUI_Firearm_Desc_SKS",
})
register("SR25", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.FREEFLOAT + Flags.NOSIGHTS,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1990,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_KAC",
    description = "IGUI_Firearm_Desc_SR25",
})
register("SVD", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24.4,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-Auto",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1963,
    country = "IGUI_Firearm_Country_SU",
    manufacturer = "IGUI_Firearm_Manuf_Kal2",
    description = "IGUI_Firearm_Desc_SVD",
})
register("WinM70", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24, -- 22, 24, 26
    barrelLengthOpt = { 22, 24, 26 },
    isCivilian = ORGM.COMMON,
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-Bolt-IM",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1936,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_WRA",
    description = "IGUI_Firearm_Desc_WinM70",
})
register("WinM94", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Lever",

    classification = "IGUI_Firearm_LeverRifle",
    year = 1894,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_WRA",
    description = "IGUI_Firearm_Desc_WinM94",
})
    --************************************************************************--
    -- shotguns
    --************************************************************************--

register("BenelliM3", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.PUMP + Flags.AUTO + Flags.LONGRECOIL,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 22, -- 20 22, 24
    barrelLengthOpt = { 20, 22, 24 },
    isPolice = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_DualShotgun",
    year = 1989,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Benelli",
    description = "IGUI_Firearm_Desc_BenelliM3",
})
register("BenelliM3SO", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.PUMP + Flags.AUTO + Flags.LONGRECOIL,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 18, -- cant saw off much with that magazine tube, the connecting brace is very forward
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("BenelliM3").classification,
    year = ORGM.Firearm.getData("BenelliM3").year,
    country = ORGM.Firearm.getData("BenelliM3").country,
    manufacturer = ORGM.Firearm.getData("BenelliM3").manufacturer,
    description = ORGM.Firearm.getData("BenelliM3").description,
})
register("BenelliXM1014", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.LONGRECOIL,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 18.5,
    isMilitary = ORGM.COMMON,
    soundProfile = "Shotgun",
    rackSound = 'ORGMARRack',

    classification = "IGUI_Firearm_SemiShotgun",
    year = 1999,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Benelli",
    description = "IGUI_Firearm_Desc_BenelliXM1014"
})
register("Hawk982", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 18.5,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 2008,
    country = "IGUI_Firearm_Country_CN",
    manufacturer = "IGUI_Firearm_Manuf_NORINCO",
    description = "IGUI_Firearm_Desc_Hawk982",
})
register("Ithaca37", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLAMFIRE,
    feedSystem = Flags.PUMP,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 20, -- 18.5, 20, -- all the way up to 30
    barrelLengthOpt = { 18.5, 20, 22, 24, 26, 28, 30 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 1937,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ithaca",
    description = "IGUI_Firearm_Desc_Ithaca37",
})
register("Ithaca37SO", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLAMFIRE,
    feedSystem = Flags.PUMP,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 14, -- sawn off
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("Ithaca37").classification,
    year = ORGM.Firearm.getData("Ithaca37").year,
    country = ORGM.Firearm.getData("Ithaca37").country,
    manufacturer = ORGM.Firearm.getData("Ithaca37").manufacturer,
    description = ORGM.Firearm.getData("Ithaca37").description,
})
register("M1216", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 18,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiShotgun",
    year = 2012,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SRM",
    description = "IGUI_Firearm_Desc_M1216",
})
register("Moss590", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 27,
    category = ORGM.SHOTGUN,
    barrelLength = 20,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 1960,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Moss",
    description = "IGUI_Firearm_Desc_Moss590",
})
register("Moss590SO", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 27,
    category = ORGM.SHOTGUN,
    barrelLength = 18.5,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("Moss590").classification,
    year = ORGM.Firearm.getData("Moss590").year,
    country = ORGM.Firearm.getData("Moss590").country,
    manufacturer = ORGM.Firearm.getData("Moss590").manufacturer,
    description = ORGM.Firearm.getData("Moss590").description,
})
register("Rem870", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 26,
    barrelLengthOpt = {20, 22, 24, 26 },
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 1951,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_Rem870"
})
register("Rem870SO", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 14,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("Rem870").classification,
    year = ORGM.Firearm.getData("Rem870").year,
    country = ORGM.Firearm.getData("Rem870").country,
    manufacturer = ORGM.Firearm.getData("Rem870").manufacturer,
    description = ORGM.Firearm.getData("Rem870").description,
})
register("Silverhawk", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BREAK,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 28,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun-Break",

    classification = "IGUI_Firearm_DoubleShotgun",
    year = 1996,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Beretta",
    description = "IGUI_Firearm_Desc_Silverhawk",
})
register("SilverHawkSO", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BREAK,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 10,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun-Break",

    classification = ORGM.Firearm.getData("Silverhawk").classification,
    year = ORGM.Firearm.getData("Silverhawk").year,
    country = ORGM.Firearm.getData("Silverhawk").country,
    manufacturer = ORGM.Firearm.getData("Silverhawk").manufacturer,
    description = ORGM.Firearm.getData("Silverhawk").description
})
register("Spas12", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.PUMP + Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 21.5, -- 18, 19-7/8,21.5, 24 -- 21.5 is the shortest we can go with our mag tube
    barrelLengthOpt = { 21.5, 24 },
    isCivilian = ORGM.RARE,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_DualShotgun",
    year = 1979,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Luigi",
    description = "IGUI_Firearm_Desc_Spas12",
})
register("Stevens320", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 28,
    category = ORGM.SHOTGUN,
    barrelLength = 18.5,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 2012,
    country = "IGUI_Firearm_Country_CN",
    manufacturer = "IGUI_Firearm_Manuf_SA",
    description = "IGUI_Firearm_Desc_Stevens320"
})
register("Striker", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 18.5, -- 7.5, 12, 14, 18.5
    barrelLengthOpt = { 7.5, 12, 14, 18.5 },
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Shotgun",
    rackSound = 'ORGMARRack',

    classification = "IGUI_Firearm_SemiShotgun",
    year = 1983,
    country = "IGUI_Firearm_Country_ZA",
    manufacturer = "IGUI_Firearm_Manuf_ASARDI",
    description = "IGUI_Firearm_Desc_Striker",
})
register("VEPR12", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 22.44, -- 19, 22.44, 26.5
    barrelLengthOpt = { 19, 22.44, 26.5 },
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",
    clickSound = 'ORGMShotgunEmpty',

    classification = "IGUI_Firearm_SemiShotgun",
    year = 2003,
    country = "IGUI_Firearm_Country_RU",
    manufacturer = "IGUI_Firearm_Manuf_Molot",
    description = "IGUI_Firearm_Desc_VEPR12",
})
register("Win1887", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 30, -- 18, 20, 30
    barrelLengthOpt = { 18, 20, 30 },
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Shotgun-Lever",

    classification = "IGUI_Firearm_LeverShotgun",
    year = 1887,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_WRA",
    description = "IGUI_Firearm_Desc_Win1887"
})
register("Win1887SO", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 14,
    soundProfile = "Shotgun-Lever",

    classification = ORGM.Firearm.getData("Win1887").classification,
    year = ORGM.Firearm.getData("Win1887").year,
    country = ORGM.Firearm.getData("Win1887").country,
    manufacturer = ORGM.Firearm.getData("Win1887").manufacturer,
    description = ORGM.Firearm.getData("Win1887").description,
})
]]
-- ORGM[15] = "138363034"
ORGM.log(ORGM.INFO, "All default firearms registered.")

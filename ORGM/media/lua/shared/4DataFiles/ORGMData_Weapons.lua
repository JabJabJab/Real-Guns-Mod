--[[- This file contains all default firearm data.

All calls made by this script are to `ORGM.Firearm.register`. See the documention there.

@script ORGMData_Weapons.lua
@author Fenris_Wolf
@release 3.09
@copyright 2018 **File:** shared/4DataFiles/ORGMData_Weapons.lua

]]
local register = ORGM.Firearm.register

register("ColtAnac", {
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 6,
    barrelLengthOpt =  {4, 6, 8},
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader446',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1990,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_ColtAnac",
    serialnumber = "MM#####",
})
register("ColtPyth", {
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 6,
    barrelLengthOpt = { 2.5, 3, 4, 6, 8},
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader3576',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1955,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_ColtPyth",
    -- serial pattern varies by year
    serialnumber = "######"
})
register("ColtSAA", {
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 5.5,
    barrelLengthOpt = {5.5, 7.5 },
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1873,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_ColtSAA",
})
register("RugAlas", {
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 2.5,
    barrelLengthOpt = { 2.5, 7.5, 9.5 },
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 4.65,
    barrelLengthOpt = { 4.65, 6.5, 7.5 },
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1955,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugBH",
})
register("RugGP100", {
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 4.2,
    barrelLengthOpt = { 3, 4.2, 6 },
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 5.5,
    barrelLengthOpt = { 4, 5.5, 7.5 },
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 4,
    barrelLengthOpt = {2.74, 3, 4, 6},
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 4,
    barrelLengthOpt = {2, 2.5, 3, 4, 5, 6},
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 4,
    barrelLengthOpt = {2.5, 3, 4, 6},
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 6, -- 4, 5 (very rare!), 6, 6.5, 8.4
    barrelLengthOpt = {4, 5, 6, 6.5, 8.4},
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 6, -- 4, 6, 6.5, 8.425, 10.63
    barrelLengthOpt = { 4, 6, 6.5, 8.425, 10.63 },
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 1.875,
    barrelLengthOpt = { 1.875, 2, 3 },
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 6.5, -- 3.875, 6.5
    barrelLengthOpt = { 3.875, 6.5 },
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 25,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    barrelLength = 6.5, -- 2.25, 3, 4, 5, 6, 6.5, 8.425, 10
    barrelLengthOpt = { 2.25, 3, 4, 5, 6, 6.5, 8.425, 10 },
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.DELAYEDBLOWBACK,
    barrelLength = 6.5, -- no aditional lengths
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Large",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1993,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_AMT",
    description = "IGUI_Firearm_Desc_AutomagV"
})
register("BBPistol", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    -- TODO: autoType and barrelLength
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_AirPistol",
    year = 2007, -- unknown, earliest reference i can find for this model dates to 2008
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Daisy",
    description = "IGUI_Firearm_Desc_BBPistol",
})
register("Ber92", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.9, -- 4.7 an 4.3 for other variants (not FS)
    triggerType = ORGM.DOUBLEACTION, -- this can be DAO, depending on model
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
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 5,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1983,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Dixon",
    description = "IGUI_Firearm_Desc_BrenTen",
})
register("BrownHP", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.7,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1935,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_BrownHP",
})
register("Colt38S", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.5,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1950,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_Colt38S",
})
register("ColtDelta", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 5.03,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1987,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_ColtDelta",
})
register("CZ75", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.7,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1975,
    country = "IGUI_Firearm_Country_CZ",
    --manufacturer = "Česká zbrojovka Uherský Brod",
    manufacturer = "IGUI_Firearm_Manuf_CZUB",
    --description = "The CZ 75 is a pistol made by Česká zbrojovka Uherský Brod (CZUB) in the Czech Republic. First introduced in 1975, it is one of the original 'wonder nines' featuring a staggered-column magazine, all-steel construction, and a hammer forged barrel. It is widely distributed throughout the world. It is the most common handgun in the Czech Republic.\n"..
    description = "IGUI_Firearm_Desc_CZ75",
})
register("DEagle", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 10, -- 6, 10 or 14
    barrelLengthOpt = { 6, 10, 14 },
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Large",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_USIL",
    manufacturer = "IGUI_Firearm_Manuf_IMI",
    description = "IGUI_Firearm_Desc_DEagle",
})
register("DEagleXIX", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 10, -- 6, or 10
    barrelLengthOpt = { 6, 10 },
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Large",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_USIL",
    manufacturer = "IGUI_Firearm_Manuf_IMI",
    description = "IGUI_Firearm_Desc_DEagleXIX",
})
register("FN57", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.DELAYEDBLOWBACK,
    barrelLength = 4.8,
    triggerType = ORGM.DOUBLEACTIONONLY, -- depending on model, this can be SA (FN57 Tactical)
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
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.48,
    triggerType = ORGM.DOUBLEACTIONONLY, -- this is technically not quite true, but as close as its going to get
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock17",
})
register("Glock20", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.48,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1991,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock20",
})
register("Glock21", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.48,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1991,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock21",
})
register("Glock22", {
    lastChanged = 25,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.48,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1990,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock22",
})
register("HKMK23", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 5.87,
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2014,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kahr",
    description = "IGUI_Firearm_Desc_KahrCT40",
})
register("KahrP380", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 2.53,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1999,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kahr",
    description = "IGUI_Firearm_Desc_KahrP380",
})
register("KTP32", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 2.68,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1999,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_KelTec",
    description = "IGUI_Firearm_Desc_KTP32",
})
register("M1911", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 5.03,
    triggerType = ORGM.SINGLEACTION,
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
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 6.875,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugerMKII",
})
register("RugerSR9", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.14,
    triggerType = ORGM.DOUBLEACTIONONLY, -- like the glock, this isnt really a DAO
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2007,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugerSR9",
})
register("SIGP226", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.4,
    triggerType = ORGM.DOUBLEACTION,
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
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 5,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1985,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Springfield",
    description = "IGUI_Firearm_Desc_Spr19119",
})
register("Taurus38", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.25,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2005,
    country = "IGUI_Firearm_Country_BR",
    manufacturer = "IGUI_Firearm_Manuf_Taurus",
    description = "IGUI_Firearm_Desc_Taurus38",
})
register("TaurusP132", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 3.25,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2005,
    country = "IGUI_Firearm_Country_BR",
    manufacturer = "IGUI_Firearm_Manuf_Taurus",
    description = "IGUI_Firearm_Desc_TaurusP132",
})
register("WaltherP22", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 3.42, -- 5" target barrel
    barrelLengthOpt = {3.42, 5 },
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2002,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_Walther",
    description = "IGUI_Firearm_Desc_WaltherP22",
})
register("WaltherPPK", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 3.3,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1935,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_Walther",
    description = "IGUI_Firearm_Desc_WaltherPPK",
})
register("XD40", {
    lastChanged = 24,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4, -- 3 (compact), 4 (service), or 5 (tactical)
    barrelLengthOpt = { 3, 4, 5 },
    triggerType = ORGM.DOUBLEACTIONONLY, -- striker trigger mechanism, DAO is close enough
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
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 9, -- 9 or 18.5
    barrelLengthOpt = { 9, 18.5 },
    triggerType = ORGM.DOUBLEACTIONONLY, -- again, not really, its closer to SA, but doesnt allow for manual decocking
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
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.9,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.VERYRARE,
    isMilitary = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_MachinePistol",
    year = 1979,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Beretta",
    description = "IGUI_Firearm_Desc_Ber93R",
})
register("FNP90", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 10.4,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isMilitary = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1990,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_FNP90",
})
register("Glock18", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 4.48,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_MachinePistol",
    year = 1986,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock18",
})
register("HKMP5", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.DELAYEDBLOWBACK,
    barrelLength = 8.9,
    barrelLengthOpt = { 4.5, 5.5, 5.7, 5.8, 8.9 },
    triggerType = ORGM.DOUBLEACTIONONLY,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    selectFire = 1,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1966,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKMP5",
})
register("HKUMP", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTRECOIL,
    barrelLength = 8,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    selectFire = 1,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1999,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKUMP",
})
register("Kriss", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.DELAYEDBLOWBACK,
    barrelLength = 16,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 2009,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kriss",
    description = "IGUI_Firearm_Desc_Kriss",
})
register("KrissA", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.DELAYEDBLOWBACK,
    barrelLength = 5.5, -- 5.5 or 6.5
    barrelLengthOpt = { 5.5, 6.5 },
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 2009,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kriss",
    description = "IGUI_Firearm_Desc_KrissA",
})
register("KTPLR", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 9.25,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SMG",
    year = 2006,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_KelTec",
    description = "IGUI_Firearm_Desc_KTPLR",
})
register("M1A1", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 10.52,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "SMG",
    alwaysFullAuto = true,

    classification = "IGUI_Firearm_SMG",
    year = 1921,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_AOC",
    description = "IGUI_Firearm_Desc_M1A1",

    --skins = {'gold'},
})
register("Mac10", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 4.49,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",
    alwaysFullAuto = true,

    classification = "IGUI_Firearm_SMG",
    year = 1970,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_MAC",
    description = "IGUI_Firearm_Desc_Mac10",
})
register("Mac11", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 5.08,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",
    alwaysFullAuto = true,

    classification = "IGUI_Firearm_MachinePistol",
    year = 1972,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_MAC",
    description = "IGUI_Firearm_Desc_Mac11",
})
register("Skorpion", {
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 4.5,
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 10.2,
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    barrelLength = 26,
    triggerType = ORGM.SINGLEACTION,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.LONGGAS,
    barrelLength = 16.3,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1982,
    country = "IGUI_Firearm_Country_CN",
    manufacturer = "IGUI_Firearm_Manuf_NORINCO",
    description = "IGUI_Firearm_Desc_AKM",

})
register("AKMA", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.LONGGAS,
    barrelLength = 16.3,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1959,
    country = "IGUI_Firearm_Country_SU",
    manufacturer = "IGUI_Firearm_Manuf_Kal",
    description = "IGUI_Firearm_Desc_AKMA",
})
register("AR10", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.DIRECTGAS,
    barrelLength = 20.8,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_BattleRifle",
    year = 1956,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_ALCOLT",
    description = "IGUI_Firearm_Desc_AR10",
})
register("AR15", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.DIRECTGAS,
    barrelLength = 20, -- 16 (carbine), 20 (standard), 24 (target)
    barrelLengthOpt = { 16, 20, 24 },
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.LEVER,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    -- TODO: Barrel Length
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.LEVER,
    barrelLength = 22, -- 16, 18, 18.5, 20, 22, 24
    barrelLengthOpt = { 16, 18, 18.5, 20, 22, 24 },
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Lever",

    classification = "IGUI_Firearm_LeverRifle",
    year = 1969,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Browning",
    description = "IGUI_Firearm_Desc_BLR",
})
register("FNFAL", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 21,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1982,
    country = "IGUI_Firearm_Country_AR",
    manufacturer = "IGUI_Firearm_Manuf_FMAP",
    description = "IGUI_Firearm_Desc_FNFAL",
})
register("FNFALA", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 21, -- 17.2, 18, 21
    barrelLengthOpt = { 17.2, 18, 21 },
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_BattleRifle",
    year = 1953,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_FNFALA",
})
register("Garand", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.LONGGAS,
    barrelLength = 24,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Auto",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1934,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Springfield",
    description = "IGUI_Firearm_Desc_Garand",
})
register("HenryBB", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.LEVER,
    barrelLength = 20,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-Lever",

    classification = "IGUI_Firearm_LeverRifle",
    year = 2001,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Henry",
    description = "IGUI_Firearm_Desc_HenryBB",
})
register("HK91", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.DELAYEDBLOWBACK,
    barrelLength = 19.7,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1974,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HK91",
})
register("HKG3", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.DELAYEDBLOWBACK,
    barrelLength = 17.7,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_BattleRifle",
    year = 1958,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKG3",
})
register("HKSL8", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 20.08,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1998,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKSL8",
})
register("L96", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    barrelLength = 26,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1982,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_AI",
    description = "IGUI_Firearm_Desc_L96",
})
register("LENo4", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    barrelLength = 25.2,
    triggerType = ORGM.SINGLEACTION,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.DIRECTGAS,
    barrelLength = 20,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "Rifle-AR",
    selectFire = ORGM.FULLAUTOMODE,

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1964,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_M16",
})
register("M1903", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    barrelLength = 24,
    triggerType = ORGM.SINGLEACTION,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 22,
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.LONGGAS,
    barrelLength = 21, -- 18 or 21
    barrelLengthOpt = { 18, 21 },
    triggerType = ORGM.DOUBLEACTIONONLY,
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-Auto",
    clickSound = 'ORGMRifleEmpty',
    ejectSound = 'ORGMLMGOut',
    insertSound = 'ORGMLMGIn',
    rackSound = 'ORGMLMGRack',
    alwaysFullAuto = true,

    classification = "IGUI_Firearm_LMG",
    year = 1979,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_FN2",
    description = "IGUI_Firearm_Desc_M249",
})
register("M4C", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.DIRECTGAS,
    barrelLength = 14.5,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    selectFire = 1,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultCarbine",
    year = 1984,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_M4C",
})
register("Marlin60", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 19, -- 19 or 22 (pre-1985)
    barrelLengthOpt = { 19, 22 },
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.LONGGAS,
    barrelLength = 18.5, -- 16.12 (tactical), 18.5, 22 (target)
    barrelLengthOpt = { 16.12, 18.5, 22 },
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    barrelLength = 29, -- 22.2 carbine, 26.2, 29
    barrelLengthOpt = { 22.2, 26.2, 29 },
    triggerType = ORGM.SINGLEACTION,
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
    lastChanged = 27,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.DIRECTGAS,
    barrelLength = 20,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 2008,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_R25",
})
register("Rem700", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    barrelLength = 24, -- varies widely from 16.5 to 26 depending on model and caliber. the .30-06's seem mostly in 24"
    barrelLengthOpt = {16.5, 18, 20, 22, 24, 26 },
    triggerType = ORGM.SINGLEACTION,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    barrelLength = 24, -- 18.5, 22, 24
    barrelLengthOpt = { 18.5, 22, 24 },
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1967,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_Rem788",
})
register("Rug1022", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.BLOWBACK,
    barrelLength = 18.5,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1964,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_Rug1022",
})
register("SA80", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 20.4, -- 11.2, 20.4, 25.4
    barrelLengthOpt = { 11.2, 20.4, 25.4 },
    triggerType = ORGM.DOUBLEACTIONONLY,
    isMilitary = ORGM.RARE,
    selectFire = 1,
    soundProfile = "Rifle-AR",
    isBulpup = true,

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1985,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_RSAF",
    description = "IGUI_Firearm_Desc_SA80",
})
register("SIG550", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.LONGGAS,
    barrelLength = 20.8,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1986,
    country = "IGUI_Firearm_Country_CH",
    manufacturer = "IGUI_Firearm_Manuf_SIG2",
    description = "IGUI_Firearm_Desc_SIG550",
})
register("SIG551", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.LONGGAS,
    barrelLength = 20.8,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultCarbine",
    year = 1986,
    country = "IGUI_Firearm_Country_CH",
    manufacturer = "IGUI_Firearm_Manuf_SIG2",
    description = "IGUI_Firearm_Desc_SIG551",
})
register("SKS", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 20, -- 20 or 22
    barrelLengthOpt = { 20, 22 },
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.DIRECTGAS,
    barrelLength = 24,
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 24.4,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-Auto",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1963,
    country = "IGUI_Firearm_Country_SU",
    manufacturer = "IGUI_Firearm_Manuf_Kal2",
    description = "IGUI_Firearm_Desc_SVD",
})
register("WinM70", {
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    barrelLength = 24, -- 22, 24, 26
    barrelLengthOpt = { 22, 24, 26 },
    triggerType = ORGM.SINGLEACTION,
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
    lastChanged = 24,
    category = ORGM.RIFLE,
    actionType = ORGM.LEVER,
    barrelLength = 20,
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.LONGRECOIL, -- actually Inertia
    barrelLength = 22, -- 20 22, 24
    barrelLengthOpt = { 20, 22, 24 },
    triggerType = ORGM.DOUBLEACTIONONLY,
    altActionType = ORGM.PUMP,
    isPolice = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_DualShotgun",
    year = 1989,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Benelli",
    description = "IGUI_Firearm_Desc_BenelliM3",
})
register("BenelliM3SO", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.LONGRECOIL,
    barrelLength = 18, -- cant saw off much with that magazine tube, the connecting brace is very forward
    triggerType = ORGM.DOUBLEACTIONONLY,
    altActionType = ORGM.PUMP,
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("BenelliM3").classification,
    year = ORGM.Firearm.getData("BenelliM3").year,
    country = ORGM.Firearm.getData("BenelliM3").country,
    manufacturer = ORGM.Firearm.getData("BenelliM3").manufacturer,
    description = ORGM.Firearm.getData("BenelliM3").description,
})
register("BenelliXM1014", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.LONGRECOIL,
    barrelLength = 18.5,
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    barrelLength = 18.5,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 2008,
    country = "IGUI_Firearm_Country_CN",
    manufacturer = "IGUI_Firearm_Manuf_NORINCO",
    description = "IGUI_Firearm_Desc_Hawk982",
})
register("Ithaca37", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    barrelLength = 20, -- 18.5, 20, -- all the way up to 30
    barrelLengthOpt = { 18.5, 20, 22, 24, 26, 28, 30 },
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 1937,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ithaca",
    description = "IGUI_Firearm_Desc_Ithaca37",
})
register("Ithaca37SO", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    barrelLength = 14, -- sawn off
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("Ithaca37").classification,
    year = ORGM.Firearm.getData("Ithaca37").year,
    country = ORGM.Firearm.getData("Ithaca37").country,
    manufacturer = ORGM.Firearm.getData("Ithaca37").manufacturer,
    description = ORGM.Firearm.getData("Ithaca37").description,
})
register("M1216", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.DELAYEDBLOWBACK,
    barrelLength = 18,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiShotgun",
    year = 2012,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SRM",
    description = "IGUI_Firearm_Desc_M1216",
})
register("Moss590", {
    lastChanged = 27,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    barrelLength = 20,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 1960,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Moss",
    description = "IGUI_Firearm_Desc_Moss590",
})
register("Moss590SO", {
    lastChanged = 27,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    barrelLength = 18.5,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("Moss590").classification,
    year = ORGM.Firearm.getData("Moss590").year,
    country = ORGM.Firearm.getData("Moss590").country,
    manufacturer = ORGM.Firearm.getData("Moss590").manufacturer,
    description = ORGM.Firearm.getData("Moss590").description,
})
register("Rem870", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    barrelLength = 26,
    barrelLengthOpt = {20, 22, 24, 26 },
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    barrelLength = 14,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("Rem870").classification,
    year = ORGM.Firearm.getData("Rem870").year,
    country = ORGM.Firearm.getData("Rem870").country,
    manufacturer = ORGM.Firearm.getData("Rem870").manufacturer,
    description = ORGM.Firearm.getData("Rem870").description,
})
register("Silverhawk", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.BREAK,
    barrelLength = 28,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun-Break",

    classification = "IGUI_Firearm_DoubleShotgun",
    year = 1996,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Beretta",
    description = "IGUI_Firearm_Desc_Silverhawk",
})
register("SilverHawkSO", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.BREAK,
    barrelLength = 10,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun-Break",

    classification = ORGM.Firearm.getData("Silverhawk").classification,
    year = ORGM.Firearm.getData("Silverhawk").year,
    country = ORGM.Firearm.getData("Silverhawk").country,
    manufacturer = ORGM.Firearm.getData("Silverhawk").manufacturer,
    description = ORGM.Firearm.getData("Silverhawk").description
})
register("Spas12", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
    autoType = ORGM.SHORTGAS,
    barrelLength = 21.5, -- 18, 19-7/8,21.5, 24 -- 21.5 is the shortest we can go with our mag tube
    barrelLengthOpt = { 21.5, 24 },
    triggerType = ORGM.DOUBLEACTIONONLY,
    altActionType = ORGM.PUMP,
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
    lastChanged = 28,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    barrelLength = 18.5,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 2012,
    country = "IGUI_Firearm_Country_CN",
    manufacturer = "IGUI_Firearm_Manuf_SA",
    description = "IGUI_Firearm_Desc_Stevens320"
})
register("Striker", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.ROTARY,
    barrelLength = 18.5, -- 7.5, 12, 14, 18.5
    barrelLengthOpt = { 7.5, 12, 14, 18.5 },
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
    barrelLength = 22.44, -- 19, 22.44, 26.5
    barrelLengthOpt = { 19, 22.44, 26.5 },
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.LEVER,
    barrelLength = 30, -- 18, 20, 30
    barrelLengthOpt = { 18, 20, 30 },
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Shotgun-Lever",

    classification = "IGUI_Firearm_LeverShotgun",
    year = 1887,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_WRA",
    description = "IGUI_Firearm_Desc_Win1887"
})
register("Win1887SO", {
    lastChanged = 24,
    category = ORGM.SHOTGUN,
    actionType = ORGM.LEVER,
    barrelLength = 14,
    triggerType = ORGM.DOUBLEACTIONONLY,
    soundProfile = "Shotgun-Lever",

    classification = ORGM.Firearm.getData("Win1887").classification,
    year = ORGM.Firearm.getData("Win1887").year,
    country = ORGM.Firearm.getData("Win1887").country,
    manufacturer = ORGM.Firearm.getData("Win1887").manufacturer,
    description = ORGM.Firearm.getData("Win1887").description,
})

-- ORGM[15] = "138363034"
ORGM.log(ORGM.INFO, "All default firearms registered.")

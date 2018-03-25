--[[
    This file contains all the default firearm data
]]

--[[  ORGM.registerFirearm(name, definition)

    Registers a firearm type with ORGM.
    
    name = string name of the firearm (without module prefix)
    definition = a table containing the firearm stats. Valid table keys/value pairs are:
        moduleName = nil, or string module name this item is from. If nil, ORGM is used
        actionType = ORGM.AUTO | ORGM.BOLT | ORGM.LEVER | ORGM.PUMP | ORGM.BREAK | ORGM.ROTARY
        triggerType = ORGM.SINGLEACTION | ORGM.DOUBLEACTION | ORGM.DOUBLEACTIONONLY
        lastChanged = nil| integer > 0 <= ORGM.BUILD_ID, the ORGM version this firearm was
            last changed in (see shared\1LoadOrder\ORGMCore.lua)
        rackTime = nil | integer > 0, if nil then ORGM.Settings.DefaultRackTime is used
        reloadTime = nil | integer > 0, if nil then ORGM.Settings.DefaultReloadTime is used
        selectFire = nil | ORGM.SEMIAUTOMODE | ORGM.FULLAUTOMODE
        speedLoader = nil | string name of registered magazine
        isCivilian = nil | ORGM.COMMON | ORGM.RARE | ORGM.VERYRARE
        isPolice = nil | ORGM.COMMON | ORGM.RARE | ORGM.VERYRARE
        isMilitary = nil | ORGM.COMMON | ORGM.RARE | ORGM.VERYRARE
        
        -- sound options
        soundProfile = string name of a key in ORGM.SoundProfiles (see shared\1LoadOrder\ORGMCore.lua)
        
        -- these sound keys are automatically set by the soundProfile, but can be over written.
        -- they are all nil or the string name of a sound file in media/sound/*.ogg
        clickSound = nil | filename
        insertSound = nil | filename
        ejectSound = nil | filename
        rackSound = nil | filename
        openSound = nil | filename
        closeSound = nil | filename
        cockSound = nil | filename
        
        -- firearm details, these string fill out the 'Inspection' window.  
        classification = nil | string, the 'type' of weapon (Revolver, Assault Rifle, etc)
        country = nil | string, the initial country of manufacture
        manufacturer = nil | string, the initial company (or factory) of manufacture
        year = nil | integer, the initial year of manufacture, this is used by ORGM.Settings.LimitYear
        description = nil | string, background information

]]
local register = ORGM.registerFirearm

register("ColtAnac", {
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader3576', 
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1985,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugGP100",
})
register("RugRH", {
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader386', 
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1899,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM10",
})
register("SWM19", {
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader446',
    soundProfile = "Revolver",
    
    classification = "IGUI_Firearm_Revolver",
    year = 1955,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM29",
})
register("SWM36", {
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
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
    lastChanged = 22,
    category = ORGM.REVOLVER,
    actionType = ORGM.ROTARY,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader4546', 
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.RARE,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY, -- depending on model, this can be SA (FN57 Tactical)
    isCivilian = ORGM.RARE,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1998,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_FN57",
})
register("Glock17", {
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1991,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKMK23",
})
register("KahrCT40", {
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.COMMON, 
    isMilitary = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1983,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_SIG",
    description = "IGUI_Firearm_Desc_SIGP226",
})
register("Spr19119", {
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.PISTOL,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTION,
    isCivilian = ORGM.VERYRARE,
    selectFire = 1,
    soundProfile = "Pistol-Small",
    
    classification = "IGUI_Firearm_MachinePistol",
    year = 1979,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Beretta",
    description = "IGUI_Firearm_Desc_Ber93R",
})
register("FNP90", {
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isPolice = ORGM.RARE, 
    isMilitary = ORGM.RARE,
    selectFire = 1,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1990,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_FNP90",
})
register("Glock18", {
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isPolice = ORGM.RARE, 
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
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isPolice = ORGM.RARE, 
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
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",
    alwaysFullAuto = true,

    classification = "IGUI_Firearm_SMG",
    year = 1921,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_AOC",
    description = "IGUI_Firearm_Desc_M1A1",
})
register("Mac10", {
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Pistol-Small",
    alwaysFullAuto = true,
    
    classification = "IGUI_Firearm_MachinePistol",
    year = 1961,
    country = "IGUI_Firearm_Country_CZ",
    --manufacturer = "Česká zbrojovka Uherský Brod",
    manufacturer = "IGUI_Firearm_Manuf_CZUB",
    description = "IGUI_Firearm_Desc_Skorpion",
})
register("Uzi", {
    lastChanged = 22,
    category = ORGM.SUBMACHINEGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isPolice = ORGM.RARE,
    selectFire = 1,
    soundProfile = "Rifle-AR",
    
    classification = "IGUI_Firearm_BattleRifle",
    year = 1956,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_ALCOLT",
    description = "IGUI_Firearm_Desc_AR10",
})
register("AR15", {
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-AR",
    
    classification = "IGUI_Firearm_SemiRifle",
    year = 1963,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_AR15",
})
register("BBGun", {
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.LEVER,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.LEVER,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.LEVER,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE,
    speedLoader = "LENo4StripperClip", 
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1941,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_LBASS",
    description = "IGUI_Firearm_Desc_LENo4",
})
register("M16", {
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isPolice = ORGM.RARE, 
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isPolice= ORGM.RARE, 
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-Bolt",
    
    classification = "IGUI_Firearm_BoltRifle",
    year = 1967,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_Rem788",
})
register("Rug1022", {
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isMilitary = ORGM.RARE,
    selectFire = 1,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1985,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_RSAF",
    description = "IGUI_Firearm_Desc_SA80",
})
register("SIG550", {
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isMilitary = ORGM.COMMON,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1990,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_KAC",
    description = "IGUI_Firearm_Desc_SR25",
})
register("SVD", {
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.BOLT,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.RARE, 
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-Bolt-IM",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1936,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_WRA",
    description = "IGUI_Firearm_Desc_WinM70",
})
register("WinM94", {
    lastChanged = 22,
    category = ORGM.RIFLE,
    actionType = ORGM.LEVER,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    altActionType = ORGM.PUMP,
    soundProfile = "Shotgun",

    classification = ORGM.FirearmTable["BenelliM3"].classification,
    year = ORGM.FirearmTable["BenelliM3"].year,
    country = ORGM.FirearmTable["BenelliM3"].country,
    manufacturer = ORGM.FirearmTable["BenelliM3"].manufacturer,
    description = ORGM.FirearmTable["BenelliM3"].description,
})
register("BenelliXM1014", {
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.FirearmTable["Ithaca37"].classification,
    year = ORGM.FirearmTable["Ithaca37"].year,
    country = ORGM.FirearmTable["Ithaca37"].country,
    manufacturer = ORGM.FirearmTable["Ithaca37"].manufacturer,
    description = ORGM.FirearmTable["Ithaca37"].description,
})
register("M1216", {
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.FirearmTable["Moss590"].classification,
    year = ORGM.FirearmTable["Moss590"].year,
    country = ORGM.FirearmTable["Moss590"].country,
    manufacturer = ORGM.FirearmTable["Moss590"].manufacturer,
    description = ORGM.FirearmTable["Moss590"].description,
})
register("Rem870", {
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.FirearmTable["Rem870"].classification,
    year = ORGM.FirearmTable["Rem870"].year,
    country = ORGM.FirearmTable["Rem870"].country,
    manufacturer = ORGM.FirearmTable["Rem870"].manufacturer,
    description = ORGM.FirearmTable["Rem870"].description,
})
register("Silverhawk", {
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.BREAK,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.BREAK,
    triggerType = ORGM.SINGLEACTION,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun-Break",

    classification = ORGM.FirearmTable["Silverhawk"].classification,
    year = ORGM.FirearmTable["Silverhawk"].year,
    country = ORGM.FirearmTable["Silverhawk"].country,
    manufacturer = ORGM.FirearmTable["Silverhawk"].manufacturer,
    description = ORGM.FirearmTable["Silverhawk"].description
})
register("Spas12", {
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
    triggerType = ORGM.DOUBLEACTIONONLY,
    altActionType = ORGM.PUMP,
    isCivilian = ORGM.RARE, 
    isPolice = ORGM.RARE, 
    isMilitary = ORGM.RARE,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_DualShotgun",
    year = nil,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Luigi",
    description = "IGUI_Firearm_Desc_Spas12",
})
register("Stevens320", {
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.PUMP,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.ROTARY,
    triggerType = ORGM.DOUBLEACTIONONLY,
    isCivilian = ORGM.RARE, 
    isPolice = ORGM.RARE,
    soundProfile = "Shotgun",
    rackSound = 'ORGMARRack', 

    classification = "IGUI_Firearm_SemiShotgun",
    year = 1983,
    country = "IGUI_Firearm_Country_ZA",
    manufacturer = "IGUI_Firearm_Manuf_ASARDI",
    description = "IGUI_Firearm_Desc_Striker",
})
register("VEPR12", {
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.AUTO,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.LEVER,
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
    lastChanged = 22,
    category = ORGM.SHOTGUN,
    actionType = ORGM.LEVER,
    triggerType = ORGM.DOUBLEACTIONONLY,
    soundProfile = "Shotgun-Lever",

    classification = ORGM.FirearmTable["Win1887"].classification,
    year = ORGM.FirearmTable["Win1887"].year,
    country = ORGM.FirearmTable["Win1887"].country,
    manufacturer = ORGM.FirearmTable["Win1887"].manufacturer,
    description = ORGM.FirearmTable["Win1887"].description,
})

ORGM.log(ORGM.INFO, "All default firearms registered.")